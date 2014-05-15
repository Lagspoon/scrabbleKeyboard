//
//  SKAudioController.h
//  scrabbleKeyboard
//
//  Created by Olivier Delecueillerie on 15/05/2014.
//  Copyright (c) 2014 lagspoon.scrabbleKeyboard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKAudioController : NSObject
-(void)playEffect:(NSString*)name;
-(void)preloadAudioEffects:(NSArray*)effectFileNames;
@end
