//
//  SKTarget.m
//  scrabbleKeyboard
//
//  Created by Olivier Delecueillerie on 16/09/2014.
//  Copyright (c) 2014 lagspoon.scrabbleKeyboard. All rights reserved.
//

#import "SKTarget.h"

@implementation SKTarget

- (void) setIsEnabled:(BOOL)isEnabled {
    _isEnabled = isEnabled;
    self.view.hidden = !isEnabled;
}
@end
