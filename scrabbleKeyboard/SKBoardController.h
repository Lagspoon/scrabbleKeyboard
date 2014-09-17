//
//  SKGameController.h
//  scrabbleKeyboard
//
//  Created by Olivier Delecueillerie on 13/05/2014.
//  Copyright (c) 2014 lagspoon.scrabbleKeyboard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKTileView.h"
#import "SKHUDView.h"
#import "SKAudioController.h"
#import "SKDictWordResult.h"
#import "SKTargetView.h"

@protocol boardDelegate <NSObject>

- (void) tileMatchTarget:(BOOL) isMatching;
- (void) buttonHelpEnabled:(BOOL) isEnabled;
//- (void) boardIsSucceeded:(BOOL) isSucceeded;
- (void) wordFulfilled;
@optional
- (NSUInteger) numberOfLetter;
@end


@interface SKBoardController : UIViewController


- (id) initWithBoardInView:(UIView *)viewBoard;
- (void) clearBoard;
- (BOOL) achievement;

//display a new word on the screen
-(void)dealWord:(NSString *) word;
//- (void) moveNextTileToTarget;
-(void) clue;



@property (strong, nonatomic) NSString *word;
@property (strong, nonatomic) NSString *stringResult;

@property (strong, nonatomic) SKAudioController* audioController;
@property (strong, nonatomic) id <boardDelegate> delegate;

@end
