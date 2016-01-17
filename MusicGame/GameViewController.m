//
//  GameViewController.m
//  MusicGame
//
//  Created by ethan on 4/11/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
//Array storing instructions
//NSMutableArray *balls;

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation GameViewController
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    if (!skView.scene) {
//        skView.showsFPS = YES;
//        skView.showsNodeCount = YES;
        
        // Create and configure the scene.
//        GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
        SKScene * scene = [GameScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        [self.view setFrame: screenRect];
        [skView presentScene:scene];
        
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
//    skView.showsFPS = YES;
//    skView.showsNodeCount = YES;
 //   Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
//    GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
//    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
 //   [skView presentScene:scene];
//    self.rtcmixManager = [RTcmixPlayer sharedManager];
//    self.rtcmixManager.delegate = self;
//initiate balls array
//    balls = [[NSMutableArray alloc] init];
    //set up three initial arrays (should be for loop)
//    NSMutableArray *bob = [[NSMutableArray alloc] init];
//    NSMutableArray *fred = [[NSMutableArray alloc] init];
//    NSMutableArray *george = [[NSMutableArray alloc] init];
//    [balls addObject: bob];
//    [balls addObject: fred];
//    [balls addObject: george];
    //     balls = [NSMutableArray array],[NSMutableArray array],[NSMutableArray array];
//    [self.rtcmixManager startAudio];
}



- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

//maxMessage stuff, copied from Damon
/*
#pragma mark - Delegate Methods (interaction from interface)

- (IBAction)goMaxBang:(UISwitch *)sender {
    if (self.maxBangSwitch.on)
    {
        [self.rtcmixManager parseScoreWithNSString:@"MAXBANG(0)"];
    }
}

- (IBAction)goMaxMessage:(UISwitch *)sender {
    if (self.maxMessageSwitch.on)
    {
        [self.rtcmixManager parseScoreWithNSString:@"MAXMESSAGE(0, \"Go Max Message!\")"];
    }
}

- (IBAction)goMaxError:(UIButton *)sender {
    [self.rtcmixManager parseScoreWithNSString:@"print_on(2) print(\"This is a print statement.\") foo = bar"];
}
*/

- (NSString *) convertArray:(NSArray *) ballray {
    NSString *bob;
    NSString *tom = [NSString stringWithFormat:@"%@%@%@", @"slot = ", (NSString *)[ballray objectAtIndex: 0], @"\n"];
    NSString *ron = [NSString stringWithFormat:@"%@%@", @"voices = ", (NSString *)[ballray objectAtIndex: 1]];
    NSString *fred = [NSString stringWithFormat:@"%@%@", @"alive = ", (NSString *)[ballray objectAtIndex: 2]];
    NSString *george = [NSString stringWithFormat:@"%@%@", @"bamp = ", (NSString *)[ballray objectAtIndex: 3]];
    bob = [NSString stringWithFormat:@"%@%@\n%@\n%@\n", tom, ron, fred, george];
    return bob;
}

/*
#pragma mark - Delegate Methods (the actual delegate methods)

- (void)maxBang {

}

- (void)maxMessage:(NSArray *)message {
    //stay the same;
    //note, currently the first value of message is unused if it is a change operation. Ball identifier remains at 1
    if([[message objectAtIndex: 0] floatValue] == 0.0){
        NSLog(@"here");;
        int k = [[message objectAtIndex: 1] floatValue];
        NSArray *steven = [balls objectAtIndex: k];
        NSString *values = [self convertArray: steven];
        NSString *scorePath = [[NSBundle mainBundle] pathForResource:@"eth" ofType:@"sco"];
        [self.rtcmixManager parseScoreWithNSString:values];
        [self.rtcmixManager parseScoreWithFilePath:scorePath];
    }
    //change
    else{
        //creates new array for new values
        //for future, less memory leak would likely be replacement of individual elements
        NSMutableArray *bob = [[NSMutableArray alloc] init];
//        bob = ([message objectAtIndex: 2], [message objectAtIndex: 3], [message objectAtIndex: 4]);
        NSString *tom1 = [[message objectAtIndex: 1] stringValue];
        NSString *tom2 = [[message objectAtIndex: 2] stringValue];
        NSString *tom3 = [[message objectAtIndex: 3] stringValue];
        NSString *tom4 = [[message objectAtIndex: 4] stringValue];
        [bob addObject: [[message objectAtIndex: 1] stringValue]];
        [bob addObject: [[message objectAtIndex: 2] stringValue]];
        [bob addObject: [[message objectAtIndex: 3] stringValue]];
        [bob addObject: [[message objectAtIndex: 4] stringValue]];
        int w = [[message objectAtIndex: 1] floatValue];
        [balls replaceObjectAtIndex: w /[[message objectAtIndex: 1] floatValue]/withObject: bob];
    }
}

- (void)drone:(NSArray *)message{
    
}

- (void)maxError:(NSString *)error {
    NSLog(@"maxError: %@", error);
}
 */

@end
