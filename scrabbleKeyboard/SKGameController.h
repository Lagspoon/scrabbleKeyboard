//
//  SKGameController.h
//  scrabbleKeyboard
//
//  Created by Olivier Delecueillerie on 13/05/2014.
//  Copyright (c) 2014 lagspoon.scrabbleKeyboard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKWordsData.h"
#import "SKTileView.h"
#import "SKHUDView.h"
#import "SKGameData.h"
#import "SKAudioController.h"

@interface SKGameController : NSObject <TileDragDelegateProtocol>

//the view to add word elements to
@property (weak, nonatomic) UIView* boardView;

//the current spelling
@property (strong, nonatomic) SKWordsData* spelling;

@property (weak, nonatomic) SKHUDView* hud;

//display a new word on the screen
-(void)dealRandomWord;

// with the other properties
@property (strong, nonatomic) SKGameData* data;

@property (strong, nonatomic) SKAudioController* audioController;

@end
