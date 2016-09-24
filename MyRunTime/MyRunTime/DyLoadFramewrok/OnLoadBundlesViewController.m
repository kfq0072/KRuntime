//
//  OnLoadBundlesViewController.m
//  MyRunTime
//
//  Created by kefoqing on 16/9/21.
//  Copyright © 2016年 kefoqing. All rights reserved.
//

#import "OnLoadBundlesViewController.h"
#import "LoadFramework.h"
@interface OnLoadBundlesViewController (){
    LoadFramework *_lfw;
    NSArray *_bundleArray;
}

@end

@implementation OnLoadBundlesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)testOnLoadBundles {
    _lfw = [LoadFramework new];
   _bundleArray =  [_lfw onLoadFramewrok];
}
- (IBAction)loadClick:(id)sender {
   [self testOnLoadBundles];
}
- (IBAction)activeClick:(id)sender {
   NSObject *instance = [_lfw onActiveFrameworkClass:[_bundleArray objectAtIndex:0]];
    [instance performSelector:@selector(hello) withObject:self withObject:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
