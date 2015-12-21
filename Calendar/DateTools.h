//
//  DateTools.h
//  Calendar
//
//  Created by macairwkcao on 15/12/18.
//  Copyright © 2015年 CWK. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CellDateModel;
@interface DateTools : NSObject

+(CellDateModel *)dateToCell:(NSInteger)deviation;
+(NSInteger)getDrawRow:(NSInteger)deviation;
+(NSDateComponents *)getCurrentDate;
+(NSDateComponents *)getCellMonthDate:(NSInteger)deviation;

@end
