//
//  SecondViewController.m
//  UIView+AutoFlowLayout
//
//  Created by ccxin on 6/5/15.
//  Copyright (c) 2015 __my_company. All rights reserved.
//

#import "SecondViewController.h"
#import "UIView+AutoFlowLayout.h"
#import "ThirdViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ScrollView";

    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.blueColor;
    UIScrollView * view = [[UIScrollView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = UIColor.yellowColor;
    [self.view addSubview:view fillByMargin:ALMarginMakeLeft(100)];
    
    UIView * sView = [[UIView alloc] initWithFrame:CGRectZero];
    sView.backgroundColor = UIColor.blackColor;
    [view addSubview:sView fillByMargin:ALMarginZero()];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [self.navigationController pushViewController:[[ThirdViewController alloc] init] animated:YES];
}





@end
