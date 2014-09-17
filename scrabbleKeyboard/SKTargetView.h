//
//  SKTargetView.h
//  scrabbleKeyboard
//
//  Created by Olivier Delecueillerie on 13/05/2014.
//  Copyright (c) 2014 lagspoon.scrabbleKeyboard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKTarget.h"
#import "SKTileView.h"

@interface SKTargetView : UIImageView


@property (nonatomic, strong, readonly) SKTarget *target;
@property (nonatomic, strong) SKTileView *tileViewOnto;
-(instancetype)initWithTarget:(SKTarget*)target sideLength:(float) sideLength;

@end
