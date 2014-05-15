//
//  SKWordsDataController.m
//  scrabbleKeyboard
//
//  Created by Olivier Delecueillerie on 13/05/2014.
//  Copyright (c) 2014 lagspoon.scrabbleKeyboard. All rights reserved.
//

#import "SKGameController.h"
#import "config.h"
#import "SKTargetView.h"
#import "SKExplodeView.h"
#import "SKStarDustView.h"

@interface SKGameController ()


@end


@implementation SKGameController
{
    //tile lists
    NSMutableArray* _tiles;
    NSMutableArray* _targets;
    //stopwatch variables
    int _secondsLeft;
    NSTimer* _timer;
}


//initialize the game controller
-(instancetype)init
{
    self = [super init];
    if (self != nil) {
        //initialize
        self.data = [[SKGameData alloc] init];
        self.audioController = [[SKAudioController alloc] init];
        [self.audioController preloadAudioEffects: kAudioEffectFiles];
    }
    return self;
}

//connect the Hint button
-(void)setHud:(SKHUDView *)hud
{
    _hud = hud;
    [hud.btnHelp addTarget:self action:@selector(actionHint) forControlEvents:UIControlEventTouchUpInside];
    hud.btnHelp.enabled = NO;

}
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
//
//fetches a random anagram, deals the letter tiles and creates the targets
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////

-(void)dealRandomWord
{
    //Check data avalaible
    NSAssert(self.spelling.words, @"no level loaded");
    
    //Get the word and the disorders letters
    int randomIndex = arc4random()%[self.spelling.words count];
    NSString* word = self.spelling.words[ randomIndex ];
    NSString *charactersDisordered = [self disorderedWord:word];
    int lenghtWord = [word length];
    int lenghtCharacters = [charactersDisordered length];
    
    //Log
    NSLog(@"phrase1[%i]: %@", lenghtWord, word);
    NSLog(@"phrase2[%i]: %@", lenghtCharacters, charactersDisordered);
    
    //calculate the tile size
    float tileSide = ceilf( kScreenWidth*0.9 / (float)MAX(lenghtWord, lenghtCharacters) ) - kTileMargin;
    //get the left margin for first tile
    float xOffset = (kScreenWidth - MAX(lenghtWord, lenghtCharacters) * (tileSide + kTileMargin))/2;
    
    //adjust for tile center (instead of the tile's origin)
    xOffset += tileSide/2;
    
    
    
    // initialize target list
    _targets = [NSMutableArray arrayWithCapacity: lenghtWord];
    
    // create targets
    for (int i=0;i<lenghtWord;i++) {
        NSString* letter = [word substringWithRange:NSMakeRange(i, 1)];
        
        if (![letter isEqualToString:@" "]) {
            SKTargetView* target = [[SKTargetView alloc] initWithLetter:letter andSideLength:tileSide];
            target.center = CGPointMake(xOffset + i*(tileSide + kTileMargin), kScreenHeight/4);
            
            [self.boardView addSubview:target];
            [_targets addObject: target];
        }
    }
    
    
    
    
    
    
    
    //1 initialize tile list
    _tiles = [NSMutableArray arrayWithCapacity: lenghtCharacters];
    
    //2 create tiles
    for (int i=0;i<lenghtCharacters;i++) {
        NSString* letter = [charactersDisordered substringWithRange:NSMakeRange(i, 1)];
        
        //3
        if (![letter isEqualToString:@" "]) {
            SKTileView* tile = [[SKTileView alloc] initWithLetter:letter andSideLength:tileSide];
            tile.center = CGPointMake(xOffset + i*(tileSide + kTileMargin), kScreenHeight/4*3);
            [tile randomize];
            tile.dragDelegate = self;

            //4
            [self.boardView addSubview:tile];
            [_tiles addObject: tile];
        }
    }
    
    //start the timer
    [self startStopwatch];
    self.hud.btnHelp.enabled = YES;

}


- (NSString *) disorderedWord:(NSString *) word {
    NSMutableArray *arrayWordOrdered = [NSMutableArray arrayWithCapacity:word.length];
    NSMutableArray *arrayWordDisordered =[[NSMutableArray alloc] init];
    
    for (int i=0; i<[word length]; i++) {
        NSString *stringChar = [word substringWithRange:NSMakeRange(i, 1)];
        [arrayWordOrdered addObject:stringChar];
    }
    
    while (arrayWordOrdered.count > 0) {
        int randomIndex = arc4random()%[arrayWordOrdered count];
        [arrayWordDisordered addObject:[arrayWordOrdered objectAtIndex:randomIndex]];
        [arrayWordOrdered removeObjectAtIndex:randomIndex];
    }
    return [arrayWordDisordered componentsJoinedByString:@""];
}

