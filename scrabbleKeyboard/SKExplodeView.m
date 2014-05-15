//
//  SKExplodeView.m
//  scrabbleKeyboard
//
//  Created by Olivier Delecueillerie on 15/05/2014.
//  Copyright (c) 2014 lagspoon.scrabbleKeyboard. All rights reserved.
//

#import "SKExplodeView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SKExplodeView


{
    CAEmitterLayer* _emitter;
}

// 3
// with the other methods
+ (Class) layerClass
{
    //configure the UIView to have emitter layer
    return [CAEmitterLayer class];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //initialize the emitter
        _emitter = (CAEmitterLayer*)self.layer;
        _emitter.emitterPosition = CGPointMake(self.bounds.size.width /2, self.bounds.size.height/2 );
        _emitter.emitterSize = self.bounds.size;
        _emitter.emitterMode = kCAEmitterLayerAdditive;
        _emitter.emitterShape = kCAEmitterLayerRectangle;
    }
    return self;
}

-(void)didMoveToSuperview
{
    //1
    [super didMoveToSuperview];
    if (self.superview==nil) return;
    
    //2
    UIImage* texture = [UIImage imageNamed:@"particle.png"];
    NSAssert(texture, @"particle.png not found");
    
    //3
    CAEmitterCell* emitterCell = [CAEmitterCell emitterCell];
    
    //4
    emitterCell.contents = (__bridge id)[texture CGImage];
    emitterCell.color = [[UIColor colorWithRed:0.3 green:0.85 blue:0.39 alpha:0.8] CGColor];

    
    //5
    emitterCell.name = @"cell";
    
    //6
    emitterCell.birthRate = 1000;
    emitterCell.lifetime = 0.75;
    
    //7
    emitterCell.blueRange = 0.33;
    emitterCell.blueSpeed = -0.33;
    
    //8
    emitterCell.velocity = 160;
    emitterCell.velocityRange = 40;
    
    //9
    emitterCell.scaleRange = 0.5;
    emitterCell.scaleSpeed = -0.2;
    
    //10
    emitterCell.emissionRange = M_PI*2;
    
    //11
    _emitter.emitterCells = @[emitterCell];
    
    [self performSelector:@selector(disableEmitterCell) withObject:nil afterDelay:0.1];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2.0];
}

-(void)disableEmitterCell
{
    [_emitter setValue:@0 forKeyPath:@"emitterCells.cell.birthRate"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
