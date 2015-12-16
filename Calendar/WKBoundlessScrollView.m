//
//  WKBoundlessScrollView.m
//  Calendar
//
//  Created by macairwkcao on 15/12/15.
//  Copyright © 2015年 CWK. All rights reserved.
//

#import "WKBoundlessScrollView.h"
#import "WKBoundlessScrollViewCell.h"


@interface WKBoundlessScrollViewCell (SelectResponer)

@end

@implementation WKBoundlessScrollViewCell (SelectResponer)

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UIColor *color = self.backgroundColor;
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [UIColor lightGrayColor];
    } completion:^(BOOL finished) {
        self.backgroundColor = color;
    }];
    [self.nextResponder touchesBegan:touches withEvent:event];
}


@end



@interface WKBoundlessScrollView ()

//@property (nonatomic, strong) NSMutableArray *visibleSubViews;
@property (nonatomic, strong) UIView *subViewContainerView;
@property(nonatomic,strong)NSMutableArray*  visiableCells;

@property(nonatomic,strong)NSMutableDictionary* reusableTableCells;
@property(nonatomic,assign)NSInteger deviation;
@end

@implementation WKBoundlessScrollView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _deviation = 0;
        self.contentSize = CGSizeMake(self.frame.size.width, 8000);
        _visiableCells = [[NSMutableArray alloc] init];
        _reusableTableCells = [[NSMutableDictionary alloc] initWithCapacity:2];
        _subViewContainerView = [[UIView alloc] init];
//        _subViewContainerView.backgroundColor = [UIColor redColor];
        self.subViewContainerView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
        [self addSubview:self.subViewContainerView];
        
        [self.subViewContainerView setUserInteractionEnabled:YES];
        
        // hide horizontal scroll indicator so our recentering trick is not revealed
        [self setShowsVerticalScrollIndicator:NO];
    }
    return self;
}

#pragma mark - Layout

// recenter content periodically to achieve impression of infinite scrolling
- (void)recenterIfNecessary
{
    CGPoint currentOffset = [self contentOffset];
    CGFloat contentHeight = [self contentSize].height;
    CGFloat centerOffsetY = (contentHeight - [self bounds].size.height) / 2.0;
    CGFloat distanceFromCenter = fabs(currentOffset.y - centerOffsetY);
    
    if (distanceFromCenter > (contentHeight/4.0))
    {
        self.contentOffset = CGPointMake(currentOffset.x, centerOffsetY);
        
        // move content by the same amount so it appears to stay still
        for (UIView *view in self.visiableCells) {
            CGPoint center = [self.subViewContainerView convertPoint:view.center toView:self];
            center.y += (centerOffsetY - currentOffset.y);
            view.center = [self convertPoint:center toView:self.subViewContainerView];
        }
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self recenterIfNecessary];

    
    CGRect visibleBounds = [self convertRect:[self bounds] toView:self.subViewContainerView];
    CGFloat minimumVisibleY = CGRectGetMinY(visibleBounds);
    CGFloat maximumVisibleY = CGRectGetMaxY(visibleBounds);
    
    [self tileLabelsFromMinY:minimumVisibleY toMaxY:maximumVisibleY];
}


#pragma mark - Label Tiling

- (WKBoundlessScrollViewCell *)insertCell:(NSInteger)deviation
{
    WKBoundlessScrollViewCell *cell = [self.delegateForCell boundlessScrollViewCellWithDeviation:deviation boundlessScrollView:self];
    cell.deviation = _deviation;
    
    [self.subViewContainerView addSubview:cell];
    
    return cell;
}

- (CGFloat)placeNewViewOnBottom:(CGFloat)bottomEdge
{
    WKBoundlessScrollViewCell *cell = [self insertCell:_deviation];
    [self.visiableCells addObject:cell];

    CGRect frame = [cell frame];
    frame.origin.y = bottomEdge;
    frame.origin.x = [self.subViewContainerView bounds].size.width - frame.size.width;
    if ([self.delegateForCell respondsToSelector:@selector(boundlessScrollViewCellHeight:deviation:)]) {
        CGFloat height = [self.delegateForCell boundlessScrollViewCellHeight:self deviation:_deviation];
        frame.size.height = height;
    }
    _deviation++;

    
    [cell setFrame:frame];
    
    return CGRectGetMaxY(frame);
}

