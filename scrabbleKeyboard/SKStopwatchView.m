//
//  SKStopwatchView.m
//  scrabbleKeyboard
//
//  Created by Olivier Delecueillerie on 14/05/2014.
//  Copyright (c) 2014 lagspoon.scrabbleKeyboard. All rights reserved.
//

#import "SKStopwatchView.h"
#include "config.h"

@implementation SKStopwatchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
 self.font = kFontHUDBig;
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//helper method that implements time formatting
//to an int parameter (eg the seconds left)
-(void)setSeconds:(int)seconds
{
    self.text = [NSString stringWithFormat:@" %02.f : %02i", round(seconds / 60), seconds % 60 ];
}

@end
