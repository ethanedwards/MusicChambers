//
//  SKShapeNode+BubbleNode.m
//  MusicGame
//
//  Created by ethan on 6/19/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import "SKShapeNode+BubbleNode.h"

@implementation BubbleNode

@synthesize health;
-(id) init{
    self.health = 20;
    self = [super init];
    return self;
}
@end
