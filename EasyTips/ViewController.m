//
//  ViewController.m
//  EasyTips
//
//  Created by Nitish Makhija on 16/12/16.
//  Copyright © 2016 Roadcast. All rights reserved.
//

#import "ViewController.h"
#import "RCEasyTipView.h"

@interface ViewController () <RCEasyTipViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (IBAction)FirstButtonTapped:(id)sender {
    RCEasyTipPreferences *preferences = [[RCEasyTipPreferences alloc] initWithDefaultPreferences];
    preferences.drawing.backgroundColor = [UIColor brownColor];
    preferences.animating.showDuration = 1.5;
    preferences.animating.dismissDuration = 1.5;
    preferences.animating.dismissTransform = CGAffineTransformMakeTranslation(0, 100);
    preferences.animating.showInitialTransform = CGAffineTransformMakeTranslation(0, -100);
    
    RCEasyTipView *tipView = [[RCEasyTipView alloc] initWithPreferences:preferences];
    tipView.text = @"EasyTipView is an easy to use tooltip view. It can point to any UIView or UIBarItem subclasses. Tap the buttons to see other tooltips.";
    tipView.delegate = self;
    [tipView showAnimated:YES forView:sender withinSuperView:nil];

}

- (IBAction)SecondButtonTapped:(id)sender {
    RCEasyTipPreferences *preferences = [[RCEasyTipPreferences alloc] initWithDefaultPreferences];
    preferences.drawing.backgroundColor = [UIColor orangeColor];
    preferences.animating.showDuration = 1.5;
    preferences.animating.dismissDuration = 1.5;
    preferences.animating.dismissTransform = CGAffineTransformMakeTranslation(-30, -100);
    preferences.animating.showInitialTransform = CGAffineTransformMakeTranslation(30, 100);
    
    RCEasyTipView *tipView = [[RCEasyTipView alloc] initWithPreferences:preferences];
    tipView.text = @"EasyTipView is an easy to use tooltip view. It can point to any UIView or UIBarItem subclasses. Tap the buttons to see other tooltips.";
    tipView.delegate = self;
    [tipView showAnimated:YES forView:sender withinSuperView:nil];

}

- (IBAction)ThirdButtonTapped:(id)sender {
    RCEasyTipPreferences *preferences = [[RCEasyTipPreferences alloc] initWithDefaultPreferences];
    preferences.drawing.backgroundColor = [UIColor blueColor];
    preferences.drawing.arrowPostion = Right;
    preferences.animating.showDuration = 1.5;
    preferences.animating.dismissDuration = 1.5;
    preferences.animating.dismissTransform = CGAffineTransformMakeTranslation(100, 0);
    preferences.animating.showInitialTransform = CGAffineTransformMakeTranslation(100, 0);
    
    RCEasyTipView *tipView = [[RCEasyTipView alloc] initWithPreferences:preferences];
    tipView.text = @"EasyTipView";
    tipView.delegate = self;
    [tipView showAnimated:YES forView:sender withinSuperView:nil];

}

- (IBAction)ForthButtonTapped:(id)sender {
    RCEasyTipPreferences *preferences = [[RCEasyTipPreferences alloc] initWithDefaultPreferences];
    preferences.drawing.backgroundColor = [UIColor redColor];
    preferences.drawing.arrowPostion = Bottom;
    preferences.animating.showDuration = 1.5;
    preferences.animating.dismissDuration = 1.5;
    preferences.animating.dismissTransform = CGAffineTransformMakeTranslation(0, -15);
    preferences.animating.showInitialTransform = CGAffineTransformMakeTranslation(0, -15);
    
    RCEasyTipView *tipView = [[RCEasyTipView alloc] initWithPreferences:preferences];
    tipView.text = @"EasyTipView is an easy to use tooltip view. It can point to any UIView or UIBarItem subclasses. Tap the buttons to see other tooltips.";
    tipView.delegate = self;
    [tipView showAnimated:YES forView:sender withinSuperView:nil];
}

- (IBAction)FirstItemTapped:(id)sender {
    RCEasyTipPreferences *preferences = [[RCEasyTipPreferences alloc] initWithDefaultPreferences];
    preferences.drawing.backgroundColor = [UIColor purpleColor];
    preferences.animating.showDuration = 1.5;
    preferences.animating.dismissDuration = 1.5;
    preferences.animating.dismissTransform = CGAffineTransformMakeTranslation(0, -15);
    preferences.animating.showInitialTransform = CGAffineTransformMakeTranslation(0, -15);

    RCEasyTipView *tipView = [[RCEasyTipView alloc] initWithPreferences:preferences];
    tipView.text = @"EasyTipView is an easy to use tooltip view. It can point to any UIView or UIBarItem subclasses. Tap the buttons to see other tooltips.";
    tipView.delegate = self;
    [tipView showAnimated:YES forItem:sender withinSuperView:nil];
}

- (IBAction)SecondItemTapped:(id)sender {
    RCEasyTipPreferences *preferences = [[RCEasyTipPreferences alloc] initWithDefaultPreferences];
    preferences.drawing.backgroundColor = [UIColor greenColor];
    
    RCEasyTipView *tipView = [[RCEasyTipView alloc] initWithPreferences:preferences];
    tipView.text = @"EasyTipView is an easy to use tooltip view. It can point to any UIView or UIBarItem subclasses. Tap the buttons to see other tooltips.";
    tipView.delegate = self;
    [tipView showAnimated:YES forItem:sender withinSuperView:nil];
}

- (void)didShowTip:(RCEasyTipView *)tipView {
}

@end
