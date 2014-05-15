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

@implementation SKTileView

{
    int _xOffset, _yOffset;
    CGAffineTransform _tempTransform;

}

//1
- (id)initWithFrame:(CGRect)frame
{
    NSAssert(NO, @"Use initWithLetter:andSideLength instead");
    return nil;
}

//2 create new tile for a given letter
-(instancetype)initWithLetter:(NSString*)letter andSideLength:(float)sideLength
{
    //the tile background
    UIImage* img = [UIImage imageNamed:@"tile.png"];
    
    //create a new object
    self = [super initWithImage:img];
    
    if (self != nil) {
        
        //3 resize the tile
        float scale = sideLength/img.size.width;
        self.frame = CGRectMake(0,0,img.size.width*scale, img.size.height*scale);
        
        //add a letter on top
        UILabel* lblChar = [[UILabel alloc] initWithFrame:self.bounds];
        lblChar.textAlignment = NSTextAlignmentCenter;
        lblChar.textColor = [UIColor whiteColor];
        lblChar.backgroundColor = [UIColor clearColor];
        lblChar.text = [letter uppercaseString];
        lblChar.font = [UIFont fontWithName:@"Verdana-Bold" size:78.0*scale];
        [self addSubview: lblChar];    }
    
    //begin in unmatched state
    self.isMatched = NO;
    
    //save the letter
    _letter = letter;
    
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
    
    
    
    
    return self;
}

-(void)randomize
{
    //1
    //set random rotation of the tile
    //anywhere between -0.2 and 0.3 radians
    float rotation = randomf(0,50) / (float)100 - 0.2;
    self.transform = CGAffineTransformMakeRotation( rotation );
    
    //2
    //move randomly upwards
    int yOffset = (arc4random() % 10) - 10;
    self.center = CGPointMake(self.center.x, self.center.y + yOffset);
}


#pragma mark - dragging the tile
//1
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pt = [[touches anyObject] locationInView:self.superview];
    _xOffset = pt.x - self.center.x;
    _yOffset = pt.y - self.center.y;
    //show the drop shadow
    self.layer.shadowOpacity = 0.8;
    //save the current transform
    _tempTransform = self.transform;
    //enlarge the tile
    self.transform = CGAffineTransformScale(self.transform, 1.2, 1.2);
    [self.superview bringSubviewToFront:self];

}

//2
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pt = [[touches anyObject] locationInView:self.superview];
    self.center = CGPointMake(pt.x - _xOffset, pt.y - _yOffset);
}

//3
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
    
    self.transform = _tempTransform;

    if (self.dragDelegate) {
        [self.dragDelegate tileView:self didDragToPoint:self.center];
    }
    self.layer.shadowOpacity = 0.0;

}
//reset the view transoform in case drag is cancelled
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.transform = _tempTransform;
    self.layer.shadowOpacity = 0.0;
}
@end
