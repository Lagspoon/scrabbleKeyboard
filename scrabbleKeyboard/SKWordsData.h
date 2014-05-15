//
//  SKWordsData.h
//  scrabbleKeyboard
//
//  Created by Olivier Delecueillerie on 13/05/2014.
//  Copyright (c) 2014 lagspoon.scrabbleKeyboard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKWordsData : NSObject


//properties stored in a .plist file
@property (assign, nonatomic) int pointsPerTile;
@property (assign, nonatomic) int timeToSolve;
@property (strong, nonatomic) NSArray* words;

//factory method to load a .plist file and initialize the model
+(instancetype)spellingWithNum:(int)levelNum;

@end
