//
//  SKScrabbleView.m
//  scrabbleKeyboard
//
//  Created by Olivier Delecueillerie on 29/09/2014.
//  Copyright (c) 2014 lagspoon.scrabbleKeyboard. All rights reserved.
//

#import "SKScrabbleView.h"

@implementation SKScrabbleView

- (id)initWithFrame:(CGRect)frame {
    NSAssert(NO, @"Use initWithLetter:andSideLength instead");
    return nil;
}

-(void) setSideLength:(float)sideLength {
    float scale = sideLength/self.image.size.width;
    self.frame = CGRectMake(0,0,self.image.size.width*scale, self.image.size.height*scale);
}


@end
