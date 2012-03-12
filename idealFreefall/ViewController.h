//
//  ViewController.h
//  idealFreefall
//
//  Created by Frank Grimmer on 2/12/12.
//  Copyright (c) 2012 Viscereality . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Box2D.h"

#define PTM_RATIO 120

@interface ViewController : UIViewController <UIAccelerometerDelegate>

@property (nonatomic, assign) b2World *world;
@property (nonatomic, strong) NSTimer *tickTimer;
@property (nonatomic, strong) IBOutlet UIView *tennisBall;

@property (nonatomic, strong) IBOutlet UIButton *resetButton;
@property (nonatomic, strong) IBOutlet UILabel *threeQuarterLabel;
@property (nonatomic, strong) IBOutlet UILabel *halfLabel;
@property (nonatomic, strong) IBOutlet UILabel *quarterLabel;
@property (nonatomic, strong) IBOutlet UILabel *verticalVelocityLabel;
@property (nonatomic, strong) IBOutlet UILabel *maxVerticalVelocityLabel;

@property (nonatomic, strong) IBOutlet UILabel *yi;
@property (nonatomic, strong) IBOutlet UILabel *dy;
@property (nonatomic, strong) IBOutlet UILabel *vyi2;
@property (nonatomic, strong) IBOutlet UILabel *d;
@property (nonatomic, strong) IBOutlet UILabel *vyf2;
@property (nonatomic, strong) IBOutlet UILabel *vyf;

- (IBAction)resetButtonPressed:(id)sender;


@end
