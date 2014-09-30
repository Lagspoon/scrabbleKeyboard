//
//  SKWordsDataController.m
//  scrabbleKeyboard
//
//  Created by Olivier Delecueillerie on 13/05/2014.
//  Copyright (c) 2014 lagspoon.scrabbleKeyboard. All rights reserved.
//

#import "SKGameController.h"
#import "SKKeyboardController.h"
#import "SKScrabbleBoardController.h"


@interface SKGameController ()


@property (strong, nonatomic) NSString *wordSelected;


@property (strong, nonatomic) NSString *keyboardType;
@property (strong, nonatomic) NSTimer *timer;

//@property (strong, nonatomic) NSDictionary *wordResult;
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
        //self.boardController = [[SKKeyboardController alloc] initWithBoardInView:[delegate gameViewContainer:self]];
    }
    self.boardController.delegate = self;
}


/*////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////*/
/*
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
*/

/*////////////////////////////////////////////////////////////////////////////////////
 Triggered action
////////////////////////////////////////////////////////////////////////////////////*/

-(void)newQuestion {

    //save the result of the previous word
    /*if (self.boardController.word) {
        [self recordWordResult];
    }*/
    
    self.wordSelected = [self.datasource nextWord];

    if (self.wordSelected) {
        //deal new word on board
        [self.boardController dealWord:self.wordSelected];
        //start the timer
        [self startStopwatch];
        //self.wordResult = [SKGameData wordResult:self.wordResult StartedAt:[NSDate date] EndedAt:nil wordAsked:self.boardController.word stringInput:nil points:nil pass:NO];
        self.hud.btnHelp.enabled = YES;
        
    }  else {
        
        [self stopStopwatch];
        [self.delegate gameDidFinish];
    }
}


-(void) scoring:(scoring) scoring {
    
    self.score = [NSNumber numberWithInt:([self.score intValue] + scoring)];
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
     //[self.boardController clue];
}


/*////////////////////////////////////////////////////////////////////////////////////
 Timer
////////////////////////////////////////////////////////////////////////////////////*/

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
-(void)stopStopwatch {
    [self.timer invalidate];
}

//stopwatch on tick
-(void)tick:(NSTimer*)timer {
    self.secondsLeft --;
    [self.hud.stopwatch setSeconds:(int)self.secondsLeft];
    
    if (self.secondsLeft==0) {
        [self stopStopwatch];
        [self boardCompleted:self.boardController.word input:self.boardController.input];
    }
}

/*////////////////////////////////////////////////////////////////////////////////////
 boardDelegate
////////////////////////////////////////////////////////////////////////////////////*/

- (targetType) targetType {
    switch ([self.delegate gameType:self]) {
        case gameTypeAnagrame:
            return targetTypeAllTargetsVisible;
            break;
        case gameTypeSpelling:
            return targetTypeUnlimitedTargetsNextVisible;
            break;
        default:
            return targetTypeNextTargetVisible;
            break;
    }
}

- (BOOL) checkMatchForEachTile {
    switch ([self.delegate gameType:self]) {
        case gameTypeAnagrame:
            return YES;
            break;
        case gameTypeSpelling:
            return NO;
            break;
        default:
            return NO;
            break;
    }
}

- (void) tileMatchTarget:(BOOL) isMatching {
        switch ([self.delegate gameType:self]) {
            case gameTypeAnagrame:
                
                break;
            case gameTypeSpelling:
                
                break;
            default:
            {
                if (isMatching) {
                    [self scoring:tileMatch];
                } else {
                    //take out points
                    [self scoring:tileMissmatch];
                }
                [self.hud.gamePoints countTo:[self.score intValue] withDuration:1.5];
                break;
            }
                
        }
}

- (void) buttonHelpEnabled:(BOOL) isEnabled {
    if (isEnabled) {
        self.hud.btnHelp.enabled = YES;
    } else {
        self.hud.btnHelp.enabled = NO;
    }
}

- (void) boardCompleted:(NSString*)word input:(NSString *)input {
    
    gameResult result;
    
    if ([word isEqualToString:input]) {
        result = gameResultSuccess;
    } else {
        result = gameResultFail;
    }
    
    [self.delegate gameResult:result input:input];
    
    [self stopStopwatch];
    [self newQuestion];
}

- (NSUInteger) numberOfLetterToDeal {
    //switch ([self.delegate level]) {
    switch ([self.delegate gameLevel:self]) {
        case gameLevelEasy:
            return [self.wordSelected length] + 10;
            break;
        case gameLevelMedium:
            return [self.wordSelected length] + 15;
            break;
        case gameLevelHard:
            return [self.wordSelected length] + 20;
        default:
            return [self.wordSelected length];
            break;
    }
};

@end
