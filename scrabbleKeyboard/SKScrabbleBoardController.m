//
//  SKWordsDataController.m
//  scrabbleKeyboard
//
//  Created by Olivier Delecueillerie on 13/05/2014.
//  Copyright (c) 2014 lagspoon.scrabbleKeyboard. All rights reserved.
//

#import "SKScrabbleBoardController.h"
#import "SKTargetView.h"
#import "SKExplodeView.h"
#import "SKStarDustView.h"
#import "SKTile.h"
#import <AudioToolbox/AudioToolbox.h>

#define kTileMargin 2.0


@interface SKScrabbleBoardController ()

@property (strong, nonatomic) NSString *stringRandomWithWord;
@property (nonatomic) NSUInteger numberOfTargets;
@end


@implementation SKScrabbleBoardController
@synthesize word = _word;

/*///////////////////////////////////////////////////////////////////////
 Initializer
 ///////////////////////////////////////////////////////////////////////*/
- (id) initWithBoardInView:(UIView *)viewBoard {
    self = [super init];
    if (self) {
        self.view = viewBoard;
    }
    return self;
}

/*///////////////////////////////////////////////////////////////////////
 Accessors
 ///////////////////////////////////////////////////////////////////////*/

- (void) setWord:(NSString *)word {
    _word = word;
    self.stringRandomWithWord = nil;
}

- (NSUInteger) numberOfTargets {
    if (!_numberOfTargets) {
        switch ([self.delegate targetType]) {
            case targetTypeAllLetters:
                _numberOfTargets = [self.word length];
                break;
                
            case targetTypeMoreNumberOfLetterWithOneVisible:
                _numberOfTargets = ceilf([self.word length]*1.3);
                
            case targetTypeSameNumberOfLetterWithOneVisible:
                _numberOfTargets = [self.word length];
                
            default:
                _numberOfTargets = [self.word length];
                break;
        }
    }
    return _numberOfTargets;
}

- (NSString *) stringRandomWithWord {
    if (!_stringRandomWithWord)  {
        
        NSArray *arrayOfStringChar = @[@"a", @"b", @"c", @"d", @"e", @"f", @"g",@"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w",@"x", @"y", @"z", @"à", @"é", @"è", @"ê",@"ï"];
        NSMutableArray *arrayWordOrdered = [NSMutableArray arrayWithCapacity:[self.word length]];
        NSMutableArray *arrayWordDisordered =[[NSMutableArray alloc] init];
        
        for (int i=0; i<[self.word length]; i++) {
            NSString *stringChar = [self.word substringWithRange:NSMakeRange(i, 1)];
            [arrayWordOrdered addObject:stringChar];
        }
        
        for (int i = (int)[self.word length]; i<[self.delegate numberOfLetter]; i++) {
            [arrayWordOrdered addObject:[arrayOfStringChar objectAtIndex:(arc4random()%[arrayOfStringChar count])]];
        }
        
        while (arrayWordOrdered.count > 0) {
            int randomIndex = arc4random()%[arrayWordOrdered count];
            [arrayWordDisordered addObject:[arrayWordOrdered objectAtIndex:randomIndex]];
            [arrayWordOrdered removeObjectAtIndex:randomIndex];
        }
        
        NSLog(@"lettre %@",[arrayWordDisordered componentsJoinedByString:@""]);
        _stringRandomWithWord = [arrayWordDisordered componentsJoinedByString:@""];
    }
    return _stringRandomWithWord;
}


-(NSMutableArray *) targetViews {
    if (!_targetViews) {
        
        
        _targetViews = [NSMutableArray arrayWithCapacity:self.numberOfTargets];
        
        
        for (int i=0;i<self.numberOfTargets;i++) {
            SKTarget *newTarget = [[SKTarget alloc] init];
            if (i<[self.word length]) {
                newTarget.letter = [self.word substringWithRange:NSMakeRange(i, 1)];
            } else {
                newTarget.letter = nil;
            } 
            newTarget.isMatched = NO;

            if (!([newTarget.letter isEqualToString:@" "] && [self.delegate targetType]==targetTypeAllLetters)) {
                SKTargetView* targetView = [[SKTargetView alloc] initWithTarget:newTarget sideLength:[self tileSide]];
                
                CGPoint point =  CGPointMake([self xOffsetForTargetView] + 0.5*[self tileSide] + i*([self tileSide] + kTileMargin), (0.5*[self tileSide] + 20));
                targetView.center = point;
                if (i==0) {
                    targetView.target.isEnabled = YES;
                } else {
                    targetView.target.isEnabled = NO;
                }
                
                [self.view addSubview:targetView];
                [_targetViews addObject:targetView];
            }
        }
    }
    return _targetViews;
}



