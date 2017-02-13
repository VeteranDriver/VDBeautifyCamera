//
//  ViewController.m
//  VDBeautifyCameraDemo
//
//  Created by niepengpeng on 17/2/7.
//  Copyright © 2017年 VD. All rights reserved.
//

#import "ViewController.h"
#import "VDBeautifyCameraManager.h"


@interface ViewController ()

@property(nonatomic, strong) VDBeautifyCameraManager *beautifyCameraManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.beautifyCameraManager = [[VDBeautifyCameraManager alloc] init];
    
}


- (IBAction)photoButtonDidClick:(id)sender {
    
    [self.navigationController pushViewController:self.beautifyCameraManager animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
