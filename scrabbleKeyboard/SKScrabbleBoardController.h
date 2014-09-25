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

- (void) tileMatchTarget:(BOOL) isMatching;
- (NSUInteger) numberOfLetter;

typedef enum targetType {
    targetTypeAllLetters = 0,
    targetTypeSameNumberOfLetterWithOneVisible = 1,
    targetTypeMoreNumberOfLetterWithOneVisible = 2,
    
} targetType;

- (targetType) targetType;


@end

@interface SKScrabbleBoardController : SKBoardController <tileDelegate>

@property (strong, nonatomic) NSMutableArray* tileViews;
@property (strong, nonatomic) NSMutableArray* targetViews;
@property (weak, nonatomic) id <scrabbleboardDelegate> delegate;

- (id) initWithBoardInView:(UIView *)viewBoard;

@end