- (NSMutableArray *) tileViews {
    
    if (!_tileViews) {
        
        _tileViews = [NSMutableArray arrayWithCapacity: [self.delegate numberOfLetter] ];
        
        for (int i=0;i<[self.delegate numberOfLetter];i++) {
            NSString* letter = [self.stringRandomWithWord substringWithRange:NSMakeRange(i, 1)];
            // no tiles for space char
            if (![letter isEqualToString:@" "]) {
                SKTile *newTile = [[SKTile alloc] init];
                newTile.letter = letter;
                newTile.isMatched = NO;
                
                SKTileView* tileView = [[SKTileView alloc] initWithTile:newTile sideLength:[self tileSide]];
                
                //new line each  maxNumberOfLettersPerLine tile
                tileView.center = CGPointMake([self xOffsetForTileView] + (0.5+(i%[self maxNumberOfLettersPerLine]))*([self tileSide] + kTileMargin), 3*[self tileSide] + [self tileSide]*1.5 *floor(i/[self maxNumberOfLettersPerLine]));
                [tileView randomize];
                tileView.delegate = self;
                
                [self.view addSubview:tileView];
                [_tileViews addObject:tileView];
            }
        }
    }
    return _tileViews;
}




/*///////////////////////////////////////////////////////////////////////
 utilies
 ///////////////////////////////////////////////////////////////////////*/

- (float) xOffsetForTargetView {
    float result = (self.view.bounds.size.width - [self.word length]*([self tileSide]+kTileMargin))/2;
    return result;
}
- (float) xOffsetForTileView {
    float result =  (self.view.bounds.size.width - MIN([self.stringRandomWithWord length],[self maxNumberOfLettersPerLine])*([self tileSide] + kTileMargin))/2;
    return result;
}
- (float) tileSide {
    /*calculate the tile size tile side depens of the number of lines and the number of letter */
    float result = ceilf(self.view.bounds.size.width *0.9 / MIN([self maxNumberOfLettersPerLine],[self.delegate numberOfLetter])) - kTileMargin;
    return result;
    
}

- (NSUInteger) maxNumberOfLettersPerLine {
    NSUInteger result;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        /* Device is iPad */
        result =  MAX(15, [self.word length]);
    } else {
        result =  MAX(6, [self.word length]);
    }
    return result;
}
/*///////////////////////////////////////////////////////////////////////
 utilies
 ///////////////////////////////////////////////////////////////////////*/

-(NSString *) stringResult {
    NSMutableArray *arrayStringResult = [[NSMutableArray alloc] init];
    for (SKTargetView *targetView in self.targetViews) {
        NSString *stringInput = targetView.tileViewOnto.tile.letter;
        if (stringInput) {
            [arrayStringResult addObject:stringInput];
        } else {
            [arrayStringResult addObject:@" "];
        }
    }
    return [arrayStringResult componentsJoinedByString:@""];
}

 
//fetches a random anagram, deals the letter tiles and creates the targets
-(void)dealWord:(NSString *)word {
    [super dealWord:word];
    [self clearBoard];
    [self targetViews];
    [self tileViews];
}




/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
//Triggered action
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////



//clear the tiles and targets
-(void)clearBoard
{
    [super clearBoard];
    self.targetViews = nil;
    self.tileViews = nil;
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
}

- (void) clue {
    [self moveNextTileToTarget];
}

- (void) moveNextTileToTarget {
    //find the first target, not matched yet
    SKTargetView* targetView = [self nextUnmatchedTargetView];
    
    //find the first tile, matching the target
    SKTileView* nextTileView;
    for (SKTileView *tileView in self.tileViews) {
        if ((!tileView.tile.isMatched) && [tileView.tile.letter isEqualToString:targetView.target.letter]) {
            nextTileView = tileView;
            break;
        }
    }
    
    // don't want the tile sliding under other tiles
    [self.view bringSubviewToFront:nextTileView];
    
    //show the animation to the user
    [UIView animateWithDuration:1.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         nextTileView.center = targetView.center;
                     } completion:^(BOOL finished) {
                         //re-enable the button
                         [self.delegate buttonHelpEnabled:YES];
                         //check for finished game
                         [self isTileView:nextTileView matchTargetView:targetView];
                     }];
}

