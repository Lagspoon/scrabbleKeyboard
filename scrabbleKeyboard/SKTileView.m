//
//  SKTileView.m
//  scrabbleKeyboard
//
//  Created by Olivier Delecueillerie on 13/05/2014.
//  Copyright (c) 2014 lagspoon.scrabbleKeyboard. All rights reserved.
//

#import "SKTileView.h"
#import "config.h"
#import <QuartzCore/QuartzCore.h>

@interface SKTileView ()

@property (nonatomic, strong, readwrite) SKTile *tile; //override the readonly attribute
@property (nonatomic, strong) UIGestureRecognizer *tapeGestureRecognizer;
@end

@implementation SKTileView

{
    int _xOffset, _yOffset;
    //CGAffineTransform _tempTransform;

}

//1
- (id)initWithFrame:(CGRect)frame
{
    NSAssert(NO, @"Use initWithLetter:andSideLength instead");
    return nil;
}

//2 create new tile for a given letter
-(instancetype)initWithTile:(SKTile *)tile sideLength:(float)sideLength {
    //the tile background
    UIImage* img = [UIImage imageNamed:@"tile"];
    
    //create a new object
    self = [super initWithImage:img];
    
    //graphic
    if (self) {
        //3 resize the tile
        float scale = sideLength/img.size.width;
        self.frame = CGRectMake(0,0,img.size.width*scale, img.size.height*scale);
        
        //add a letter on top
        UILabel* lblChar = [[UILabel alloc] initWithFrame:self.bounds];
        lblChar.textAlignment = NSTextAlignmentCenter;
        lblChar.textColor = [UIColor blackColor];
        lblChar.backgroundColor = [UIColor clearColor];
        lblChar.text = [tile.letter uppercaseString];
        lblChar.font = [UIFont fontWithName:@"Verdana-Bold" size:78.0*scale];
        [self addSubview: lblChar];
    }

    self.tile = tile;
    
    // enable user interaction
    self.userInteractionEnabled = YES;
    
    //shadow
    //create the tile shadow
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0;
    self.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
    self.layer.shadowRadius = 15.0f;
    self.layer.masksToBounds = NO;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.shadowPath = path.CGPath;
    
    //gesture recognizer for a tap gesture
    UITapGestureRecognizer *tapeGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tapeGestureRecognizer];
    
    return self;
}

-(void)randomize {
    //1
    //set random rotation of the tile
    //anywhere between -0.2 and 0.3 radians
    float rotation = randomf(0,50) / (float)100 - 0.2;
    self.initialTransform = self.transform;
    self.transform = CGAffineTransformMakeRotation( rotation );
    //save the current transform
    //2
    //move randomly upwards
    int yOffset = (arc4random() % 10) - 10;
    self.center = CGPointMake(self.center.x, self.center.y + yOffset);
}

/*//////////////////////////////////////////////////////////////////////
 UIResponder
 /////////////////////////////////////////////////////////////////////*/

- (void) tapAction {
    NSLog(@"tap action");
    //self.transform = _tempTransform;
    [self.delegate tileViewIsTapped:self];
}

//1
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touch began");
    CGPoint pt = [[touches anyObject] locationInView:self.superview];
    _xOffset = pt.x - self.center.x;
    _yOffset = pt.y - self.center.y;
    //show the drop shadow
    self.layer.shadowOpacity = 0.8;
    //save the current transform
    //_tempTransform = self.transform;
    //enlarge the tile
    self.transform = CGAffineTransformScale(self.transform, 1.2, 1.2);
    [self.superview bringSubviewToFront:self];
}

//2
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"TOUCH MOVED");
    CGPoint pt = [[touches anyObject] locationInView:self.superview];
    self.center = CGPointMake(pt.x - _xOffset, pt.y - _yOffset);
}

//3
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touches ended");
    [self touchesMoved:touches withEvent:event];
    
    //self.transform = _tempTransform;

    if (self.delegate) {
        [self.delegate tileView:self didDragToPoint:self.center];
    }
    self.layer.shadowOpacity = 0.0;

}
//reset the view transoform in case drag is cancelled
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    //self.transform = _tempTransform;
    self.layer.shadowOpacity = 0.0;
}

@end
