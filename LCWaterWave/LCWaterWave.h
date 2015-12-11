//
//  LCWaterWave.h
//  LCWaterWaveDemo
//
//  Created by Leer on 15/12/11.
//  Copyright © 2015年 titman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCWaterWave : UIView

@property(nonatomic, strong) UIColor * color;
@property(nonatomic, assign) CGFloat progress; // 0 ~ 1

@property(nonatomic, assign) BOOL motion;
@property(nonatomic, assign) CGFloat speed; // 0 ~ 1

@end
