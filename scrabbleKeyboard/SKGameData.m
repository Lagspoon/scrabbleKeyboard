//
//  SKWordsDataData.m
//  scrabbleKeyboard
//
//  Created by Olivier Delecueillerie on 14/05/2014.
//  Copyright (c) 2014 lagspoon.scrabbleKeyboard. All rights reserved.
//

#import "SKGameData.h"
#import "SKDictWordResult.h"

@implementation SKGameData
//custom setter - keep the score positive
-(void)setPoints:(int)points
{
    _points = MAX(points, 0);
}

+ (NSDictionary *) wordResult:(NSDictionary*) wordresult StartedAt:(NSDate *)startedAt EndedAt:(NSDate *) endedAt wordAsked:(NSString *) wordAsked stringInput:(NSString *)stringInput points:(NSNumber *)points pass:(BOOL)pass {
    
    if (!wordresult) {
        wordresult = [[NSDictionary alloc] init];
    }

    NSMutableDictionary *mWordResult = [NSMutableDictionary dictionaryWithDictionary:wordresult];
    if (startedAt) [mWordResult setValue:[startedAt copy] forKey:startedAtKey];
    if (endedAt) [mWordResult setValue:[endedAt copy] forKey:endedAtKey];
    if (wordAsked) [mWordResult setValue:[wordAsked copy] forKey:wordAskedKey];
    if (stringInput) [mWordResult setValue:[stringInput copy] forKey:stringInputKey];
    if (points) [mWordResult setValue:[points copy] forKey:pointsKey];
    if (pass) [mWordResult setValue:[NSNumber numberWithBool:pass] forKey:passKey];
    
    return [NSDictionary dictionaryWithDictionary:mWordResult];
}

+ (NSMutableArray *) gameResult {
    NSMutableArray *arrayResult = [[NSMutableArray alloc]init];
    return arrayResult;
}
@end
