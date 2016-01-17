//
//  SKShapeNode+BallNode.h
//  MusicGame
//
//  Created by ethan on 6/8/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BallNode: SKShapeNode
- (id)init: (int) num vol: (int) vol hp: (int) health;
@property (nonatomic) int ident;
//intended for multivoiced operations, can also be used for other things
@property (nonatomic) int voices;
//1 for true, 0 for false
@property (nonatomic) int alive;
//should be 0-1 as a multiplier for preset volumes
@property (nonatomic) double volume;
//for degradable balls (i.e. delete balls)
@property (nonatomic) int health;
//color properties
@property (nonatomic) double r;
@property (nonatomic) double g;
@property (nonatomic) double b;
@property (nonatomic) double a;

@end
