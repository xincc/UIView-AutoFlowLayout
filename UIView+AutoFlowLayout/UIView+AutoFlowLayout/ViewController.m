//
//  ViewController.m
//  UIView+AutoFlowLayout
//
//  Created by ccxin on 6/4/15.
//  Copyright (c) 2015 __my_company. All rights reserved.
//

#import "ViewController.h"
#import "UIView+AutoLayout.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //bg view
    UIView * viewBackGround = [[UIView alloc] initWithFrame:CGRectZero];
    viewBackGround.backgroundColor = UIColor.redColor;
    [self.view addSubview:viewBackGround fillByMargin:ALMarginZero()];

    
    //clip to two part
    
    UIView * topPart = [[UIView alloc] initWithFrame:CGRectZero];
    UIView * bottomPart = [[UIView alloc] initWithFrame:CGRectZero];
    topPart.backgroundColor = UIColor.blackColor;
    bottomPart.backgroundColor = UIColor.darkGrayColor;
    
    [viewBackGround addSubviews:@[topPart, bottomPart] flowLayoutDirection:ALLayoutDirectionVertical fillByMargin:ALMarginMakeLeft(50)];
    
    //set top part
    UIView * topPart1 = [[UIView alloc] initWithFrame:CGRectZero];
    UIView * topPart2 = [[UIView alloc] initWithFrame:CGRectZero];
    UIView * topPart3 = [[UIView alloc] initWithFrame:CGRectZero];
    topPart1.backgroundColor = UIColor.brownColor;
    topPart2.backgroundColor = UIColor.greenColor;
    topPart3.backgroundColor = UIColor.blueColor;

    [topPart addSubviews:@[topPart1,topPart2,topPart3] flowLayoutDirection:ALLayoutDirectionHorizontal fillByMargin:ALMarginMakeTop(50) interval:10.f];
    
    //set bottom part
    UIView * bottomPart1 = [[UIView alloc] initWithFrame:CGRectZero];
    UIView * bottomPart2 = [[UIView alloc] initWithFrame:CGRectZero];
    UIView * bottomPart3 = [[UIView alloc] initWithFrame:CGRectZero];
    bottomPart1.backgroundColor = UIColor.cyanColor;
    bottomPart2.backgroundColor = UIColor.yellowColor;
    bottomPart3.backgroundColor = UIColor.purpleColor;

    [bottomPart addSubviews:@[bottomPart1,bottomPart2,bottomPart3] flowLayoutDirection:ALLayoutDirectionVertical fillByMargin:ALMarginMakeRight(50) interval:10.f];

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
