//
//  RCEasyTipView.m
//  EasyTips
//
//  Created by Nitish Makhija on 16/12/16.
//  Copyright © 2016 Roadcast. All rights reserved.
//

#import "RCEasyTipView.h"
#import "UIView+RCEssentials.h"
#import "UIBarItem+RCBarItem.h"

@interface RCEasyTipPreferences ()

@end

@implementation RCEasyTipPreferences

- (instancetype)initWithDefaultPreferences {
    self = [super init];
    if (self) {
        _drawing = [[RCEasyTipDrawing alloc] init];
        _positioning = [[RCEasyTipPositioning alloc] init];
        _animating = [[RCEasyTipAnimating alloc] init];
    }
    return self;
}

@end

@interface RCEasyTipDrawing ()

@end

@implementation RCEasyTipDrawing

- (instancetype)init {
    self = [super init];
    if (self) {
        _cornerRadius = 5;
        _arrowHeight = 5;
        _arrowWidth = 10;
        _foregroundColor = [UIColor whiteColor];
        _backgroundColor = [UIColor redColor];
        _arrowPostion = Any;
        _textAlignment = NSTextAlignmentCenter;
        _borderWidth = 0;
        _borderColor = [UIColor clearColor];
        _font = [UIFont systemFontOfSize:15];
    }
    return self;
}

@end

@interface RCEasyTipPositioning ()

@end

@implementation RCEasyTipPositioning

- (instancetype)init {
    self = [super init];
    if (self) {
        _bubbleHInset = 1;
        _bubbleVInset = 1;
        _textHInset = 10;
        _textVInset = 10;
        _maxWidth = 200;
    }
    return self;
}

@end

@interface RCEasyTipAnimating ()

@end

@implementation RCEasyTipAnimating

- (instancetype)init {
    self = [super init];
    if (self) {
        _dismissTransform = CGAffineTransformMakeScale(0.1, 0.1);
        _showInitialTransform = CGAffineTransformMakeScale(0, 0);
        _showFinalTransform = CGAffineTransformIdentity;
        _springDamping = 0.7;
        _springVelocity = 0.7;
        _showInitialAlpha = 0;
        _dismissFinalAlpha = 0;
        _showDuration = 0.7f;
        _dismissDuration = 0.7f;
    }
    return self;
}

@end

@interface RCEasyTipView ()

@property (nonatomic, strong) RCEasyTipPreferences *preferences;

@property (nonatomic, weak) UIView *presentingView;
@property (nonatomic, assign) CGPoint arrowTip;

@end

@implementation RCEasyTipView

#pragma mark - Override Methods

- (void)drawRect:(CGRect)rect {
    ArrowPosition position = _preferences.drawing.arrowPostion;
    CGFloat bubbleWidth;
    CGFloat bubbleHeight;
    CGFloat bubbleXOrigin;
    CGFloat bubbleYOrigin;
    
    switch (position) {
        case Any:
        case Top:
        case Bottom:
            bubbleWidth = [self getContentSize].width - 2 * _preferences.positioning.bubbleHInset;
            bubbleHeight = [self getContentSize].height - 2 * _preferences.positioning.bubbleVInset - _preferences.drawing.arrowHeight;
            
            bubbleXOrigin = _preferences.positioning.bubbleHInset;
            bubbleYOrigin = position == Bottom ? _preferences.positioning.bubbleVInset : _preferences.positioning.bubbleVInset + _preferences.drawing.arrowHeight;
            break;
        case Left:
        case Right:
            bubbleWidth = [self getContentSize].width - 2 * _preferences.positioning.bubbleHInset - _preferences.drawing.arrowHeight;
            bubbleHeight = [self getContentSize].height - 2 * _preferences.positioning.bubbleVInset;
            
            bubbleXOrigin = position == Right ? _preferences.positioning.bubbleHInset : _preferences.positioning.bubbleVInset + _preferences.drawing.arrowHeight;
            bubbleYOrigin = _preferences.positioning.bubbleVInset;
            break;
    }
    CGRect bubbleFrame = CGRectMake(bubbleXOrigin, bubbleYOrigin, bubbleWidth, bubbleHeight);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    [self drawBubbleWithFrame:bubbleFrame arrowPosition:position andContext:context];
    [self drawTextWithFrame:bubbleFrame andContext:context];
    
    CGContextRestoreGState(context);
}