- (CGFloat)placeNewViewOnTop:(CGFloat)topEdge
{
    WKBoundlessScrollViewCell *cell = [self insertCell:_deviation];
    [self.visiableCells insertObject:cell atIndex:0]; // add leftmost label at the beginning of the array
    CGRect frame = [cell frame];
    frame.origin.y = topEdge - frame.size.height;
    frame.origin.x = [self.subViewContainerView bounds].size.width - frame.size.width;
    if ([self.delegateForCell respondsToSelector:@selector(boundlessScrollViewCellHeight:deviation:)]) {
        CGFloat height = [self.delegateForCell boundlessScrollViewCellHeight:self deviation:_deviation];
        frame.size.height = height;
    }
    [cell setFrame:frame];
    _deviation--;

    return CGRectGetMinY(frame);
}



- (void)tileLabelsFromMinY:(CGFloat)minimumVisibleY toMaxY:(CGFloat)maximumVisibleY
{
    // the upcoming tiling logic depends on there already being at least one label in the visibleLabels array, so
    // to kick off the tiling we need to make sure there's at least one label
    if ([self.visiableCells count] == 0)
    {
        [self placeNewViewOnBottom:minimumVisibleY];
    }
    
    // add labels that are missing on right side
    WKBoundlessScrollViewCell *lastCell = [self.visiableCells lastObject];
    CGFloat bottomEdge = CGRectGetMaxY([lastCell frame]);
    while (bottomEdge < maximumVisibleY)
    {
        bottomEdge = [self placeNewViewOnBottom:bottomEdge];
    }
    
    // add labels that are missing on left side
    WKBoundlessScrollViewCell *firstCell = self.visiableCells[0];
    CGFloat topEdge = CGRectGetMinY([firstCell frame]);
    while (topEdge > minimumVisibleY)
    {
        topEdge = [self placeNewViewOnTop:topEdge];
    }
    
    // remove labels that have fallen off right edge
    lastCell = [self.visiableCells lastObject];
    while ([lastCell frame].origin.y > maximumVisibleY)
    {
        [lastCell removeFromSuperview];
        [self.visiableCells removeLastObject];
        [self addReusableTableCellsObject:lastCell];
        
        lastCell = [self.visiableCells lastObject];
    }
    
    // remove labels that have fallen off left edge
    firstCell = self.visiableCells[0];
    while (CGRectGetMaxY([firstCell frame]) < minimumVisibleY)
    {
        [firstCell removeFromSuperview];
        [self.visiableCells removeObjectAtIndex:0];
        [self addReusableTableCellsObject:firstCell];
        firstCell = self.visiableCells[0];
    }
}

-(WKBoundlessScrollViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    NSMutableArray *cellArray = [self.reusableTableCells objectForKey:identifier];
    if (cellArray.count <= 0) {
        return nil;
    }
    WKBoundlessScrollViewCell *cell = [cellArray objectAtIndex:0];
    [cellArray removeObject:cell];
    return cell;
}

-(void)addReusableTableCellsObject:(WKBoundlessScrollViewCell *)cell
{
    NSString *identifier = cell.identifier;
    NSMutableArray *mutableArray = [self.reusableTableCells objectForKey:identifier];
    if (mutableArray == nil) {
         mutableArray = [[NSMutableArray alloc] initWithCapacity:10];
        [self.reusableTableCells setObject:mutableArray forKey:identifier];
    }
    [mutableArray addObject:cell];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
//    WKBoundlessScrollViewCell *cell = (WKBoundlessScrollViewCell *)touches[0].view;
    NSArray *array = [touches allObjects];
    for (UITouch * touch in array) {
        if ([touch.view isKindOfClass:[WKBoundlessScrollViewCell class]]) {
           WKBoundlessScrollViewCell* cell = (WKBoundlessScrollViewCell *)(touch.view);
            if ([self.delegateForCell respondsToSelector:@selector(didSelectedWithDeviation:)]) {
                [self.delegateForCell didSelectedWithDeviation:cell.deviation];
            }
        }
    }
}

@end



