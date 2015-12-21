//
//  DateModel.h
//  Calendar
//
//  Created by macairwkcao on 15/12/18.
//  Copyright © 2015年 CWK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateModel : NSObject

@property(nonatomic,assign)NSInteger day;
@property(nonatomic,assign)NSInteger month;
@property(nonatomic,assign)NSInteger year;
@property(nonatomic,assign)NSInteger weekday;
@property(nonatomic,assign)NSString *lunarDay;

@end
