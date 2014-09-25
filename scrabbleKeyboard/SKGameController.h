//
//  SKGameController.h
//  scrabbleKeyboard
//
//  Created by Olivier Delecueillerie on 13/05/2014.
//  Copyright (c) 2014 lagspoon.scrabbleKeyboard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKHUDView.h"
#import "SKGameData.h"
#import "SKScrabbleBoardController.h"

@protocol gameDelegate <NSObject>

typedef enum gameKeyboardType
{
    gameKeyboardTile = 0,
    gameKeyboardStandard = 1,
} gameKeyboardType;

typedef enum gameType {
    gameTypeAnagrame = 0,
    gameTypeSpelling = 1,
} gameType;

typedef enum gameLevel {
    gameLevelEasy = 0,
    gameLevelMedium = 1,
    gameLevelHard = 2,
} gameLevel;

typedef enum {
    loose = -30,
    win = 100,
    tileMatch = 3,
    tileMissmatch = -5
    
} scoring;

@required
- (gameType) gameType:(id) sender;
- (gameKeyboardType) gameKeyboardType:(id) sender;
- (gameLevel) gameLevel:(id) sender;
- (UIView *) gameViewContainer:(id) sender;
- (NSUInteger) timeToSolve;
- (NSUInteger) maxWordLength;
- (void) scoreBoardWithGameResult:(NSArray *)gameResult;

@end


@protocol gameDatasource <NSObject>

- (NSString *) nextWord;


@end


@interface SKGameController : NSObject <scrabbleboardDelegate>

-(void)newQuestion;
-(void)stopStopwatch;

@property (weak, nonatomic) id <gameDelegate> delegate;
@property (weak, nonatomic) id <gameDatasource> datasource;


@property (weak, nonatomic) SKHUDView* hud;
@property (strong, nonatomic) SKBoardController *boardController;
@property (strong, nonatomic) NSMutableArray *gameResult; //array of wordResult



@end
