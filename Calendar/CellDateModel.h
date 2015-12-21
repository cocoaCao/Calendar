//
//  CellDateModel.h
//  Calendar
//
//  Created by macairwkcao on 15/12/18.
//  Copyright © 2015年 CWK. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DateModel;
@interface CellDateModel : NSObject
@property(nonatomic,strong)NSArray <__kindof DateModel *> *dateModelArray;
@property(nonatomic,assign)NSInteger drawDayBeginIndex;
@property(nonatomic,assign)NSInteger drawDayRow;
@property(nonatomic,assign)NSInteger year;
@property(nonatomic,assign)NSInteger month;
@property(nonatomic,assign)NSInteger monthDays;
@property(nonatomic,assign)NSInteger beginWeekDay;
@end
