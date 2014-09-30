//
//  SKTargetView.m
//  scrabbleKeyboard
//
//  Created by Olivier Delecueillerie on 13/05/2014.
//  Copyright (c) 2014 lagspoon.scrabbleKeyboard. All rights reserved.
//

#import "SKTargetView.h"

@interface SKTargetView ()
//override the readonly property
@property (strong, nonatomic, readwrite) SKTarget *target;
@end

@implementation SKTargetView

-(instancetype)initWithTarget:(SKTarget *) target {
    UIImage* img = [UIImage imageNamed:@"slot"];
    self = [super initWithImage: img];
    if (self) {
        self.target = target;
    }
    return self;
}

@end
