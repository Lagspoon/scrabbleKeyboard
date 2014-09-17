//
//  SKWordsDataData.h
//  scrabbleKeyboard
//
//  Created by Olivier Delecueillerie on 14/05/2014.
//  Copyright (c) 2014 lagspoon.scrabbleKeyboard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKGameData : NSObject

//store the user's game achievement
@property (assign, nonatomic) int points;
@property (strong, nonatomic) NSDictionary *wordResult;
@property (strong, nonatomic) NSMutableArray *gameResult;


+ (NSMutableArray *) gameResult;
+ (NSDictionary *) wordResult:(NSDictionary*) wordresult StartedAt:(NSDate *)startedAt EndedAt:(NSDate *) endedAt wordAsked:(NSString *) wordAsked stringInput:(NSString *)stringInput points:(NSNumber *)points pass:(BOOL)pass;

@end
