//
//  ViewController.m
//  ExpandAndDelete
//
//  Created by TUOGE on 2018/6/21.
//  Copyright © 2018年 iotogether. All rights reserved.
//

#import "ViewController.h"
#import "JWExpandAndDeleteVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.bounds = CGRectMake(0, 0, 200, 30);
    button.center = CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds])/2, 100 + 2 *50);
    [button setTitle:@"展开和删除" forState:UIControlStateNormal];
    button.tag =  10+0;
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonPressed:(UIButton *)sender {
    JWExpandAndDeleteVC *expandAndDelete = [[JWExpandAndDeleteVC alloc] init];
    [self.navigationController pushViewController:expandAndDelete animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
