//
//  SKTileView.h
//  scrabbleKeyboard
//
//  Created by Olivier Delecueillerie on 13/05/2014.
//  Copyright (c) 2014 lagspoon.scrabbleKeyboard. All rights reserved.
//

#import "SKScrabbleView.h"
#import "SKTile.h"

@class SKTileView;
@protocol tileDelegate <NSObject>
- (void) tileView:(SKTileView*)tileView didDragToPoint:(CGPoint)pt;
- (void) tileViewIsTapped:(SKTileView *)tileView;
@end

@interface SKTileView : SKScrabbleView

@property (strong, nonatomic, readonly) SKTile *tile;
@property (weak, nonatomic) id<tileDelegate> delegate;
@property (nonatomic) CGAffineTransform initialTransform;
-(instancetype)initWithTile:(SKTile *)tile sideLength:(float)sideLength;
-(void)randomize;

@end
