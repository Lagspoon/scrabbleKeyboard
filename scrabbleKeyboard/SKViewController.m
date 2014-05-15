//
//  SKViewController.m
//  scrabbleKeyboard
//
//  Created by Olivier Delecueillerie on 13/05/2014.
//  Copyright (c) 2014 lagspoon.scrabbleKeyboard. All rights reserved.
//

#import "SKViewController.h"
#import "SKWordsData.h"
#import "SKGameController.h"
#import "config.h"
#import "SKHUDView.h"

@interface SKViewController ()

@property (strong, nonatomic) SKGameController* controller;

@end

@implementation SKViewController

-(instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self != nil) {
        //create the game controller
        self.controller = [[SKGameController alloc] init];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    SKWordsData* spelling1 = [SKWordsData spellingWithNum:1];
    NSLog(@"words: %@", spelling1.words);

    UIView* boardLayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview: boardLayer];
    
    self.controller.boardView = boardLayer;
    //add one layer for all hud and controls
    SKHUDView* hudView = [SKHUDView viewWithRect:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:hudView];
    
    self.controller.hud = hudView;
    self.controller.spelling = spelling1;
    [self.controller dealRandomWord];
}



@end
