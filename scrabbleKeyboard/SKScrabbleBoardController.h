//
//  SKGameController.h
//  scrabbleKeyboard
//
//  Created by Olivier Delecueillerie on 13/05/2014.
//  Copyright (c) 2014 lagspoon.scrabbleKeyboard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKBoardController.h"
#import "SKTileView.h"
#import "SKHUDView.h"
//#import "SKAudioController.h"
@protocol scrabbleboardDelegate <boardDelegate>


typedef enum targetType {
    targetTypeAllTargetsVisible = 0, //Ex. Anagram
    targetTypeNextTargetVisible = 1, // Ex. Anagram
    targetTypeUnlimitedTargetsNextVisible = 2,
    //targetTypeInfiniteNumberOfLetterWithOneVisible = 3,
    
} targetType;

- (void) tileMatchTarget:(BOOL) isMatching;
- (NSUInteger) numberOfLetterToDeal;
- (targetType) targetType;
- (BOOL) checkMatchForEachTile;  //Did we check if the tile match the target each time we move a tile or just one time at the end of the word test

@end

@interface SKScrabbleBoardController : SKBoardController <tileDelegate>

@property (strong, nonatomic) NSMutableArray* tileViews;
@property (strong, nonatomic) NSMutableArray* targetViews;
@property (weak, nonatomic) id <scrabbleboardDelegate> delegate;

- (id) initWithBoardInView:(UIView *)viewBoard;

@end
