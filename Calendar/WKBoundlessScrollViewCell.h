//
//  WKBoundlessScrollViewCell.h
//  Calendar
//
//  Created by macairwkcao on 15/12/16.
//  Copyright © 2015年 CWK. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CellDateModel;


@interface WKBoundlessScrollViewCell : UIView


@property(nonatomic,copy)NSString *identifier;
@property(nonatomic,assign)NSInteger deviation;
@property(nonatomic,strong)UILabel *label;
-(instancetype)initWithIdentifier:(NSString *)identifier;
-(void)fillDate:(CellDateModel *)cellDateModel;


@end
