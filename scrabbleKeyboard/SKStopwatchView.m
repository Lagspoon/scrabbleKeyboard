//
//  SKStopwatchView.m
//  scrabbleKeyboard
//
//  Created by Olivier Delecueillerie on 14/05/2014.
//  Copyright (c) 2014 lagspoon.scrabbleKeyboard. All rights reserved.
//

#import "SKStopwatchView.h"

@implementation SKStopwatchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.font = [UIFont systemFontOfSize:18.0];//kFontHUDBig;
        // Initialization code
    }
    return self;
}


//helper method that implements time formatting
//to an int parameter (eg the seconds left)
-(void)setSeconds:(int)seconds
{
    self.text = [NSString stringWithFormat:@" %02.f : %02i", round(seconds / 60), seconds % 60 ];
}

@end
