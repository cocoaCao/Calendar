//
//  WKBoundlessScrollView.h
//  Calendar
//
//  Created by macairwkcao on 15/12/15.
//  Copyright © 2015年 CWK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKBoundlessScrollView;
@class WKBoundlessScrollViewCell;



@protocol WKBoundlessScrollViewDelegate <NSObject>

-(WKBoundlessScrollViewCell *)boundlessScrollViewCellWithDeviation:(NSInteger)deviation  boundlessScrollView:(WKBoundlessScrollView *)boundlessScrollView;

@optional
-(CGFloat)boundlessScrollViewCellHeightWithdeviation:(NSInteger)deviation boundlessScrollView:(WKBoundlessScrollView *)boundlessScrollView  ;

-(void)didSelectedWithDeviation:(NSInteger)deviation boundlessScrollView:(WKBoundlessScrollView *)boundlessScrollView;

-(void)boundlessScrollViewArriveTopVisible:(NSInteger)deviation;

@end







@interface WKBoundlessScrollView : UIScrollView

@property(nonatomic,assign)id<WKBoundlessScrollViewDelegate> delegateForCell;

-(WKBoundlessScrollViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;
@end

