//
//  WKBoundlessScrollViewCell.m
//  Calendar
//
//  Created by macairwkcao on 15/12/16.
//  Copyright © 2015年 CWK. All rights reserved.
//

#import "WKBoundlessScrollViewCell.h"

@implementation WKBoundlessScrollViewCell
-(instancetype)initWithIdentifier:(NSString *)identifier
{
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
    self = [super initWithFrame:frame];
    if (self) {
        self.identifier = identifier;
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 40, 40)];

    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
    
    
    self.label.backgroundColor = [UIColor blueColor];
    [self addSubview:self.label];
}

-(void)setDeviation:(NSInteger)deviation
{
    _deviation = deviation;
    self.label.text = [NSString stringWithFormat:@"%d",_deviation];
}

@end
