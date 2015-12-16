//
//  ViewController.m
//  Calendar
//
//  Created by macairwkcao on 15/12/15.
//  Copyright © 2015年 CWK. All rights reserved.
//

#import "ViewController.h"
#import "WKBoundlessScrollView.h"
#import "WKBoundlessScrollViewCell.h"
@interface ViewController ()<WKBoundlessScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    int i = 0;
    i--;
    NSLog(@"%d",i);
    
    WKBoundlessScrollView *boundlessScrollView = [[WKBoundlessScrollView alloc] initWithFrame:self.view.bounds];
    boundlessScrollView.delegateForCell = self;
    [self.view addSubview:boundlessScrollView];
    
}

-(WKBoundlessScrollViewCell *)boundlessScrollViewCellWithDeviation:(NSInteger)deviation boundlessScrollView:(WKBoundlessScrollView *)boundlessScrollView
{
    static NSString *cellID = @"cellID";
    WKBoundlessScrollViewCell *cell = [boundlessScrollView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[WKBoundlessScrollViewCell alloc] initWithIdentifier:cellID];

    }
    return cell;
}


-(CGFloat)boundlessScrollViewCellHeight:(WKBoundlessScrollView *)boundlessScrollView deviation:(NSInteger)deviation
{
    return 200;
}

-(void)didSelectedWithDeviation:(NSInteger)deviation
{
    NSLog(@"%d",deviation);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
