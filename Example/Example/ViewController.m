//
//  ViewController.m
//  Example
//
//  Created by whbalzac on 3/14/17.
//  Copyright © 2017 whbalzac. All rights reserved.
//

#import "ViewController.h"
#import "Tabbar0ViewController.h"
#import "Tabbar1ViewController.h"
#import "WHDropDownView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configTabbar];
    
    [[WHDropDownView sharedInstance] showDropDownViewOn:self.view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)configTabbar {
    
    self.tabBar.translucent = NO;
    
    UIViewController *tab0VC = [[Tabbar0ViewController alloc] init];
    UIViewController *tab1VC = [[Tabbar1ViewController alloc] init];
    
    UINavigationController *tab1NVC = [[UINavigationController alloc] initWithRootViewController:tab1VC];
    
    self.viewControllers = @[tab0VC, tab1NVC];
    
    UITabBarItem *tab0Item = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *tab1Item = [self.tabBar.items objectAtIndex:1];
    
    [tab0Item setTitle:@"tab0"];
    [tab1Item setTitle:@"tab1"];
    
    [tab0Item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
    [tab1Item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
    
    [tab0Item setTitlePositionAdjustment:UIOffsetMake(0, -2.f)];
    [tab1Item setTitlePositionAdjustment:UIOffsetMake(0, -2.f)];
}

@end
