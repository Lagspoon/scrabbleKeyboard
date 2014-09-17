//
//  SKWordsDataController.m
//  scrabbleKeyboard
//
//  Created by Olivier Delecueillerie on 13/05/2014.
//  Copyright (c) 2014 lagspoon.scrabbleKeyboard. All rights reserved.
//

#import "SKKeyboardController.h"
#import "SKExplodeView.h"
#import "SKStarDustView.h"


@interface SKKeyboardController ()

@property (strong, nonatomic) UITextField *textField;
@end


@implementation SKKeyboardController

- (NSString *) stringResult {
    NSString *string = self.textField.text;
    
    return string;

}
//initialize the game controller
-(instancetype)init
{
    self = [super init];
    if (self) {
        //
    }
    return self;
}

- (id) initWith:(NSString*) keyboardType inView:(UIView *)viewBoard {
    self = [super initWithBoardInView:viewBoard];
    
    return self;
}

- (void) viewDidLayoutSubviews {
    
    self.textField = [[UITextField alloc] initWithFrame:[self frameForTextField]];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.keyboardType = UIKeyboardTypeASCIICapable;
    self.textField.returnKeyType = UIReturnKeyNext;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.spellCheckingType = UITextSpellCheckingTypeNo;
    self.textField.delegate = self;
    
    [self.view addSubview:self.textField];
    [self.textField becomeFirstResponder];
    
}

- (CGRect) frameForTextField {
    float width = 300.0;
    float height = 60.0;
    float x =  (self.view.bounds.size.width - width)/2;
    float y = 1.0;
    
    CGRect frame = CGRectMake(x, y, width, height);
    return frame;

}

/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
//
//fetches a random anagram, deals the letter tiles and creates the targets
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////

-(void) dealWord:(NSString *)word {
    
    [super dealWord:word];
    self.textField.text = @"";
    
}

/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
//TextField Delegate
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////


//clear the tiles and targets
- (void) textFieldDidEndEditing:(UITextField *)textField {
    //[self checkForSuccess];
}

@end
