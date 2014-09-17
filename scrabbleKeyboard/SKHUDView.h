//
//  SKHUDView.h
//  scrabbleKeyboard
//
//  Created by Olivier Delecueillerie on 14/05/2014.
//  Copyright (c) 2014 lagspoon.scrabbleKeyboard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKStopwatchView.h"
#import "SKCounterLabelView.h"


@interface SKHUDView : UIView

+(instancetype)viewWithRect:(CGRect)r;

@property (strong, nonatomic) SKCounterLabelView* gamePoints;
@property (strong, nonatomic) SKStopwatchView* stopwatch;
@property (strong, nonatomic) UIButton* btnHelp;

@end
