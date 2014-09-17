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
#import "SKBoardController.h"

@protocol gameDelegate <NSObject>

typedef enum gameKeyboardType gameKeyboardType;
enum gameKeyboardType
{
    gameKeyboardTile = 0,
    gameKeyboardStandard = 1,
};


@required

- (gameKeyboardType) gameKeyboardType:(id) sender;
- (UIView *) gameViewContainer:(id) sender;
- (NSUInteger) timeToSolve;
- (NSUInteger) maxWordLength;
- (void) scoreBoardWithGameResult:(NSArray *)gameResult;
//- (void)starDust;
//- (NSUInteger) level;

@end


@protocol gameDatasource <NSObject>

- (NSString *) nextWord;


@end


@interface SKGameController : NSObject <boardDelegate>

-(void)newQuestion;
-(void)stopStopwatch;

@property (weak, nonatomic) id <gameDelegate> delegate;
@property (weak, nonatomic) id <gameDatasource> datasource;


@property (weak, nonatomic) SKHUDView* hud;
@property (strong, nonatomic) SKBoardController *boardController;
@property (strong, nonatomic) NSMutableArray *gameResult; //array of wordResult

typedef enum {
    easy = 0,
    medium = 1,
    hard = 2,
} gameLevel;

typedef enum {
    loose = -30,
    win = 100,
    tileMatch = 3,
    tileMissmatch = -5
    
} scoringRules;

@end
