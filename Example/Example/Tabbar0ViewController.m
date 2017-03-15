//
//  Tabbar0ViewController.m
//  Example
//
//  Created by whbalzac on 3/15/17.
//  Copyright © 2017 whbalzac. All rights reserved.
//

#import "Tabbar0ViewController.h"
#import "WHDropDownView.h"

@interface Tabbar0ViewController ()

@end

@implementation Tabbar0ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    
    UIButton *buttonTest = [[UIButton alloc] initWithFrame:CGRectMake(50, 500, 100, 50)];
    [buttonTest setTitle:@"Boomup" forState:UIControlStateNormal];
    buttonTest.backgroundColor = [UIColor redColor];
    [buttonTest addTarget:self action:@selector(testClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:buttonTest];
}

- (void)testClick
{
    [[WHDropDownView sharedInstance] boomup];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[WHDropDownView sharedInstance] boomup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
