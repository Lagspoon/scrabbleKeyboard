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
#import "SKDictWordResult.h"
#import "SKTargetView.h"

@protocol boardDelegate <NSObject>

- (void) buttonHelpEnabled:(BOOL) isEnabled;
- (void) wordFulfilled;
@end


@interface SKBoardController : UIViewController

- (void) clearBoard;
- (BOOL) achievement;
//display a new word on the screen
-(void)dealWord:(NSString *) word;
-(void) clue;



@property (strong, nonatomic) NSString *word;
@property (strong, nonatomic) NSString *stringResult;
@property (weak, nonatomic) id <boardDelegate> delegate;

@end
