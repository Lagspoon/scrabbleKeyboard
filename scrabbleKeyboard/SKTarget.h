//
//  SKTarget.h
//  scrabbleKeyboard
//
//  Created by Olivier Delecueillerie on 16/09/2014.
//  Copyright (c) 2014 lagspoon.scrabbleKeyboard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SKTarget : NSObject

@property (strong, nonatomic) NSString *letter;
@property (nonatomic) BOOL isMatched;
@property (nonatomic) BOOL isEnabled;
@property (weak, nonatomic) UIView *view;
@end
