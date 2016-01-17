//
//  GameScene.h
//  MusicGame
//

//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "RTcmixPlayer.h"
#import "SKShapeNode+BallNode.h"
#import "SKShapeNode+BubbleNode.h"
@import CoreGraphics;

@interface GameScene : SKScene <SKPhysicsContactDelegate, RTcmixPlayerDelegate>

@property (nonatomic, strong)	RTcmixPlayer	*rtcmixManager;

@end
