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

- (id)initWithFrame:(CGRect)frame
{
    NSAssert(NO, @"Use initWithLetter:andSideLength instead");
    return nil;
}

//create a new target, store what letter should it match to
-(instancetype)initWithTarget:(SKTarget *) target sideLength:(float)sideLength
{
    UIImage* img = [UIImage imageNamed:@"slot"];
    self = [super initWithImage: img];
    
    if (self) {
        self.target = target;
        float scale = sideLength/img.size.width;
        self.frame = CGRectMake(0,0,img.size.width*scale, img.size.height*scale);
    }
    return self;
}

@end
