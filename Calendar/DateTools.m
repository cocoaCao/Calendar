//
//  DateTools.m
//  Calendar
//
//  Created by macairwkcao on 15/12/18.
//  Copyright © 2015年 CWK. All rights reserved.
//

#import "DateTools.h"
#import "CellDateModel.h"
#import "DateModel.h"

@implementation DateTools
+(CellDateModel *)dateToCell:(NSInteger)deviation
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:30];
    
    NSDateComponents *components = [DateTools getCellMonthDate:deviation];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSInteger weekday = [components weekday];
    NSInteger monthDays = [DateTools getMonthDays:month year:year];
    CellDateModel *cellDateModel = [[CellDateModel alloc] init];
    cellDateModel.year = year;
    cellDateModel.month = month;
    cellDateModel.monthDays = monthDays;
    cellDateModel.beginWeekDay = weekday;
    
    NSInteger row = 0;
    NSInteger dayBeginIndex = weekday-1;
    if((monthDays + dayBeginIndex)%7 == 0){
        row = (monthDays + dayBeginIndex)/7;
    }else{
        row = (monthDays + dayBeginIndex)/7 + 1;
    }
    cellDateModel.drawDayRow = row;
    cellDateModel.drawDayBeginIndex = dayBeginIndex;
    for (int i = 0; i < monthDays; i++) {
        DateModel *dateModel = [[DateModel alloc] init];
        dateModel.year = year;
        dateModel.month = month;
        dateModel.day = day;
        dateModel.weekday = (dayBeginIndex+day-1)%7;
        dateModel.lunarDay = [self getChineseCalendarWithDate:day month:month year:year];
        day++;
        [array addObject:dateModel];
    }
    cellDateModel.dateModelArray = array;
    return cellDateModel;
}


+(NSInteger)getDrawRow:(NSInteger)deviation
{
    NSDateComponents *components = [DateTools getCellMonthDate:deviation];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger weekday = [components weekday];
    NSInteger monthDays = [DateTools getMonthDays:month year:year];
    NSInteger row = 0;
    NSInteger dayBeginIndex = weekday-1;
    if((monthDays + dayBeginIndex)%7 == 0){
        row = (monthDays + dayBeginIndex)/7;
    }else{
        row = (monthDays + dayBeginIndex)/7 + 1;
    }
    return row;
}


+(NSDateComponents *)getCurrentDate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *now;
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    now = [NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    return comps;
}


+(NSDateComponents *)getCellMonthDate:(NSInteger)deviation
{
    NSDateComponents *comps = [DateTools getCurrentDate];
    NSInteger month = [comps month];
    NSInteger year = [comps year];
    NSInteger yearDeviation;
    NSInteger monthDeviation;
    if (deviation>0) {
        yearDeviation = deviation/12;
        monthDeviation = deviation%12;
        if (monthDeviation+month >12 ) {
            month = monthDeviation + month - 12;
            yearDeviation++;
        }
        else{
            month = month + monthDeviation;
        }
    }
    else
    {
        yearDeviation = deviation/12;
        monthDeviation = deviation%12;
        if (monthDeviation+month < 0) {
            month = month - monthDeviation -12;
            yearDeviation--;
        }
        else{
            month = month + monthDeviation;
        }
    }
    year = year+yearDeviation;
    NSString* string;
    if(month<10)
    {
        string = [NSString stringWithFormat:@"%ld0%ld01",year,month];
    }
    else
    {
        string = [NSString stringWithFormat:@"%ld%ld01",year,month];
    }
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    inputFormatter.timeZone = [NSTimeZone systemTimeZone];
    [inputFormatter setDateFormat:@"yyyyMMdd"];
    NSDate* inputDate = [inputFormatter dateFromString:string];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    components = [calendar components:unitFlags fromDate:inputDate];
    return components;
}

+(NSInteger)getMonthDays:(NSInteger)month year:(NSInteger)year
{
    if (month<=0 || month > 12) {
        return 0;
    }
    BOOL isLeapYear = [DateTools isLeapYear:year];
    int  februaryDay;
    if (isLeapYear) {
        februaryDay = 29;
    }
    else
    {
        februaryDay = 28;
    }
    
    if (month == 1||month == 3||month == 5||month == 7||month == 8||month == 10||month == 12) {
        return 31;
    } else if (month == 4||month ==6||month ==9||month ==11) {
        return 30;
    }else {
        return februaryDay;
    }
}

+(BOOL)isLeapYear:(NSInteger)year{
    if ((year % 4  == 0 && year % 100 != 0)|| year % 400 == 0)
        return YES;
    else
        return NO;
}

+(NSString*)getChineseCalendarWithDate:(NSInteger)day month:(NSInteger)month year:(NSInteger)year{
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    NSString* string;
    if(month<10)
    {
        if (day < 10) {
            string = [NSString stringWithFormat:@"%ld0%ld0%ld23",year,month,day];
        }
        else{
            string = [NSString stringWithFormat:@"%ld0%ld%ld23",year,month,day];
        }
    }
    else
    {
        if (day < 10) {
            string = [NSString stringWithFormat:@"%ld%ld0%ld23",year,month,day];
        }
        else{
            string = [NSString stringWithFormat:@"%ld%ld%ld23",year,month,day];
        }
    }
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyyMMddHH"];
    NSDate* inputDate = [inputFormatter dateFromString:string];
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:inputDate];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    return d_str;
}

@end
