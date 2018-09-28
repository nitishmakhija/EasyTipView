<img src="https://raw.githubusercontent.com/teodorpatras/EasyTipView/master/assets/easytipview.png" alt="EasyTipView: fully customisable tooltip view written in Swift" style="width: 500px;"/>

Description
--------------

```EasyTipView``` is a fully customisable support for ```EasyTipView``` written in Swift.
(https://github.com/teodorpatras/EasyTipView)

<img src="https://raw.githubusercontent.com/nitishmakhija/EasyTipView/master/easytipview.gif" width="320">

# Contents
1. [Features](#features)
2. [Installation](#installation)
3. [Usage](#usage)
4. [Customising the appearance](#customising)
5. [Customising the presentation and dismissal animations](#customising-animations)
6. [Public interface](#public-interface)

##<a name="features"> Features </a>

-  Can be shown pointing to any ``UIBarItem`` or ``UIView`` subclass.
-  support for any arrow direction `←, →, ↑, ↓`
-  Automatic orientation change adjustments.
-  Fully customisable appearance.
-  Fully customisable presentation and dismissal animations.


<a name="installation"> Installation </a>
--------------

# Manually

Drag drop Source folder in your project

# Pods

To integrate EasyTipView into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'NMEasyTipView', '~> 1.2'
```

Then, run the following command:

```bash
$ pod install
```

<a name="usage"> Usage </a>
--------------

1) First you should customize the preferences:
```objc

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(50, 100, 100, 50);
    [button setTitle:@"Click Me" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    
    [button addTarget:self action:@selector(handle:) forControlEvents:UIControlEventTouchUpInside];
    
    RCEasyTipPreferences *preferences = [[RCEasyTipPreferences alloc] initWithDefaultPreferences];
    preferences.drawing.backgroundColor = [UIColor purpleColor];
    preferences.drawing.arrowPostion = Top;
    preferences.animating.showDuration = 1.5;
    preferences.animating.dismissDuration = 1.5;
    preferences.animating.dismissTransform = CGAffineTransformMakeTranslation(0, -15);
    preferences.animating.showInitialTransform = CGAffineTransformMakeTranslation(0, -15);
    
    RCEasyTipView *tipView = [[RCEasyTipView alloc] initWithPreferences:preferences];
    tipView.text = @"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.";
    [tipView showAnimated:YES forView:button withinSuperView:self.view];

```
<a name="customising"> Customising the appearance </a>
In order to customise the `EasyTipView` appearance and behaviour, you can play with the `Preferences` structure which encapsulates all the customizable properties of the ``EasyTipView``. These preferences have been split into three structures:
* ```Drawing``` - encapsulates customisable properties specifying how ```EastTipView``` will be drawn on screen.
* ```Positioning``` - encapsulates customisable properties specifying where ```EasyTipView``` will be drawn within its own bounds.
* ```Animating``` - encapsulates customisable properties specifying how ```EasyTipView``` will animate on and off screen.

| `Drawing ` attribute   |      Description      |
|----------|-------------|------|
|`cornerRadius`| The corner radius of the tip view bubble.|
|`arrowHeight`| The height of the arrow positioned at the top or bottom of the bubble.|
|`arrowWidth`| The width of the above mentioned arrow.|
|`foregroundColor`| The text color.|
|`backgroundColor`| The background color of the bubble.|
|`arrowPosition`| The position of the arrow. This can be: <br /> **+** `Top`: on top of the bubble <br /> **+** `Bottom`: at the bottom of the bubble.<br /> **+** `Left`: on the left of the bubble <br /> **+** `Right`: on the right of the bubble <br /> **+** `Any`: use this option to let the `EasyTipView` automatically find the best arrow position. <br />**If the passed in arrow cannot be applied due to layout restrictions, a different arrow position will be automatically assigned.**|
|`textAlignment`| The alignment of the text.|
|`borderWidth`| Width of the optional border to be applied on the bubble.|
|`borderColor`| Color of the optional border to be applied on the bubble. **In order for the border to be applied, `borderColor` needs to be different that `[UIColor clear]` and `borderWidth` > 0**|
|`font`| Font to be applied on the text. |

| `Positioning ` attribute   |      Description      |
|----------|-------------|------|
|`bubbleHInset`| Horizontal bubble inset witin its container.|
|`bubbleVInset`| Vertical bubble inset within its container.|
|`textHInset`| Text horizontal inset within the bubble.|
|`textVInset`| Text vertical inset within the bubble.|
|`maxWidth`| Max bubble width.|

| `Animating ` attribute   |      Description      |
|----------|-------------|------|
|`dismissTransform`| `CGAffineTransform` specifying how the bubble will be dismissed. |
|`showInitialTransform`| `CGAffineTransform` specifying the initial transform to be applied on the bubble before it is animated on screen. |
|`showFinalTransform`| `CGAffineTransform` specifying how the bubble will be animated on screen. |
|`springDamping`| Spring animation damping.|
|`springVelocity`| Spring animation velocity.|
|`showInitialAlpha`|Initial alpha to be applied on the tip view before it is animated on screen.|
|`dismissFinalAlpha`|The alpha to be applied on the tip view when it is animating off screen.|
|`showDuration`|Show animation duration.|
|`dismissDuration`|Dismiss animation duration.|

<a name="customising-animations"> Customising the presentation or dismissal animations </a>
--------------

The default animations for showing or dismissing are scale up and down. If you want to change the default behaviour, you need to change the attributes of the ``animating`` property within the preferences. An example could be:

```objc
preferences.drawing.arrowPostion = Top;
preferences.animating.showDuration = 1.5;
preferences.animating.dismissDuration = 1.5;
preferences.animating.dismissTransform = CGAffineTransformMakeTranslation(0, -15);
preferences.animating.showInitialTransform = CGAffineTransformMakeTranslation(0, -15);
```

This produces the following animations:
<br><br><img src="https://raw.githubusercontent.com/teodorpatras/EasyTipView/master/assets/animation.gif" width="200">

<a name="public-interface"> Public interface </a>
--------------

#Delegate
`EasyTipViewDelegate` is a custom protocol which defines one method to be called on the delegate after the ``EasyTipView`` has been dismissed.

```objc

@protocol RCEasyTipViewDelegate <NSObject>
@optional

- (void)willShowTip:(RCEasyTipView *)tipView;
- (void)didShowTip:(RCEasyTipView *)tipView;

- (void)willDismissTip:(RCEasyTipView *)tipView;
- (void)didDismissTip:(RCEasyTipView *)tipView;

@end

```
