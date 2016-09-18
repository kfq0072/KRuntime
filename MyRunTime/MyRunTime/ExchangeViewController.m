//
//  MyViewController.m
//  MyRunTime
//
//  Created by kefoqing on 16/9/13.
//  Copyright © 2016年 kefoqing. All rights reserved.
//

#import "ExchangeViewController.h"

@implementation ExchangeViewController
- (void)myVCFunction:(id)param {
    NSLog(@"%s,参数：%@",__FUNCTION__,param);
}

//-(void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    NSLog(@"%s",__FUNCTION__);
//}
@end
