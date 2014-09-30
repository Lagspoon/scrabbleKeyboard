//
//  SKTargetView.h
//  scrabbleKeyboard
//
//  Created by Olivier Delecueillerie on 13/05/2014.
//  Copyright (c) 2014 lagspoon.scrabbleKeyboard. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "SKScrabbleView.h"
#import "SKTarget.h"


@interface SKTargetView : SKScrabbleView

@property (nonatomic, strong, readonly) SKTarget *target;

-(instancetype)initWithTarget:(SKTarget*)target;

@end
