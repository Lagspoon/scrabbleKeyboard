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


@interface SKScrabbleBoardController : SKBoardController <tileDelegate>

@property (strong, nonatomic) NSMutableArray* tileViews;
@property (strong, nonatomic) NSMutableArray* targetViews;

//@property (strong, nonatomic) SKTargetView *nextTargetView;
@end