#pragma mark - Lifecycle

- (instancetype)initWithPreferences:(RCEasyTipPreferences *)preferences {
    self = [super init];
    if (self) {
        _preferences = preferences;
        self.backgroundColor = [UIColor clearColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRotation) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRotation) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleRotation {
    UIView *superView = self.superview;
    if (superView) {
        [UIView animateWithDuration:0.3f animations:^{
            [self arrangeWithinSuperView:superView];
            [self setNeedsDisplay];
        }];
    } else {
        return;
    }
}

- (void)arrangeWithinSuperView:(UIView *)superView {
    ArrowPosition position = _preferences.drawing.arrowPostion;
    
    CGRect refViewFrame = [self.presentingView convertRect:self.presentingView.bounds toCoordinateSpace:superView];
    
    CGRect superViewFrame;
    
    if ([superView isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)superView;
        superViewFrame.origin = scrollView.frame.origin;
        superViewFrame.size = scrollView.contentSize;
    } else {
        superViewFrame = superView.frame;
    }
    
    CGRect frame = [self computeFrameWithPosition:position referenceFrame:refViewFrame superViewFrame:superViewFrame];
    NSArray *allValues = @[[NSNumber numberWithInteger:Top],[NSNumber numberWithInteger:Bottom],[NSNumber numberWithInteger:Right],[NSNumber numberWithInteger:Left]];
    
    if (![self isFrame:frame forReferenceViewFrame:refViewFrame]) {
        for (NSNumber *value in allValues) {
            if (![value isEqualToNumber:[NSNumber numberWithInteger:position]]) {
                CGRect newFrame = [self computeFrameWithPosition:value.integerValue referenceFrame:refViewFrame superViewFrame:superViewFrame];
                if ([self isFrame:newFrame forReferenceViewFrame:refViewFrame]) {
                    if (position != Any) {
                        NSLog(@"[EasyTipView - Info] The arrow position you chose <\(position)> could not be applied. Instead, position <\(value)> has been applied! Please specify position <\(ArrowPosition.any)> if you want EasyTipView to choose a position for you.");
                    }
                    frame = newFrame;
                    position = value.integerValue;
                    _preferences.drawing.arrowPostion = value.integerValue;
                    break;
                }
            }
        }
    }
    CGFloat arrowTipXOrigin;
    switch (position) {
        case Any:
        case Top:
        case Bottom:
            if (frame.size.width < refViewFrame.size.width) {
                arrowTipXOrigin = [self getContentSize].width / 2;
            } else {
                arrowTipXOrigin = fabs(frame.origin.x - refViewFrame.origin.x) + refViewFrame.size.width / 2;
            }
            
            _arrowTip = CGPointMake(arrowTipXOrigin, position == Bottom ? [self getContentSize].height - _preferences.positioning.bubbleVInset : _preferences.positioning.bubbleVInset);
            break;
        case Right:
        case Left:
            if (frame.size.height < refViewFrame.size.height) {
                arrowTipXOrigin = [self getContentSize].height / 2;
            } else {
                arrowTipXOrigin = fabs(frame.origin.y - refViewFrame.origin.y) + refViewFrame.size.height / 2;
            }
            _arrowTip = CGPointMake(_preferences.drawing.arrowPostion == Left ? _preferences.positioning.bubbleVInset : [self getContentSize].width - _preferences.positioning.bubbleVInset,arrowTipXOrigin);
            break;
    }
    self.frame = frame;
}

- (void)handleTap:(UIGestureRecognizer *)geture {
    if (geture.state == UIGestureRecognizerStateEnded) {
        [self dismissWithCompletion:^{
            //remove all the gsture here
            [self removeGestureRecognizer:geture];
        }];
    }
}

- (void)dismissWithCompletion:(void (^)())completionBlock {
    CGFloat damping = _preferences.animating.springDamping;
    CGFloat velocity = _preferences.animating.springVelocity;
    
    [UIView animateWithDuration:_preferences.animating.dismissDuration
                          delay:0
         usingSpringWithDamping:damping
          initialSpringVelocity:velocity
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.transform = _preferences.animating.dismissTransform;
                         self.alpha = _preferences.animating.dismissFinalAlpha;
                     }
                     completion:^(BOOL finished) {
                         if (completionBlock) {
                             completionBlock();
                         }
                         if (_delegate && [_delegate respondsToSelector:@selector(didDismissTip:)]) {
                             [_delegate didDismissTip:self];
                         }
                         [self removeFromSuperview];
                         self.transform = CGAffineTransformIdentity;
                     }];
}