-(void)placeTile:(SKTileView*)tileView atTarget:(SKTargetView*)targetView
{
    //adjust view on spot
    //1
    targetView.target.isMatched = YES;
    tileView.tile.isMatched = YES;
    
    //2
    tileView.userInteractionEnabled = NO;
    
    //3
    [UIView animateWithDuration:0.35
                          delay:0.00
                        options:UIViewAnimationOptionCurveEaseOut
     //4
                     animations:^{
                         tileView.center = targetView.center;
                         tileView.transform = tileView.initialTransform;//CGAffineTransformIdentity;
                         
                     }
     //5
                     completion:^(BOOL finished){
                         targetView.hidden = YES;
                     }];
    
    SKExplodeView* explode = [[SKExplodeView alloc] initWithFrame:CGRectMake(tileView.center.x,tileView.center.y,10,10)];
    [tileView.superview addSubview: explode];
    [tileView.superview sendSubviewToBack:explode];
}


-(BOOL)checkForSuccess {
    if ([self nextUnenabledTargetView]) {
        SKTargetView *nextTargetView = [self nextUnenabledTargetView];
        nextTargetView.target.isEnabled = YES;
    }
    
    if (![self nextUnmatchedTargetView]) {
        
        //win animation
        SKTargetView* firstTarget = [self.targetViews firstObject] ;
        
        int startX = 0;
        int endX = 300 + [UIScreen mainScreen].bounds.size.width;
        int startY = firstTarget.center.y;
        
        SKStarDustView* stars = [[SKStarDustView alloc] initWithFrame:CGRectMake(startX, startY, 10, 10)];
        [self.view addSubview:stars];
        [self.view sendSubviewToBack:stars];
        
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
        return YES;
    } else return NO;
    [super achievement];
}


- (SKTargetView *) targetViewAtPoint:(CGPoint)point {
    //which is the target view at this point ?
    for (SKTargetView *targetView in self.targetViews) {
        if (CGRectContainsPoint(targetView.frame, point)) {
            return targetView;
            break;
        }
    }
    return nil;
}


- (BOOL) isTileView:(SKTileView *)tileView matchTargetView:(SKTargetView *)targetView {
    
    if (targetView) {
        
        //check if letter matches
        BOOL isMatching = [targetView.target.letter isEqualToString: tileView.tile.letter];
        if (isMatching) {
            
            [self placeTile:tileView atTarget:targetView];
            
            NSLog(@"Success! You should place the tile here!");
            
            //more stuff to do on success here
            //[self.audioController playEffect: kSoundDing];
            
            //change the tag before checkForSuccess method
            targetView.target.isMatched= YES;
            
            //write input in target
            targetView.tileViewOnto = tileView;
            
            //check for finished game
            [self checkForSuccess];
            
        } else {
            
            //visualize the mistake
            [tileView randomize];
            
            [UIView animateWithDuration:0.35
                                  delay:0.00
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 tileView.center = CGPointMake(tileView.center.x + [self randomBetweenMin:-20 Max:20],
                                                               tileView.center.y + [self randomBetweenMin:20 Max:30]);
                             } completion:nil];
            NSLog(@"Failure. Let the player know this tile doesn't belong here.");
            
            //more stuff to do on failure here
            //[self.audioController playEffect:kSoundWrong];
            targetView.target.isMatched=NO;
        }
        [self.delegate tileMatchTarget:isMatching];
        return isMatching;

    } else {
        return NO;
    }
}

- (float) randomBetweenMin :(NSInteger)min Max:(NSInteger)max {
    return ((float)(arc4random() % (max - min + 1)) + (float)min);
}

/*////////////////////////////////////////////////////////////////////////////////////
 TileDelegate
 ////////////////////////////////////////////////////////////////////////////////////*/

//a tile was dragged, check if matches a target
-(void)tileView:(SKTileView*)tileView didDragToPoint:(CGPoint)pt {

    SKTargetView* targetView = [self targetViewAtPoint:pt];
    [self isTileView:tileView matchTargetView:targetView];
}

- (void) tileViewIsTapped:(SKTileView *)tileView {
    
    SKTargetView* targetView = [self nextUnmatchedTargetView];
    [self isTileView:tileView matchTargetView:targetView];
}


/*////////////////////////////////////////////////////////////////////////////////////
 Utilities
 ////////////////////////////////////////////////////////////////////////////////////*/

- (SKTargetView *)nextUnmatchedTargetView {
    //find the first target, not matched yet
    for (SKTargetView *targetView in self.targetViews) {
        if (!targetView.target.isMatched) {
            return targetView;
            break;
        }
    }
    return nil;
}

- (SKTargetView *)nextUnenabledTargetView {
    for (SKTargetView *targetView in self.targetViews) {
        if (!targetView.target.isEnabled) {
            return targetView;
            break;
        }
    }
    return nil;
}
@end
