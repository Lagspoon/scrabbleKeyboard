//
//  SKViewController.m
//  scrabbleKeyboard
//
//  Created by Olivier Delecueillerie on 13/05/2014.
//  Copyright (c) 2014 lagspoon.scrabbleKeyboard. All rights reserved.
//

#import "SKViewController.h"
#import "SKGameController.h"
#import "SKScrabbleBoardController.h"
#import "SKHUDView.h"

@interface SKViewController ()

@property (strong, nonatomic) SKGameController *gameController;
@property (strong, nonatomic) SKScrabbleBoardController *boardController;

@property (weak, nonatomic) IBOutlet UIView *viewBoard;
@property (weak, nonatomic) IBOutlet UILabel *labelWord;

@property (weak, nonatomic) IBOutlet UIView *viewStopwatch;
@property (weak, nonatomic) IBOutlet SKHUDView *viewHud;
@property (weak, nonatomic) IBOutlet SKCounterLabelView *viewCounter;

@property (strong, nonatomic) NSArray *arrayWords;

@end

@implementation SKViewController

/*//////////////////////////////////////////////////////////////////////////////////////////////
 Accessors
 //////////////////////////////////////////////////////////////////////////////////////////////*/

- (SKGameController *) gameController {
    if (!_gameController) {
        //create the game controller
        
        _gameController = [[SKGameController alloc] init];
        _gameController.delegate = self;
        _gameController.datasource = self;
       // _gameController.spelling = self.spelling;
       // _gameController.hud = self.viewHud;
    }
    return _gameController;
}



/*//////////////////////////////////////////////////////////////////////////////////////////////
 LifeCycle VC
 //////////////////////////////////////////////////////////////////////////////////////////////*/


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.gameController newQuestion];
    self.labelWord.text = [self nextWord];
}

///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
//Game controller Delegate and Datasource
///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
- (void) scoreBoardWithGameResult:(NSArray *)gameResult {
    [self performSegueWithIdentifier:@"testResult" sender:self];
}

- (NSUInteger) timeToSolve {
    return 60;
}

- (NSUInteger) maxWordLength {
    return 10;
}

- (UIView *) gameViewContainer:(id)sender {
    return self.viewBoard;
}

- (gameKeyboardType) gameKeyboardType:(id)sender {
    return gameKeyboardTile;
}


- (NSString *) nextWord {
    return @"Hello";
}


- (void) starDust {
}




@end

