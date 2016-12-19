//
//  RCEasyTipView.h
//  EasyTips
//
//  Created by Nitish Makhija on 16/12/16.
//  Copyright © 2016 Roadcast. All rights reserved.

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ArrowPosition){
    Any = 0,
    Top,
    Bottom,
    Right,
    Left
};

@class RCEasyTipDrawing;
@class RCEasyTipPositioning;
@class RCEasyTipAnimating;

@interface RCEasyTipPreferences : NSObject

@property (nonatomic, strong) RCEasyTipDrawing *drawing;
@property (nonatomic, strong) RCEasyTipPositioning *positioning;
@property (nonatomic, strong) RCEasyTipAnimating *animating;

- (instancetype)initWithDefaultPreferences;

@end

@interface RCEasyTipDrawing : RCEasyTipPreferences

@property (nonatomic, assign) ArrowPosition arrowPostion;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat arrowHeight;
@property (nonatomic, assign) CGFloat arrowWidth;
@property (nonatomic, strong) UIColor *foregroundColor;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, strong) UIFont *font;

@end

@interface RCEasyTipPositioning : RCEasyTipPreferences

@property (nonatomic, assign) CGFloat bubbleHInset;
@property (nonatomic, assign) CGFloat bubbleVInset;
@property (nonatomic, assign) CGFloat textHInset;
@property (nonatomic, assign) CGFloat textVInset;
@property (nonatomic, assign) CGFloat maxWidth;

@end

@interface RCEasyTipAnimating : RCEasyTipPreferences

@property (nonatomic, assign) CGAffineTransform dismissTransform;
@property (nonatomic, assign) CGAffineTransform showInitialTransform;
@property (nonatomic, assign) CGAffineTransform showFinalTransform;
@property (nonatomic, assign) CGFloat springDamping;
@property (nonatomic, assign) CGFloat springVelocity;
@property (nonatomic, assign) CGFloat showInitialAlpha;
@property (nonatomic, assign) CGFloat dismissFinalAlpha;
@property (nonatomic, assign) NSTimeInterval showDuration;
@property (nonatomic, assign) NSTimeInterval dismissDuration;

@end

@protocol RCEasyTipViewDelegate;

@interface RCEasyTipView : UIView

@property (nonatomic, strong) NSString *text;
@property (nonatomic, weak) id<RCEasyTipViewDelegate>delegate;

- (instancetype)initWithPreferences:(RCEasyTipPreferences *)preferences;

- (void)showAnimated:(BOOL)animated forItem:(UIBarItem *)item withinSuperView:(UIView *)superView;
- (void)showAnimated:(BOOL)animated forView:(UIView *)view withinSuperView:(UIView *)superView;

@end

@protocol RCEasyTipViewDelegate <NSObject>
@optional

- (void)didDismissTip:(RCEasyTipView *)tipView;

@end