/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
//Triggered action
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
//the user pressed the hint button
-(void)actionHint
{
    NSLog(@"Help!");
    //1
    self.hud.btnHelp.enabled = NO;
    
    //2
    self.data.points -= self.spelling.pointsPerTile/2;
    [self.hud.gamePoints countTo: self.data.points withDuration: 1.5];
    
    //3 find the first target, not matched yet
    SKTargetView* target = nil;
    for (SKTargetView* t in _targets) {
        if (t.isMatched==NO) {
            target = t;
            break;
        }
    }
    
    //4 find the first tile, matching the target
    SKTileView* tile = nil;
    for (SKTileView* t in _tiles) {
        if (t.isMatched==NO && [t.letter isEqualToString:target.letter]) {
            tile = t;
            break;
        }
    }
    //5
    // don't want the tile sliding under other tiles
    [self.boardView bringSubviewToFront:tile];
    
    //6
    //show the animation to the user
    [UIView animateWithDuration:1.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         tile.center = target.center;
                     } completion:^(BOOL finished) {
                         //7 adjust view on spot
                         [self placeTile:tile atTarget:target];
                         
                         //8 re-enable the button
                         self.hud.btnHelp.enabled = YES;
                         
                         //9 check for finished game
                         [self checkForSuccess];                     
                     }];
    

}

/////////////////////////////////////////////////////////////////////////////////////
//TileDragDelegateProtocol
//a tile was dragged, check if matches a target
/////////////////////////////////////////////////////////////////////////////////////

-(void)tileView:(SKTileView*)tileView didDragToPoint:(CGPoint)pt
{
    SKTargetView* targetView = nil;
    
    for (SKTargetView* tv in _targets) {
        if (CGRectContainsPoint(tv.frame, pt)) {
            targetView = tv;
            break;
        }
    }
    //1 check if target was found
    if (targetView!=nil) {
        
        //2 check if letter matches
        if ([targetView.letter isEqualToString: tileView.letter]) {
            
            //3
            [self placeTile:tileView atTarget:targetView];

            NSLog(@"Success! You should place the tile here!");
            
            //more stuff to do on success here
            [self.audioController playEffect: kSoundDing];

            self.data.points += self.spelling.pointsPerTile;
            [self.hud.gamePoints countTo:self.data.points withDuration:1.5];

            //check for finished game
            [self checkForSuccess];
        
        } else {
            //4
            //1
            //visualize the mistake
            [tileView randomize];
            
            //2
            [UIView animateWithDuration:0.35
                                  delay:0.00
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 tileView.center = CGPointMake(tileView.center.x + randomf(-20, 20),
                                                               tileView.center.y + randomf(20, 30));
                             } completion:nil];
            NSLog(@"Failure. Let the player know this tile doesn't belong here.");
            
            //more stuff to do on failure here
            [self.audioController playEffect:kSoundWrong];

            //take out points
            self.data.points -= self.spelling.pointsPerTile/2;
            [self.hud.gamePoints countTo:self.data.points withDuration:.75];

        }

    }
}

-(void)placeTile:(SKTileView*)tileView atTarget:(SKTargetView*)targetView
{
    //1
    targetView.isMatched = YES;
    tileView.isMatched = YES;
    
    //2
    tileView.userInteractionEnabled = NO;
    
    //3
    [UIView animateWithDuration:0.35
                          delay:0.00
                        options:UIViewAnimationOptionCurveEaseOut
     //4
                     animations:^{
                         tileView.center = targetView.center;
                         tileView.transform = CGAffineTransformIdentity;
                     }
     //5
                     completion:^(BOOL finished){
                         targetView.hidden = YES;
                     }];
    
    SKExplodeView* explode = [[SKExplodeView alloc] initWithFrame:CGRectMake(tileView.center.x,tileView.center.y,10,10)];
    [tileView.superview addSubview: explode];
    [tileView.superview sendSubviewToBack:explode];
}


-(void)checkForSuccess
{
    for (SKTargetView* t in _targets) {
        //no success, bail out
        if (t.isMatched==NO) return;
    }
    //stop the stopwatch
    self.hud.btnHelp.enabled = NO;

    [self stopStopwatch];
    //the anagram is completed!
    [self.audioController playEffect:kSoundWin];

    //win animation
    SKTargetView* firstTarget = _targets[0];
    
    int startX = 0;
    int endX = kScreenWidth + 300;
    int startY = firstTarget.center.y;
    
    SKStarDustView* stars = [[SKStarDustView alloc] initWithFrame:CGRectMake(startX, startY, 10, 10)];
    [self.boardView addSubview:stars];
    [self.boardView sendSubviewToBack:stars];
    
    [UIView animateWithDuration:3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         stars.center = CGPointMake(endX, startY);
                     } completion:^(BOOL finished) {
                         
                         //game finished
                         [stars removeFromSuperview];
                     }];
    
    NSLog(@"Game Over!");
}


/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
//TIMER
//
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////

-(void)startStopwatch
{
    //initialize the timer HUD
    _secondsLeft = self.spelling.timeToSolve;
    [self.hud.stopwatch setSeconds:_secondsLeft];
    
    //schedule a new timer
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:self
                                            selector:@selector(tick:)
                                            userInfo:nil
                                             repeats:YES];
}

//stop the watch
-(void)stopStopwatch
{
    [_timer invalidate];
    _timer = nil;
}

//stopwatch on tick
-(void)tick:(NSTimer*)timer
{
    _secondsLeft --;
    [self.hud.stopwatch setSeconds:_secondsLeft];
    
    if (_secondsLeft==0) {
        [self stopStopwatch];
    }
}



@end
