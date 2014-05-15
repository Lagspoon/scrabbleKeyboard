//
//  SKWordsDataData.m
//  scrabbleKeyboard
//
//  Created by Olivier Delecueillerie on 14/05/2014.
//  Copyright (c) 2014 lagspoon.scrabbleKeyboard. All rights reserved.
//

#import "SKGameData.h"

@implementation SKGameData
//custom setter - keep the score positive
-(void)setPoints:(int)points
{
    _points = MAX(points, 0);
}
@end
