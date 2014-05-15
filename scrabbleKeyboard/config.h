//
//  config.h
//  scrabbleKeyboard
//
//  Created by Olivier Delecueillerie on 13/05/2014.
//  Copyright (c) 2014 lagspoon.scrabbleKeyboard. All rights reserved.
//

#ifndef scrabbleKeyboard_config_h
#define scrabbleKeyboard_config_h


//UI defines
#define kScreenWidth [UIScreen mainScreen].bounds.size.height
#define kScreenHeight [UIScreen mainScreen].bounds.size.width
#define kTileMargin 20
#define kFontHUD [UIFont fontWithName:@"Chalkduster" size:30.0]
#define kFontHUDBig [UIFont fontWithName:@"Chalkduster" size:60.0]

//audio defines
#define kSoundDing  @"ding.wav"
#define kSoundWrong @"wrong.wav"
#define kSoundWin   @"win.wav"

#define kAudioEffectFiles @[kSoundDing, kSoundWrong, kSoundWin]
//add more definitions here


//handy math functions
#define rad2deg(x) x * 180 / M_PI
#define deg2rad(x) x * M_PI / 180
#define randomf(minX,maxX) ((float)(arc4random() % (maxX - minX + 1)) + (float)minX)


#define configed 1

#endif