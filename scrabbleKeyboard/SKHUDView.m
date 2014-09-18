//
//  SKHUDView.m
//  scrabbleKeyboard
//
//  Created by Olivier Delecueillerie on 14/05/2014.
//  Copyright (c) 2014 lagspoon.scrabbleKeyboard. All rights reserved.
//

#import "SKHUDView.h"
#define kFontHUD  [UIFont systemFontOfSize:20.0]
@implementation SKHUDView


- (SKCounterLabelView *) gamePoints {
    if (!_gamePoints) {
        _gamePoints = (SKCounterLabelView *)[self viewWithTag:1];
    }
    return _gamePoints;
}

- (SKStopwatchView *) stopwatch {
    if (!_stopwatch) {
        _stopwatch = (SKStopwatchView *) [self viewWithTag:2];
        _stopwatch.seconds = 0;
    }
    return _stopwatch;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        self.userInteractionEnabled = YES;
        self.stopwatch.seconds = 0;

    }
    
    
    
    return self;
}

+(instancetype)viewWithRect:(CGRect)r
{
    //create the hud layer
    SKHUDView* hud = [[SKHUDView alloc] initWithFrame:r];
    hud.userInteractionEnabled = YES;

    //the stopwatch
    hud.stopwatch = [[SKStopwatchView alloc] initWithFrame: CGRectMake(r.origin.x, r.origin.y, 200, 80)];
    hud.stopwatch.backgroundColor = [UIColor redColor];
    hud.stopwatch.seconds = 0;
    [hud addSubview: hud.stopwatch];
    
    
    

    //the dynamic points label
    hud.gamePoints = [SKCounterLabelView labelWithFont:kFontHUD frame:CGRectMake(r.origin.x + r.size.width - 200,r.origin.y,200,80) andValue:0];
    hud.gamePoints.textColor = [UIColor colorWithRed:0.38 green:0.098 blue:0.035 alpha:1] /*#611909*/;
    [hud addSubview: hud.gamePoints];
    
    //"points" label
    UILabel* pts = [[UILabel alloc] initWithFrame:CGRectMake(hud.gamePoints.frame.origin.x-100, r.origin.y,100,80)];
    pts.backgroundColor = [UIColor clearColor];
    pts.font = kFontHUD;
    pts.text = @" Points:";
    [hud addSubview:pts];
    

    
    
    //load the button image
    UIImage* image = [UIImage imageNamed:@"btn"];
    
    //the help button
    hud.btnHelp = [UIButton buttonWithType:UIButtonTypeCustom];
    [hud.btnHelp setTitle:@"Hint!" forState:UIControlStateNormal];
    hud.btnHelp.titleLabel.font = kFontHUD;
    [hud.btnHelp setBackgroundImage:image forState:UIControlStateNormal];
    hud.btnHelp.frame = CGRectMake(50, 30, image.size.width, image.size.height);
    hud.btnHelp.alpha = 0.8;
    [hud addSubview: hud.btnHelp];
    
    return hud;
}

-(id)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    //1 let touches through and only catch the ones on buttons
    UIView* hitView = (UIView*)[super hitTest:point withEvent:event];
    
    //2
    if ([hitView isKindOfClass:[UIButton class]]) {
        return hitView;
    }
    
    //3
    return nil;
    
}

@end
