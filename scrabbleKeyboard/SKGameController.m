//
//  SKWordsDataController.m
//  scrabbleKeyboard
//
//  Created by Olivier Delecueillerie on 13/05/2014.
//  Copyright (c) 2014 lagspoon.scrabbleKeyboard. All rights reserved.
//

#import "SKGameController.h"
#import "config.h"

#import "SKKeyboardController.h"
#import "SKScrabbleBoardController.h"


@interface SKGameController ()

@property (strong, nonatomic) NSString *keyboardType;
@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) NSDictionary *wordResult;
@property (strong, nonatomic) NSNumber *score;

@property (nonatomic) NSUInteger secondsLeft;
@end


@implementation SKGameController
/*////////////////////////////////////////////////////////////////////////////////////
 Accessors
 ////////////////////////////////////////////////////////////////////////////////////*/
- (void) setDelegate:(id<gameDelegate>)delegate {
    _delegate = delegate;
    if ([delegate gameKeyboardType:self] == gameKeyboardTile) {
        self.boardController = [[SKScrabbleBoardController alloc] initWithBoardInView:[delegate gameViewContainer:self]];
    } else {
        self.boardController = [[SKKeyboardController alloc] initWithBoardInView:[delegate gameViewContainer:self]];
    }
    self.boardController.delegate = self;
}


/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////

//connect the Hint button
-(void)setHud:(SKHUDView *)hud
{
    _hud = hud;
    [hud.btnHelp addTarget:self action:@selector(actionHint) forControlEvents:UIControlEventTouchUpInside];
    hud.btnHelp.enabled = NO;

}

-(NSNumber *) score {
    if (!_score) _score = [NSNumber numberWithInt:0];
    self.hud.gamePoints.value = (int)[_score integerValue];
    return _score;
}

-(NSMutableArray *) gameResult {
    if (!_gameResult) {
        _gameResult = [SKGameData gameResult];
    }
    return _gameResult;
}

/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
//Triggered action
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////


-(void)newQuestion {

    //save the result of the previous word
    if (self.boardController.word) {
        [self recordWordResult];
    }
    
    NSString *nextWord = [self.datasource nextWord];

    if (nextWord) {
        //deal new word on board
        [self.boardController dealWord:nextWord];
        //start the timer
        [self startStopwatch];
        
        self.wordResult = [SKGameData wordResult:self.wordResult StartedAt:[NSDate date] EndedAt:nil wordAsked:self.boardController.word stringInput:nil points:nil pass:NO];
        
        self.hud.btnHelp.enabled = YES;
    }
    
    else {
        
        [self stopStopwatch];
        [self.delegate scoreBoardWithGameResult:[self.gameResult copy]];
    }
}



-(BOOL) checkForSuccessForWord: (NSString *)word withAnswer:(NSString *)answer {
    if ([word isEqualToString:answer]) {
        return YES;
    } else {
        return NO;
    }
}

-(void) scoring :(scoringRules) scoringRules {
    
    self.score = [NSNumber numberWithInt:([self.score intValue] + scoringRules)];
    self.hud.gamePoints.value = [self.score intValue];
}

//the user pressed the hint button
-(void)actionHint
{
    NSLog(@"Help!");
    //1
    self.hud.btnHelp.enabled = NO;
    
    //2
    //self.data.points -= self.spelling.pointsPerTile/2;
    //[self.hud.gamePoints countTo: self.data.points withDuration: 1.5];
     [self.boardController clue];
     
}

- (void) recordWordResult {
    
    NSString *stringInput = [self.boardController.stringResult copy];
    BOOL pass = [self checkForSuccessForWord:self.boardController.word withAnswer:stringInput];
    
    self.wordResult = [SKGameData wordResult:self.wordResult
                                   StartedAt:nil
                                     EndedAt:[NSDate date]
                                   wordAsked:nil
                                 stringInput:stringInput
                                      points:self.score
                                        pass:pass];
    
    [self.gameResult addObject:[self.wordResult copy]];
    self.wordResult = nil;
}

/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
//Timer
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////

-(void)startStopwatch
{
    //initialize the timer HUD
    self.secondsLeft = [self.delegate timeToSolve];
    [self.hud.stopwatch setSeconds:(int)self.secondsLeft];
    //[self.delegate starDust];
    //schedule a new timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:self
                                            selector:@selector(tick:)
                                            userInfo:nil
                                             repeats:YES];
}


//stop the watch
-(void)stopStopwatch
{
    [self.timer invalidate];
}

//stopwatch on tick
-(void)tick:(NSTimer*)timer
{
    self.secondsLeft --;
    [self.hud.stopwatch setSeconds:(int)self.secondsLeft];
    
    if (self.secondsLeft==0) {
        [self stopStopwatch];
        [self newQuestion];
        
    }
}

/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
//boardDelegate
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////

- (void) tileMatchTarget:(BOOL) isMatching {
    if (isMatching) {
        [self scoring:tileMatch];
    } else {
        //take out points
        [self scoring:tileMissmatch];
    }
    [self.hud.gamePoints countTo:[self.score intValue] withDuration:1.5];
}

- (void) buttonHelpEnabled:(BOOL) isEnabled {
    if (isEnabled) {
        self.hud.btnHelp.enabled = YES;
    } else {
        self.hud.btnHelp.enabled = NO;
    }
}

- (void) wordFulfilled {
    [self stopStopwatch];
    [self newQuestion];
}

- (NSUInteger) numberOfLetter {
    NSUInteger level = [self.boardController.word length];
    //switch ([self.delegate level]) {
    switch (1) {
        case 1:
            level = level + 10;
            break;
        case 2:
            level = level + 15;
            break;
        case 3:
            level = 20;
        default:
            
            break;
    }
    return level;
};

@end
