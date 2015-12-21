//
//  DateView.h
//  Calendar
//
//  Created by macairwkcao on 15/12/18.
//  Copyright © 2015年 CWK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DateModel;
@interface DateView : UIView
@property(nonatomic,strong)UILabel *solarCalendarLabel;
@property(nonatomic,strong)UILabel *lunarCalendarLabel;
@property(nonatomic,strong)DateModel *dateModel;

-(void)fillDate:(DateModel *)dateModel;
@end