- (CGRect)computeFrameWithPosition:(ArrowPosition)position referenceFrame:(CGRect)refViewFrame superViewFrame:(CGRect)superViewFrame {
    CGFloat xOrigin = 0;
    CGFloat yOrigin = 0;
    
    CGPoint center = CGPointMake(refViewFrame.origin.x + refViewFrame.size.width / 2, refViewFrame.origin.y + refViewFrame.size.height / 2);
    
    switch (position) {
        case Any:
        case Top:
            xOrigin = center.x - [self getContentSize].width / 2;
            yOrigin = refViewFrame.origin.y + refViewFrame.size.height;
            break;
        case Bottom:
            xOrigin = center.x - [self getContentSize].width / 2;
            yOrigin = refViewFrame.origin.y - [self getContentSize].height;
            break;
        case Right:
            xOrigin = refViewFrame.origin.x - [self getContentSize].width;
            yOrigin = center.y - [self getContentSize].height / 2;
            break;
        case Left:
            xOrigin = refViewFrame.origin.x + [self getContentSize].width;
            yOrigin = refViewFrame.origin.y - [self getContentSize].height / 2;
            break;
    }
    
    CGRect frame = CGRectMake(xOrigin, yOrigin, [self getContentSize].width,[self getContentSize].height);
    
    //frame adjusting horizontally
    if (frame.origin.x < 0) {
        frame.origin.x = 0;
    } else if (CGRectGetMaxX(frame) > superViewFrame.size.width) {
        frame.origin.x = superViewFrame.size.width - frame.size.width;
    }
    
    //frame adjusting vertically
    if (frame.origin.y < 0) {
        frame.origin.y = 0;
    } else if (CGRectGetMaxY(frame) > CGRectGetMaxY(superViewFrame)) {
        frame.origin.y = superViewFrame.size.height - frame.size.height;
    }
    
    return frame;
}

