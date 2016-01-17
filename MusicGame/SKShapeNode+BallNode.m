//
//  SKShapeNode+BallNode.m
//  MusicGame
//
//  Created by ethan on 6/8/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import "SKShapeNode+BallNode.h"

@implementation BallNode
@synthesize ident;
@synthesize voices;
@synthesize alive;
@synthesize volume;
@synthesize health;
@synthesize r;
@synthesize g;
@synthesize b;
@synthesize a;
- (id)init: (int) num vol: (int) vol hp: (int) healthPoints {
    self.ident = num;
    self.voices = 1;
    self.alive = 1;
    self.volume = vol;
    self.health = healthPoints;
    self = [super init];
    return self;
}

@end
