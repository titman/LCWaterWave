//
//  ViewController.m
//  LCWaterWaveDemo
//
//  Created by Leer on 15/12/11.
//  Copyright © 2015年 titman. All rights reserved.
//

#import "ViewController.h"
#import "LCWaterWave.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    LCWaterWave * water = [[LCWaterWave alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    water.progress = 0.2;
    water.motion = NO;
    water.speed = 0.05;
    [self.view addSubview:water];
    
    
    LCWaterWave * red = [[LCWaterWave alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 100, 20, 200, 200)];
    red.layer.borderColor = [UIColor lightGrayColor].CGColor;
    red.layer.borderWidth = 1;
    red.layer.cornerRadius = 100;
    red.layer.masksToBounds = YES;
    red.color = [[UIColor redColor] colorWithAlphaComponent:0.6];
    red.speed = 0.1;
    red.progress = 0.5;
    [self.view addSubview:red];
    
    
    LCWaterWave * blue = [[LCWaterWave alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 50, 250, 100, 100)];
    blue.layer.borderColor = [UIColor lightGrayColor].CGColor;
    blue.layer.borderWidth = 1;
    blue.layer.cornerRadius = 50;
    blue.layer.masksToBounds = YES;
    blue.color = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    blue.speed = 0.15;
    blue.progress = 0.7;
    [self.view addSubview:blue];
    
    
    LCWaterWave * yellow = [[LCWaterWave alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 40, 370, 80, 80)];
    yellow.layer.cornerRadius = 40;
    yellow.layer.masksToBounds = YES;
    yellow.color = [[UIColor purpleColor] colorWithAlphaComponent:0.5];
    yellow.speed = 0.08;
    yellow.progress = 0.3;
    [self.view addSubview:yellow];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