- (CGSize)getTextSize {
    NSDictionary *attributes = @{NSFontAttributeName:_preferences.drawing.font};
    
    CGSize textSize = [self.text boundingRectWithSize:CGSizeMake(_preferences.positioning.maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    textSize.width = ceil(textSize.width);
    textSize.height = ceil(textSize.height);
    
    if (textSize.width < _preferences.drawing.arrowWidth) {
        textSize.width = _preferences.drawing.arrowWidth;
    }
    return textSize;
    
}

- (CGSize)getContentSize {
    return CGSizeMake([self getTextSize].width + _preferences.positioning.textHInset * 2 + _preferences.positioning.bubbleHInset * 2, [self getTextSize].height + _preferences.positioning.textVInset * 2 + _preferences.positioning.bubbleVInset * 2 + _preferences.drawing.arrowHeight);
}

- (void)drawBubbleWithFrame:(CGRect)bubbleFrame arrowPosition:(ArrowPosition)position andContext:(CGContextRef)context {
    CGFloat arrowWidth = _preferences.drawing.arrowWidth;
    CGFloat arrowHeight = _preferences.drawing.arrowHeight;
    CGFloat cornerRadius = _preferences.drawing.cornerRadius;
    
    CGMutablePathRef contourPath = CGPathCreateMutable();
    
    CGPathMoveToPoint(contourPath, &CGAffineTransformIdentity, _arrowTip.x, _arrowTip.y);
    
    switch (position) {
        case Any:
        case Top:
        case Bottom:
            CGPathAddLineToPoint(contourPath, &CGAffineTransformIdentity, _arrowTip.x - arrowWidth / 2, _arrowTip.y + (position == Bottom ? -1 : 1) * arrowHeight);
            if (position == Bottom) {
                [self drawBottomBubbleShapeWithFrame:bubbleFrame cornerRadius:cornerRadius path:contourPath];
            } else {
                [self drawTopBubbleShapeWithFrame:bubbleFrame cornerRadius:cornerRadius path:contourPath];
            }
            CGPathAddLineToPoint(contourPath, &CGAffineTransformIdentity, _arrowTip.x + arrowWidth / 2, _arrowTip.y + (position == Bottom ? -1 : 1)* arrowHeight);
            break;
        case Right:
        case Left:
            CGPathAddLineToPoint(contourPath, &CGAffineTransformIdentity, _arrowTip.x + (position == Right ? -1 : 1) * arrowHeight, _arrowTip.y - arrowWidth / 2);
            if (position == Right) {
                [self drawRightBubbleShapeWithFrame:bubbleFrame cornerRadius:cornerRadius path:contourPath];
            } else {
                [self drawLeftBubbleShapeWithFrame:bubbleFrame cornerRadius:cornerRadius path:contourPath];
            }
            CGPathAddLineToPoint(contourPath, &CGAffineTransformIdentity, _arrowTip.x + (position == Right ? -1 : 1) * arrowHeight, _arrowTip.y + arrowWidth / 2);
            break;
    }
    CGPathCloseSubpath(contourPath);
    CGContextAddPath(context, contourPath);
    CGContextClip(context);
    
    [self paintBubble:context];
    
    if (![_preferences.drawing.borderColor isEqual:[UIColor clearColor]] && _preferences.drawing.borderWidth) {
        [self drawBorderWithPath:contourPath andContext:context];
    }
}


- (BOOL)isFrame:(CGRect)frame forReferenceViewFrame:(CGRect)refViewFrame {
    return !CGRectIntersectsRect(frame,refViewFrame);
}

- (void)drawBottomBubbleShapeWithFrame:(CGRect)frame cornerRadius:(CGFloat)radius path:(CGMutablePathRef)path {
    CGPathAddArcToPoint(path, &CGAffineTransformIdentity, frame.origin.x, frame.origin.y + frame.size.height, frame.origin.x, frame.origin.y, radius);
    CGPathAddArcToPoint(path, &CGAffineTransformIdentity, frame.origin.x, frame.origin.y, frame.origin.x + frame.size.width, frame.origin.y, radius);
    CGPathAddArcToPoint(path, &CGAffineTransformIdentity, frame.origin.x + frame.size.width, frame.origin.y, frame.origin.x + frame.size.width, frame.origin.y + frame.size.height, radius);
    CGPathAddArcToPoint(path, &CGAffineTransformIdentity, frame.origin.x + frame.size.width, frame.origin.y + frame.size.height, frame.origin.x, frame.origin.y + frame.size.height, radius);
}

- (void)drawTopBubbleShapeWithFrame:(CGRect)frame cornerRadius:(CGFloat)radius path:(CGMutablePathRef)path {
    CGPathAddArcToPoint(path, &CGAffineTransformIdentity, frame.origin.x, frame.origin.y, frame.origin.x, frame.origin.y + frame.size.height, radius);
    CGPathAddArcToPoint(path, &CGAffineTransformIdentity, frame.origin.x, frame.origin.y + frame.size.height, frame.origin.x + frame.size.width, frame.origin.y + frame.size.height, radius);
    CGPathAddArcToPoint(path, &CGAffineTransformIdentity, frame.origin.x + frame.size.width, frame.origin.y + frame.size.height, frame.origin.x + frame.size.width, frame.origin.y, radius);
    CGPathAddArcToPoint(path, &CGAffineTransformIdentity, frame.origin.x + frame.size.width, frame.origin.y, frame.origin.x, frame.origin.y, radius);
}

- (void)drawRightBubbleShapeWithFrame:(CGRect)frame cornerRadius:(CGFloat)radius path:(CGMutablePathRef)path {
    CGPathAddArcToPoint(path, &CGAffineTransformIdentity, frame.origin.x + frame.size.width, frame.origin.y, frame.origin.x, frame.origin.y, radius);
    CGPathAddArcToPoint(path, &CGAffineTransformIdentity, frame.origin.x, frame.origin.y, frame.origin.x, frame.origin.y + frame.size.height, radius);
    CGPathAddArcToPoint(path, &CGAffineTransformIdentity, frame.origin.x, frame.origin.y + frame.size.height, frame.origin.x + frame.size.width, frame.origin.y + frame.size.height, radius);
    CGPathAddArcToPoint(path, &CGAffineTransformIdentity, frame.origin.x + frame.size.width, frame.origin.y + frame.size.height, frame.origin.x + frame.size.width, frame.origin.y + frame.size.height, radius);
}

- (void)drawLeftBubbleShapeWithFrame:(CGRect)frame cornerRadius:(CGFloat)radius path:(CGMutablePathRef)path {
    CGPathAddArcToPoint(path, &CGAffineTransformIdentity, frame.origin.x, frame.origin.y, frame.origin.x + frame.size.width, frame.origin.y, radius);
    CGPathAddArcToPoint(path, &CGAffineTransformIdentity, frame.origin.x + frame.size.width, frame.origin.y, frame.origin.x + frame.size.width, frame.origin.y + frame.size.height, radius);
    CGPathAddArcToPoint(path, &CGAffineTransformIdentity, frame.origin.x + frame.size.width, frame.origin.y + frame.size.height, frame.origin.x, frame.origin.y + frame.size.height, radius);
    CGPathAddArcToPoint(path, &CGAffineTransformIdentity, frame.origin.x, frame.origin.y + frame.size.height, frame.origin.x, frame.origin.y, radius);
}

- (void)paintBubble:(CGContextRef)context {
    CGContextSetFillColorWithColor(context, _preferences.drawing.backgroundColor.CGColor);
    CGContextFillRect(context, self.bounds);
}

- (void)drawBorderWithPath:(CGPathRef)borderPath andContext:(CGContextRef)context {
    CGContextAddPath(context, borderPath);
    CGContextSetStrokeColorWithColor(context, _preferences.drawing.borderColor.CGColor);
    CGContextSetLineWidth(context, _preferences.drawing.borderWidth);
    CGContextStrokePath(context);
}

- (void)drawTextWithFrame:(CGRect)bubbleFrame andContext:(CGContextRef)context {
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = _preferences.drawing.textAlignment;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGRect textRect = CGRectMake(bubbleFrame.origin.x + (bubbleFrame.size.width - [self getTextSize].width) / 2, bubbleFrame.origin.y + (bubbleFrame.size.height - [self getTextSize].height) / 2, [self getTextSize].width, [self getTextSize].height);
    
    [self.text drawInRect:textRect withAttributes:@{NSFontAttributeName:_preferences.drawing.font, NSForegroundColorAttributeName: _preferences.drawing.foregroundColor, NSParagraphStyleAttributeName: paragraphStyle}];
}

- (void)showAnimated:(BOOL)animated forView:(UIView *)view withinSuperView:(UIView *)superView {
    NSAssert(superView == nil || [view hasSuperView:superView], @"The supplied superview is not a direct nor an indirect superview of the supplied reference view. The superview passed to this method should be a direct or an indirect superview of the reference view. To display the tooltip within the main window, ignore the superview parameter.");
    
    if (!superView) {
        superView = [[[UIApplication sharedApplication] windows] firstObject];
    }
    
    CGAffineTransform initialTransform = _preferences.animating.showInitialTransform;
    CGAffineTransform finalTransform = _preferences.animating.showFinalTransform;
    CGFloat initialAlpha = _preferences.animating.showInitialAlpha;
    CGFloat damping = _preferences.animating.springDamping;
    CGFloat velocity = _preferences.animating.springVelocity;
    
    self.presentingView = view;
    [self arrangeWithinSuperView:superView];
    
    self.transform = initialTransform;
    self.alpha = initialAlpha;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapGesture];
    
    [superView addSubview:self];
    
    if (animated) {
        [UIView animateWithDuration:_preferences.animating.showDuration
                              delay:0
             usingSpringWithDamping:damping
              initialSpringVelocity:velocity
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.transform = finalTransform;
                             self.alpha = 1;
                         }
                         completion:^(BOOL finished) {}];
    }
}

- (void)showAnimated:(BOOL)animated forItem:(UIBarItem *)item withinSuperView:(UIView *)superView {
    UIView *view  = item.view;
    [self showAnimated:animated forView:view withinSuperView:superView];
}

@end
