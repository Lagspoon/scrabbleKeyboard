//
//  SKWordsData.m
//  scrabbleKeyboard
//
//  Created by Olivier Delecueillerie on 13/05/2014.
//  Copyright (c) 2014 lagspoon.scrabbleKeyboard. All rights reserved.
//

#import "SKWordsData.h"

@implementation SKWordsData


+(instancetype)spellingWithNum:(int)levelNum;
{
    //1 find .plist file for this level
    NSString* fileName = [NSString stringWithFormat:@"spelling%i.plist", levelNum];
    NSString* levelPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    
    //2 load .plist file
    NSDictionary* levelDict = [NSDictionary dictionaryWithContentsOfFile:levelPath];
    
    //3 validation
    NSAssert(levelDict, @"level config file not found");
    
    //4 create Level instance
    SKWordsData* spelling = [[SKWordsData alloc] init];
    
    //5 initialize the object from the dictionary
    spelling.pointsPerTile = [levelDict[@"pointsPerTile"] intValue];
    spelling.words = levelDict[@"words"];
    spelling.timeToSolve = [levelDict[@"timeToSolve"] intValue];
    
    return spelling;
}

@end
