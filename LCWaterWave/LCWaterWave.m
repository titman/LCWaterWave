//
//  LCWaterWave.m
//  LCWaterWaveDemo
//
//  Created by Leer on 15/12/11.
//  Copyright © 2015年 titman. All rights reserved.
//

#import "LCWaterWave.h"
#import <CoreMotion/CoreMotion.h>

@interface LCWaterWave ()


// draw.
@property(nonatomic, assign) CGFloat currentY;

@property(nonatomic, assign) CGFloat a;
@property(nonatomic, assign) CGFloat b;
@property(nonatomic, assign) BOOL add;

@property(nonatomic, strong) NSTimer * drawTimer;

@property(nonatomic, assign) BOOL inited;


// motion.
@property(nonatomic, strong) NSTimer * motionTimer;

@property(nonatomic, strong) CMMotionManager * motionManager;
@property(nonatomic, assign) CGFloat motionLastYaw;

@end

@implementation LCWaterWave

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initSelf];
    }
    return self;
}

-(instancetype) init
{
    if (self = [super init]) {
        
        [self initSelf];
    }
    
    return self;
}

#pragma mark -

-(void) initSelf
{
    if (!self.inited) {
        
        self.inited = YES;

        self.backgroundColor = [UIColor clearColor];
        self.progress = 0.2;
        self.speed = 0.1;
        self.a = 1.5;
        self.b = 0;
        self.add = NO;
        
        self.color = [UIColor colorWithRed:86/255.0f green:202/255.0f blue:139/255.0f alpha:1];
        
        // draw.
        self.drawTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(animateWave) userInfo:nil repeats:YES];

        self.motion = YES;
        
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.deviceMotionUpdateInterval = 0.02;// 0.02; // 50 Hz
        
        self.motionLastYaw = 0;
        
        self.motionTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(motionWave) userInfo:nil repeats:YES];
        
        if ([self.motionManager isDeviceMotionAvailable]) {
            
            // to avoid using more CPU than necessary we use ``CMAttitudeReferenceFrameXArbitraryZVertical``
            [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical];
        }

    }
}

-(void) setProgress:(CGFloat)progress
{
    _progress = progress;
    
    self.currentY = self.frame.size.height * (1. - progress);
}

-(void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.currentY = frame.size.height / 2;
}

-(void) removeFromSuperview
{
    [super removeFromSuperview];
    
    [self.drawTimer invalidate];
    self.drawTimer = nil;
    
    [self.motionTimer invalidate];
    self.motionTimer = nil;
}

-(void)animateWave
{
    if (self.add) {
        
        self.a += 0.01;
        
    }else{
        
        self.a -= 0.01;
    }
    
    if (self.a <= 1) {
        
        self.add = YES;
    }
    
    if (self.a >= 1.5) {
        
        self.add = NO;
    }
    
    
    self.b += self.speed;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGContextSetLineWidth(context, 1);
    CGContextSetFillColorWithColor(context, [self.color CGColor]);
    
    CGFloat currentY = self.currentY;
    
    CGFloat y = currentY;
    
    CGPathMoveToPoint(path, NULL, 0, y);
    
    for(float x = 0; x <= self.frame.size.width; x++){
        
        y = self.a * sin( x/180 * M_PI + 4 * self.b / M_PI ) * 5 + currentY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, self.frame.size.width, rect.size.height);
    CGPathAddLineToPoint(path, nil, 0, rect.size.height);
    CGPathAddLineToPoint(path, nil, 0, currentY);
    
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);
}

#pragma mark -

-(void) motionWave
{
    if (!self.motion) {
        
        self.transform = CGAffineTransformIdentity;
        return;
    }
    
    // compute the device yaw from the attitude quaternion
    // http://en.wikipedia.org/wiki/Conversion_between_quaternions_and_Euler_angles
    CMQuaternion quat = self.motionManager.deviceMotion.attitude.quaternion;
    double yaw = asin(2*(quat.x*quat.z - quat.w*quat.y));
    
    // TODO improve the yaw interval (stuck to [-PI/2, PI/2] due to arcsin definition
    
    yaw *= -1;      // reverse the angle so that it reflect a *liquid-like* behavior
    //yaw += M_PI_2;  // because for the motion manager 0 is the calibration value (but for us 0 is the horizontal axis)
    
    if (self.motionLastYaw == 0) {
        self.motionLastYaw = yaw;
    }
    
    // kalman filtering
    static float q = 0.1;   // process noise
    static float s = 0.1;   // sensor noise
    static float p = 0.1;   // estimated error
    static float k = 0.5;   // kalman filter gain
    
    float x = self.motionLastYaw;
    p = p + q;
    k = p / (p + s);
    x = x + k*(yaw - x);
    p = (1 - k)*p;
    
    [UIView animateWithDuration:0.02 animations:^{
        
        self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, -x);
    }];

    self.motionLastYaw = x;
}

@end
