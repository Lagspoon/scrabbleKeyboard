//
//  SKTileView.h
//  scrabbleKeyboard
//
//  Created by Olivier Delecueillerie on 13/05/2014.
//  Copyright (c) 2014 lagspoon.scrabbleKeyboard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKTileView;
@protocol TileDragDelegateProtocol <NSObject>
-(void)tileView:(SKTileView*)tileView didDragToPoint:(CGPoint)pt;
@end

@interface SKTileView : UIImageView

@property (strong, nonatomic, readonly) NSString* letter;
@property (assign, nonatomic) BOOL isMatched;
@property (weak, nonatomic) id<TileDragDelegateProtocol> dragDelegate;

-(instancetype)initWithLetter:(NSString*)letter andSideLength:(float)sideLength;
-(void)randomize;

@end
