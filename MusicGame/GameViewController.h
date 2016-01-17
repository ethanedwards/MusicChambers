//
//  GameViewController.h
//  MusicGame
//

//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "RTcmixPlayer.h"

@interface GameViewController : UIViewController <RTcmixPlayerDelegate>

@property (nonatomic, strong)	RTcmixPlayer	*rtcmixManager;

- (NSString *) convertArray:(NSArray *) ballray;

@end
