//
//  GameScene.m
//  MusicGame
//
//  Created by ethan on 4/11/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//




#import "GameScene.h"
#import "SKShapeNode+BallNode.h"
#import "SKShapeNode+BubbleNode.h"
@import CoreGraphics;
@implementation GameScene

//Category names for collisions
static NSString* ballCategoryName = @"ball";
static NSString* bubCategoryName = @"bub";
static NSString* buttonCategoryName = @"button";
static NSString* buttonCategoryName2 = @"button2";
static NSString* buttonCategoryName3 = @"blockButton";
static NSString* buttonCategoryName4 = @"blockChangeButton";
static NSString* blockCategoryName = @"block";
static NSString* blockCategoryName5 = @"block5";
static NSString* blockCategoryName6 = @"block6";
static NSString* blockCategoryName7 = @"block7";
static NSString* buttonCategoryNameStart = @"start";
static NSString* buttonCategoryNameTutorial = @"tutorial";
static NSString* buttonCategoryNameNext = @"next";
static NSString* buttonCategoryNamePause = @"pause";
SKSpriteNode *ballPrime;


//collision categories
static const uint32_t BallCategory1  = 0x1 << 0;
static const uint32_t BallCategory2  = 0x1 << 2;
static const uint32_t BallCategory3  = 0x1 << 3;
static const uint32_t BallCategory4  = 0x1 << 4;
static const uint32_t BallCategory5  = 0x1 << 5;
static const uint32_t BlockCategory  = 0x1 << 6;
static const uint32_t BlockCategory2  = 0x1 << 7;
static const uint32_t BlockCategory3  = 0x1 << 8;
static const uint32_t BlockCategory4  = 0x1 << 9;
static const uint32_t BlockCategory5  = 0x1 << 10;
static const uint32_t BlockCategory6  = 0x1 << 11;
static const uint32_t BlockCategory7  = 0x1 << 12;
static const uint32_t ObstacleCategory  = 0x1 << 13;
static const uint32_t BubCategory  = 0x1 << 14;
static const uint32_t bgCategory  = 0x1 << 15;
static const uint32_t goalCategory  = 0x1 << 16;


//volume divider
static int at = 54;

//point variables
CGPoint player;
CGPoint negaPlayer;
CGPoint buttonPoint;
CGPoint buttonPoint2;
CGPoint buttonPoint3;
CGPoint blockButtonPoint;
CGPoint startButtonPoint;
CGPoint tutorialButtonPoint;
CGPoint pauseButtonPoint;

//Constant button nodes
SKShapeNode *goal;
SKShapeNode *startButton;
SKShapeNode *tutorialButton;
SKShapeNode *blockButton;
SKShapeNode *pauseButton;
SKLabelNode *typeLabel;
SKLabelNode *blockLabel;

//buildTYpe buttons, for prototyping
SKShapeNode *startButton2;
SKShapeNode *startButton3;

//velocity and size
int velocity = 30;
int rSize = 50;

//
int ballType;
int blockType;
bool goalActive;
bool blockActive;
bool tutActive;
bool tutorialMode;
bool gameActive;
bool clippingOK;
double bgr;
double bgg;
double bgb;
double touchID;
UITouch *buttonTouch;
int tutorialLevel;
int testInt = 0;
double buttonSize;

//type variables for gameplay configuration
int maxTypes = 5;
int minTypes = 1;
int maxBlockTypes = 7;
int minBlockTypes = 1;

//Labels associated with tutorial
SKLabelNode *tutLabel;
SKLabelNode *tutLabel2;
SKLabelNode *tutLabel3;
NSArray *tutMessage;
NSArray *tutMessage2;
NSArray *tutMessage3;
int tutNum;

//Ball variable storage
NSMutableArray *balls;
NSMutableArray *ballStorage;



//Color variables
SKColor *blockColor;
SKColor *blockPressed;
SKColor *pauseUn;
SKColor *pausePressed;

SKColor *rb;
SKColor *gb;
SKColor *yb;
SKColor *ob;
SKColor *pb;
SKColor *bb;

//ballNums
int ballNum1;
int ballNum2;
int ballNum3;
int ballNum4;
int ballNum5;
int ballNum;

//By default, maximum of 15
int maxBalls = 15;
int maxBalls1 = 15;
int maxBalls2 = 15;
int maxBalls3 = 15;
int maxBalls4 = 15;
int maxBalls5 = 15;

//Bools for buttons
bool ballButtonBool;
bool blockButtonBool;
bool pauseButtonBool;
bool bchangebuttonBool;
bool restartbuttonBool;

//put in start functions
bool shoot = true;

//for tutorial vict conditions
bool vic1;
bool vic2;
bool vic3;
bool vic4;
bool vic5;
bool vic6;
bool vic7;
bool vic8;

int ccounter;

//vict conditions
int vict1;
int vict2;
int vict3;


//Standard buildType
int buildType = 2;



//Vector math for ball launching
static inline CGPoint rwSub(CGPoint a, CGPoint b) {
    return CGPointMake(a.x - b.x, a.y - b.y);
}

static inline float rwLength(CGPoint a) {
    return sqrtf(a.x * a.x + a.y * a.y);
}

// Makes a vector have a length of 1
static inline CGPoint rwNormalize(CGPoint a) {
    float length = rwLength(a);
    return CGPointMake(a.x / length, a.y / length);
}
//first value is place in the array, also known as slot, which is identical to the number of the ball
//changed to make use of convertArray rather than being a seperate subject
-(void) changeVals: (NSArray *) vals{
    NSString *bob;
    bob = [self convertArray: vals];
    [self.rtcmixManager parseScoreWithNSString:bob];
    NSString *scorePath = [[NSBundle mainBundle] pathForResource:@"change" ofType:@"sco"];
    [self.rtcmixManager parseScoreWithFilePath:scorePath];
}

//currently assumes 6 elements, for storing balls and associated RTcmix values
-(void) addVals: (NSArray *) vals{
    NSMutableArray *bob = [[NSMutableArray alloc] init];
    if([vals count] != 6){
        [NSException raise:@"Invalid array size" format:@"size of %lu is invalid", (unsigned long)[vals count]];
    }
    NSString *tom1 = [vals objectAtIndex: 0];
    NSString *tom2 = [vals objectAtIndex: 1];
    NSString *tom3 = [vals objectAtIndex: 2];
    NSString *tom4 = [vals objectAtIndex: 3];
    NSString *tom5 = [vals objectAtIndex: 4];
    //was 4 for quite awhile without much perceived lack of functioning
    NSString *tom6 = [vals objectAtIndex: 5];
    [bob addObject: tom1];
    [bob addObject: tom2];
    [bob addObject: tom3];
    [bob addObject: tom4];
    [bob addObject: tom5];
    [bob addObject: tom6];
    int w = [[vals objectAtIndex: 0] floatValue];
    [balls replaceObjectAtIndex: w withObject: bob];
}

//updating the RTcmix values of balls according to the ball
-(void) updateBall: (BallNode *) ball{
    NSArray *currencies = @[[NSString stringWithFormat:@"%d", ball.ident], [NSString stringWithFormat:@"%d", ball.alive], [NSString stringWithFormat:@"%d", ball.voices], [NSString stringWithFormat:@"%f", ball.volume], [NSString stringWithFormat:@"%d", ball.health], [NSString stringWithFormat:@"%@", ball]];
    [self addVals: currencies];
    [ballStorage replaceObjectAtIndex: ball.ident withObject: ball];
}

//currently assumes 6 elements in stated order
- (NSString *) convertArray:(NSArray *) ballray {
    NSString *bob;
    if([ballray count] != 6){
        [NSException raise:@"Invalid array size" format:@"size of %lu is invalid", (unsigned long)[ballray count]];
    }
    NSString *tom = [NSString stringWithFormat:@"%@%@", @"slot = ", (NSString *)[ballray objectAtIndex: 0]];
    NSString *fred = [NSString stringWithFormat:@"%@%@", @"alive = ", (NSString *)[ballray objectAtIndex: 1]];
    NSString *ron = [NSString stringWithFormat:@"%@%@", @"voices = ", (NSString *)[ballray objectAtIndex: 2]];
    NSString *george = [NSString stringWithFormat:@"%@%@", @"volumechese = ", (NSString *)[ballray objectAtIndex: 3]];
    NSString *steve = [NSString stringWithFormat:@"%@%@", @"health = ", (NSString *)[ballray objectAtIndex: 4]];
    NSString *pointer = [NSString stringWithFormat:@"%@%@", @"pointer = ", (NSString *)[ballray objectAtIndex: 5]];
    bob = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n", tom, fred, ron, george, steve, pointer];
    return bob;
}

//Add one voice
-(void) addVoice: (BallNode *) ball{
    ball.voices = ball.voices + 1;
    [self updateBall: ball];
}

//Sets all tutorial victory conditions to 0
-(void) setVic{
    vic1 = false;
    vic2 = false;
    vic3 = false;
    vic4 = false;
    vic5 = false;
    vic6 = false;
    vic7 = false;
    vic8 = false;
}

//Changes tutorial level
-(void) tutorialLevelChange{
    //Refreshes everything to default values
    [self restart];
    [self refresh];
    [self createMessages];
    ballButtonBool = false;
    blockButtonBool = false;
    pauseButtonBool = false;
    bchangebuttonBool = false;
    restartbuttonBool = true;
    shoot = true;
    ccounter = 0;
    //Points for tutorial text
    CGPoint downMid;
    CGPoint upMid;
    CGPoint mid;
    int temp;
    [self setVic];
    //Switches based on level number
    //Any unchanged values go with default
    switch (tutorialLevel){
        //Contact with block
        case 0:
            //test level code

            
            
            
            //actual level
            
            NSLog(@"tutorial Active");
            [self tutorialChangeBall: 1 max: 1 min: 1];
            [self tutorialChangeBlock: 1 max: 1 min: 1];
            [self changeBallNums: 1 ii: 0 iii: 0 iv: 0 v: 0];
            
            //create block
            blockType = 2;
            CGPoint midpoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
            [self createBlock: midpoint];
            blockType = 1;
            [self textify:@"=======Tap to shoot=======    Press the Blue Button to Return"];
            break;
            
        //Level 2
        case 1:
            [self tutorialChangeBall: 1 max: 1 min: 1];
            [self tutorialChangeBlock: 1 max: 1 min: 1];
            [self changeBallNums: 2 ii: 0 iii: 0 iv: 0 v: 0];
            [self textify:@"Balls can collide with each other to make sound too"];
            break;
        //Multiple balls
        case 2:
            [self tutorialChangeBall: 1 max: 2 min: 1];
            [self tutorialChangeBlock: 1 max: 1 min: 1];
            [self changeBallNums: 2 ii: 2 iii: 0 iv: 0 v: 0];
            ballButtonBool = true;
            [self textify:@"You can change the type of balls by pressing the button on the bottom right"];
            break;
        case 3:
            [self tutorialChangeBall: 1 max: 4 min: 1];
            [self tutorialChangeBlock: 1 max: 1 min: 1];
            [self changeBallNums: 3 ii: 3 iii: 3 iv: 3 v: 0];
            ballButtonBool = true;
            [self textify:@"There are many types of balls with different sounds"];
            break;
        case 4:
            [self tutorialChangeBall: 1 max: 5 min: 1];
            [self tutorialChangeBlock: 1 max: 1 min: 1];
            [self changeBallNums: 3 ii: 3 iii: 3 iv: 3 v: 2];
            ballButtonBool = true;
            [self textify:@"Use ball 5 to delete balls"];
            break;
        case 5:
            [self createBlockSquare: CGPointMake(self.frame.size.width/2, self.frame.size.height - rSize*3) x: 4 y: 8 type: 1 up: false down: true left: true right: true];
            [self tutorialChangeBall: 1 max: 4 min: 1];
            [self tutorialChangeBlock: 1 max: 1 min: 1];
            [self changeBallNums: 3 ii: 3 iii: 3 iv: 3 v: 0];
            ballButtonBool = true;
            [self textify:@"Use blocks to increase collisions"];
            break;
        case 6:
            [self createBlockSquare: CGPointMake(self.frame.size.width/2, self.frame.size.height/2) x: 5 y: 7 type: 1 up: true down: true left: true right: true];
            downMid = CGPointMake(self.frame.size.width/2, self.frame.size.height/2-rSize*3/2);
            [self shootBall: [self makeBall: downMid] at: player from: downMid];
            upMid = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+rSize*3/2);
            [self shootBall: [self makeBall: upMid] at: player from: upMid];
            [self tutorialChangeBall: 1 max: 4 min: 1];
            [self tutorialChangeBlock: 1 max: 1 min: 1];
            [self changeBallNums: 3 ii: 3 iii: 3 iv: 3 v: 0];
            shoot = false;
            blockButtonBool = true;
            [self textify:@"Toggle the block button on the left to place blocks"];
            break;
        case 7:
            [self createBlockSquare: CGPointMake(self.frame.size.width/2, self.frame.size.height/2) x: 5 y: 7 type: 1 up: true down: true left: true right: true];
            [self createBlockSquare: CGPointMake(self.frame.size.width/2, self.frame.size.height/2) x: 3 y: 1 type: 1 up: true down: false left: false right: false];
            downMid = CGPointMake(self.frame.size.width/2, self.frame.size.height/2-rSize*3/2);
            [self shootBall: [self makeBall: downMid] at: player from: downMid];
            upMid = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+rSize*3/2);
            temp = ballType;
            ballType = 2;
            [self shootBall: [self makeBall: upMid] at: player from: upMid];
            ballType = temp;
            shoot = false;
            blockButtonBool = true;
            [self textify:@"You can delete blocks by tapping them in block mode"];
            break;
        case 8:
            temp = ballType;
            downMid = CGPointMake(self.frame.size.width/2, self.frame.size.height/2-rSize*3/2);
            [self shootBall: [self makeBall: downMid] at: player from: downMid];
            ballType = 2;
            upMid = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+rSize*3/2);
            [self shootBall: [self makeBall: upMid] at: mid from: upMid];
            ballType = 4;
            mid = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+rSize-3);
            [self shootBall: [self makeBall: mid] at: downMid from: mid];
            ballType = temp;
            shoot = false;
            blockButtonBool = true;
            [self tutorialChangeBlock: 1 max: 4 min: 1];
            bchangebuttonBool = true;
            [self textify:@"Change the block type by pressing the button next to the block button"];
            break;
        case 9:
            [self createBlockSquare: CGPointMake(rSize*3, rSize*2) x: 3 y: 4 type: 1 up: false down: false left: true right: false];
            temp = blockType;
            blockType = 2;
            [self createBlock: CGPointMake(rSize, rSize*4)];
            blockType = temp;
            downMid = CGPointMake(rSize/2, rSize*2);
            [self shootBall: [self makeBall: downMid] at: player from: downMid];
            [self tutorialChangeBall: 1 max: 4 min: 1];
            [self tutorialChangeBlock: 1 max: 4 min: 1];
            [self changeBallNums: 3 ii: 3 iii: 3 iv: 3 v: 0];
            ballButtonBool = true;
            blockButtonBool = true;
            bchangebuttonBool = true;
            [self textify:@"Use combinations of blocks and balls to make various sounds"];
            break;
        case 10:
            temp = blockType;
            blockType = 5;
            [self createBlock: CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
            blockType = temp;
            [self tutorialChangeBall: 3 max: 4 min: 3];
            [self changeBallNums: 0 ii: 0 iii: 5 iv: 5 v: 0];
            [self textify:@"Blocks 5, 6, and 7 are special, and have permanent changes"];
            ballButtonBool = true;
            break;
        case 11:
            NSLog(@"tutorial complete");
            tutorialLevel = 200;
            [self tutorialChangeBall: 1 max: 5 min: 1];
            [self changeBallNums: 15 ii: 15 iii: 15 iv: 15 v: 15];
            [self tutorialChangeBlock: 1 max: 7 min: 1];
            ballButtonBool = true;
            blockButtonBool = true;
            pauseButtonBool = true;
            bchangebuttonBool = true;
            restartbuttonBool = true;
            [self restart];
            [self newGame];
            break;
    }
}

//change type of balls, if it exceeds, loops back to 1
-(void) changeBall{
    if(ballType >= maxTypes){
        ballType = minTypes;
    } else{
        ballType++;
    }
    typeLabel.text = [NSString stringWithFormat:@"%d", ballType];
}
//Helper function for tutorial
-(void) changeBallNums: (int) i ii: (int) ii iii: (int) iii iv: (int) iv v: (int) v{
    maxBalls1 = i;
    maxBalls2 = ii;
    maxBalls3 = iii;
    maxBalls4 = iv;
    maxBalls5 = v;
}
//Changes the global ball properties
-(void) tutorialChangeBall: (int) start max: (int) max min: (int) min{
    ballType = start;
    maxTypes = max;
    minTypes = min;
    typeLabel.text = [NSString stringWithFormat:@"%d", ballType];
}
//Changes the global block properties
-(void) tutorialChangeBlock: (int) start max: (int) max min: (int) min{
    blockType = start;
    maxBlockTypes = max;
    minBlockTypes = min;
}

//change type of blocks
-(void) changeBlock{
    if(blockType >= maxBlockTypes){
        blockType = 1;
    } else{
        blockType++;
    }
    blockLabel.text = [NSString stringWithFormat:@"%d", blockType];
}

-(void) createEcho: (CGPoint) pos{
    SKShapeNode *echo = [[SKShapeNode alloc] init];
    CGMutablePathRef myPath = CGPathCreateMutable();
    CGPathAddArc(myPath, NULL, 0,0, 30, 0, M_PI*2, YES);
    echo.path = myPath;
    echo.lineWidth = 1.0;
    echo.position = pos;
    echo.strokeColor = [SKColor whiteColor];
    [self addChild: echo];
    SKAction *fade = [SKAction fadeOutWithDuration: .5];
    SKAction *delete = [SKAction runBlock:^{ [echo removeFromParent];}];
    SKAction *fadeLete = [SKAction sequence: @[fade, delete]];
    [echo runAction: [SKAction scaleBy:1.5 duration:.5]];
    [echo runAction: fadeLete];
}

-(void) createButton1{
    SKShapeNode *button = [[SKShapeNode alloc] init];
    button = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(buttonSize, buttonSize)];
    button.lineWidth = 1.0;
    button.position = buttonPoint;
    button.name = buttonCategoryName;
    button.fillColor = rb;// [SKColor redColor];
    [self addChild: button];
}
-(void) createButton2{
    SKShapeNode *button = [[SKShapeNode alloc] init];
    button = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(buttonSize, buttonSize)];
    button.lineWidth = 1.0;
    button.position = buttonPoint2;
    button.name = buttonCategoryName2;
    button.fillColor = bb;//[SKColor blueColor];
    [self addChild: button];
}
-(void) createPauseButton{
    SKShapeNode *button = [[SKShapeNode alloc] init];
    button = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(buttonSize, buttonSize)];
    button.lineWidth = 1.0;
    button.position = pauseButtonPoint;
    button.name = buttonCategoryNamePause;
    button.fillColor = pauseUn;
    
    SKShapeNode *left = [[SKShapeNode alloc] init];
    left = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(buttonSize/4, buttonSize-buttonSize/3)];
    left.position = CGPointMake(pauseButtonPoint.x - buttonSize/4, pauseButtonPoint.y);
    left.fillColor = [SKColor yellowColor];
    left.name = buttonCategoryNamePause;
    
    SKShapeNode *right = [[SKShapeNode alloc] init];
    right = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(buttonSize/4, buttonSize-buttonSize/3)];
    right.position = CGPointMake(pauseButtonPoint.x + buttonSize/4, pauseButtonPoint.y);
    right.fillColor = [SKColor yellowColor];
    right.name = buttonCategoryNamePause;

    
    pauseButton = button;
    
    [self addChild: button];
    [self addChild: left];
    [self addChild: right];
}
-(void) createBlockButton{
    SKShapeNode *button = [[SKShapeNode alloc] init];
    button = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(buttonSize, buttonSize)];
    button.lineWidth = 1.0;
    button.position = blockButtonPoint;
    button.name = buttonCategoryName3;
    button.fillColor = yb;
    blockButton = button;
    [self addChild: blockButton];
}
-(void) createTypeButton{
    SKShapeNode *button = [[SKShapeNode alloc] init];
    button = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(buttonSize, buttonSize)];
    button.lineWidth = 1.0;
    button.position = CGPointMake(buttonSize*3/2, buttonSize/2);
    button.name = buttonCategoryName4;
    button.fillColor = [SKColor orangeColor];
    [self addChild: button];
}
-(void) createBarrier{
    SKShapeNode *button = [[SKShapeNode alloc] init];
    button = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(self.frame.size.width, buttonSize)];
    [self addChild: button];
    button.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize: CGSizeMake(self.frame.size.width, buttonSize)];
    button.physicsBody.collisionBitMask = BallCategory1 | BallCategory2|BallCategory3|BallCategory4|BallCategory5;
    button.physicsBody.categoryBitMask = ObstacleCategory;
    button.physicsBody.dynamic = NO;
    button.lineWidth = 1.0;
    button.position = buttonPoint3;
    button.fillColor = [SKColor grayColor];
//    [self addChild: button];
}
-(void) createButton{
    [self createBarrier];
    [self createButton1];
    [self createButton2];
    [self createBlockButton];
    [self createTypeButton];
    [self createPauseButton];

}
-(void) createStartButton{
    SKShapeNode *button = [[SKShapeNode alloc] init];
    button = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(buttonSize*3, buttonSize)];
    button.lineWidth = 1.0;
    button.position = startButtonPoint;
    button.name = buttonCategoryNameStart;
    button.fillColor = yb;//[SKColor yellowColor];
    startButton = button;
    [self addChild: startButton];
}

//two fellowing methods only for buildTypes
-(void) createStartButton2{
    SKShapeNode *button = [[SKShapeNode alloc] init];
    button = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(buttonSize, buttonSize)];
    button.lineWidth = 1.0;
    button.position = CGPointMake(buttonSize*3, self.frame.size.height-buttonSize);
    button.name = @"2";
    button.fillColor = [SKColor blackColor];
    startButton2 = button;
    [self addChild: startButton2];
}
-(void) createStartButton3{
    SKShapeNode *button = [[SKShapeNode alloc] init];
    button = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(buttonSize, buttonSize)];
    button.lineWidth = 1.0;
    button.position = CGPointMake(buttonSize, self.frame.size.height-buttonSize);
    button.name = @"3";
    button.fillColor = [SKColor whiteColor];
    startButton3 = button;
    [self addChild: startButton3];
}


-(void) createTutorialButton{
    SKShapeNode *button = [[SKShapeNode alloc] init];
    button = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(buttonSize*3, buttonSize)];
    button.lineWidth = 1.0;
    button.position = tutorialButtonPoint;
    button.name = buttonCategoryNameTutorial;
    button.fillColor = yb;//[SKColor yellowColor];
    tutorialButton = button;
    [self addChild: tutorialButton];
}
-(void) createNextButton{
    SKShapeNode *button = [[SKShapeNode alloc] init];
    button = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(buttonSize*3/2, buttonSize/2)];
    button.lineWidth = 1.0;
    button.position = CGPointMake(self.frame.size.width/2+100, self.frame.size.height/2-100);
    button.name = buttonCategoryNameNext;
    button.fillColor = [SKColor blueColor];
    [self addChild: button];
}
-(int) findSpace: (NSString *) s p: (int) p{
    int d = p;
    for(int i = p; i < s.length - 1; i++){
        //last character based on i
        NSLog([s substringWithRange: NSMakeRange(i, 1)]);
        if([[s substringWithRange: NSMakeRange(i, 1)]  isEqual: @" "]){
            d = i;
            NSLog(@"found");
            return d;
            break;
        }
    }
    return d;
}
-(void) textify: (NSString*) message{
    long p = message.length;
    if(p<30){
        tutLabel.text = message;
    }else if (p < 60){
        int third = (int) p/2;
        int d = [self findSpace: message p: third ];
        NSString *m1 = [message substringWithRange: NSMakeRange(0, d)];
        
        
        NSString *m2 = [message substringWithRange: NSMakeRange(d, message.length-d)];
        
        tutLabel.text = m1;
        tutLabel2.text = m2;
    } else{
        int third = (int) p/3;
        int d = [self findSpace: message p: third ];
        NSString *m1 = [message substringWithRange: NSMakeRange(0, d)];
        int e = [self findSpace: message p: d + third];
        NSString *m2 = [message substringWithRange: NSMakeRange(d, e-d)];
        NSString *m3 = [message substringWithRange: NSMakeRange(e, message.length-e)];
        tutLabel.text = m1;
        tutLabel2.text = m2;
        tutLabel3.text = m3;
    }
}

-(void) createMessages{
    tutLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    tutLabel2 = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    tutLabel3 = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    tutLabel.fontSize = 20;
    tutLabel.fontColor = [SKColor blackColor];
    //tutLabel.position = startButtonPoint;
    tutLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - 60);
    
    tutLabel2.fontSize = 20;
    tutLabel2.fontColor = [SKColor blackColor];
    //tutLabel2.position = tutorialButtonPoint;
    tutLabel2.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - 120);
    
    //3
    tutLabel3.fontSize = 20;
    tutLabel3.fontColor = [SKColor blackColor];
    //tutLabel3.position = CGPointMake(CGRectGetMidX(self.frame),
    //                                 CGRectGetMidY(self.frame)-60);
    
    tutLabel3.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - 180);
    
    [self addChild:tutLabel];
    [self addChild:tutLabel2];
    [self addChild:tutLabel3];
}
-(void) createMenuButtons{

    tutLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    tutLabel2 = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    tutLabel3 = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    tutNum = 0;
    tutLabel.text = [tutMessage objectAtIndex: tutNum];
    tutLabel.fontSize = 20;
    tutLabel.fontColor = [SKColor blackColor];
    tutLabel.position = startButtonPoint;
    
    tutLabel2.text = [tutMessage2 objectAtIndex: tutNum];
    tutLabel2.fontSize = 20;
    tutLabel2.fontColor = [SKColor blackColor];
    tutLabel2.position = tutorialButtonPoint;
    
    //3
    tutLabel3.text = [tutMessage3 objectAtIndex: tutNum];
    tutLabel3.fontSize = 20;
    tutLabel3.fontColor = [SKColor blackColor];
    tutLabel3.position = CGPointMake(CGRectGetMidX(self.frame),
                                     CGRectGetMidY(self.frame)-60);
    [self addChild:tutLabel];
    [self addChild:tutLabel2];
    [self addChild:tutLabel3];
    [self createStartButton];
    [self createTutorialButton];
    
}
-(void) deleteMenuButtons{
    [startButton removeFromParent];
    [tutorialButton removeFromParent];
    if(!tutActive){
        [tutLabel removeFromParent];
        [tutLabel2 removeFromParent];
    }
    
    //buildType stuff
        [startButton2 removeFromParent];
        [startButton3 removeFromParent];
}
-(void) runTutorial{
    tutNum++;
    tutLabel.text = [tutMessage objectAtIndex: tutNum];
    tutLabel2.text = [tutMessage2 objectAtIndex: tutNum];
    tutLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                    CGRectGetMidY(self.frame));
    tutLabel2.position = CGPointMake(CGRectGetMidX(self.frame),
                                     CGRectGetMidY(self.frame)-30);
    tutActive = true;
    [self deleteMenuButtons];
    [self createNextButton];
}
-(void) runTutorialLevels{
    tutorialLevel = 0;
    tutorialMode = true;
    [self deleteMenuButtons];
    [self createMessages];
    gameActive = true;
    [self tutorialLevelChange];
}

-(void) createObstacles{
    CGSize rect1size = CGSizeMake(self.frame.size.width/8, self.frame.size.height/2);
    SKShapeNode *rect1 = [SKShapeNode shapeNodeWithRectOfSize:rect1size];
    SKShapeNode *rect2 = [SKShapeNode shapeNodeWithRectOfSize:rect1size];
    rect1.position = CGPointMake(self.frame.size.width/4+30, self.frame.size.height/4+70);
    rect2.position = CGPointMake(self.frame.size.width*3/4, self.frame.size.height/4+70);
    rect1.fillColor = [SKColor blueColor];
    rect2.fillColor = [SKColor blueColor];
    rect1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rect1size];
    rect2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rect1size];
    rect1.physicsBody.categoryBitMask = ObstacleCategory;
    rect2.physicsBody.categoryBitMask = ObstacleCategory;
//            ball.physicsBody.contactTestBitMask = BallCategory1|BallCategory2|BallCategory3|BallCategory4|BallCategory5;
    rect1.physicsBody.collisionBitMask = BallCategory1 | BallCategory2|BallCategory3|BallCategory4|BallCategory5;
    rect2.physicsBody.collisionBitMask = BallCategory1 | BallCategory2|BallCategory3|BallCategory4|BallCategory5;
    //rect1.physicsBody.mass = 900000000;
    //rect2.physicsBody.mass = 9000;
    rect1.physicsBody.dynamic = NO;
    rect2.physicsBody.dynamic = NO;
    [self addChild: rect1];
    [self addChild: rect2];
}
-(void) createTutorialObstacles: (int) level{
    
}

-(void) createBlockSquare: (CGPoint) pos x: (int) x y: (int) y type: (int) t up: (BOOL) u down: (BOOL) d left: (BOOL) l right: (BOOL) r{
    int temp = blockType;
    blockType = t;
    //int topy = y*rSize/2;
    //int firstx = pos.x - x*rSize/2;
    float newx;
    for(int i = -x/2; i <= x/2; i++){
        newx = pos.x+i*rSize;
        if(u){
            [self createBlock: CGPointMake(newx, pos.y+y/2*rSize)];
        }
        if(d){
            [self createBlock: CGPointMake(newx, pos.y-y/2*rSize)];
        }
    }
    //int firsty = pos.y - y*rSize/2 + rSize;
    //int leftx = pos.x+x/2*rSize;
    int newy;
    for(int i = -y/2+1; i <= y/2-1; i++){
        newy = pos.y+i*rSize;
        if(r){
            [self createBlock: CGPointMake(pos.x+x/2*rSize, newy)];
        }
        if(l){
            [self createBlock: CGPointMake(pos.x-x/2*rSize, newy)];
        }
    }

    blockType = temp;
}
-(void) createBlock: (CGPoint) pos{
    if (blockType>4){
        [self createDroneBlock:pos t: 4];
    } else{
    //SHOULD CHANGE FROM DEFAULT BASED ON DEVICE
    CGSize rect1size = CGSizeMake(rSize, rSize);
    SKShapeNode *rect1 = [SKShapeNode shapeNodeWithRectOfSize:rect1size];
    if(pos.y<buttonSize+40){
        pos.y = buttonSize+40;
    }
    rect1.position = pos;
    rect1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rect1size];
    
    switch(blockType){
        case 1:
            rect1.fillColor = [SKColor yellowColor];
            rect1.fillColor = yb;
            rect1.physicsBody.categoryBitMask = BlockCategory;
            rect1.physicsBody.collisionBitMask = BallCategory1 | BallCategory2|BallCategory3|BallCategory4|BallCategory5;
            rect1.physicsBody.contactTestBitMask = BallCategory1 | BallCategory5;
            break;
        case 2:
            rect1.fillColor = [SKColor redColor];
            rect1.fillColor = rb;
            rect1.physicsBody.categoryBitMask = BlockCategory2;
            rect1.physicsBody.collisionBitMask = BallCategory1 | BallCategory2|BallCategory3|BallCategory4|BallCategory5;
            rect1.physicsBody.contactTestBitMask = BallCategory1 | BallCategory5;
            break;
        case 3:
            rect1.fillColor = [SKColor blueColor];
            rect1.fillColor = pb;
            rect1.physicsBody.categoryBitMask = BlockCategory3;
            rect1.physicsBody.collisionBitMask = BallCategory1 | BallCategory2|BallCategory3|BallCategory4|BallCategory5;
            rect1.physicsBody.contactTestBitMask = BallCategory1 | BallCategory5;
            break;
        case 4:
            rect1.fillColor = [SKColor greenColor];
            rect1.fillColor = gb;
            rect1.physicsBody.categoryBitMask = BlockCategory4;
            rect1.physicsBody.collisionBitMask = BallCategory1 | BallCategory2|BallCategory3|BallCategory4|BallCategory5;
            rect1.physicsBody.contactTestBitMask = BallCategory1 | BallCategory5;
            break;
    }
    rect1.physicsBody.dynamic = NO;
    rect1.name = blockCategoryName;
    [self addChild: rect1];
    }
}
-(void) createDroneBlock: (CGPoint) pos t: (int) t{
    //-1 for ball5
    if(ballNum < maxBalls-1){
    int temptype = ballType;
    ballType = blockType+1;
    [self makeBall: pos];
    ballType = temptype;
    }
}
-(void) createGoal{
    goal = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(20, 20)];
    goal.position = CGPointMake(self.frame.size.width/2 - 100, 45);
    goal.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(20, 20)];
    goal.physicsBody.categoryBitMask = goalCategory;
    goal.physicsBody.contactTestBitMask = BallCategory1 | BallCategory2|BallCategory3|BallCategory4|BallCategory5;
    goal.fillColor = [SKColor greenColor];
    goal.physicsBody.dynamic = NO;
    [self addChild: goal];
}


-(void) nextLevel{
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
//    myLabel.text = @"Your Winner!";
    myLabel.fontSize = 20;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    
    [self addChild:myLabel];
}
//r, g, b must be between 0-2. Should be changned to allow for more randomness
-(void) changeColor: (BallNode *) ball r: (int) r g: (int) g b: (int) b{
    SKAction* change =[SKAction customActionWithDuration:3      actionBlock:^(SKNode *node, CGFloat elapsedTime) {
        double newr = ball.r;
        double newg = ball.g;
        double newb = ball.b;
        
        switch(r){
            case 0:
                newr = ball.r;
                break;
            case 1:
                if(ball.r < 1){
                    newr = ball.r + 5/1000.0f;
                }
                break;
            case 2:
                if(ball.r > .05){
                    newr = ball.r - 5/1000.0f;
                }
                break;
        }
        switch(g){
            case 0:
                newg = ball.g;
                break;
            case 1:
                if(ball.g < 1){
                    newg = ball.g + 5/1000.0f;
                    
                }
                break;
            case 2:
                if(ball.g > .05){
                    newg = ball.g - 5/1000.0f;
                    
                }
                break;
        }
        
        switch(b){
            case 0:
                newb = ball.b;
                break;
            case 1:
                if(ball.b < 1){
                    newb = ball.b + 5/1000.0f;
                }
                break;
            case 2:
                if(ball.b > .05){
                    newb = ball.b - 5/1000.0f;
                }
                break;
        }
        
        //note, this change is not linear, it is exponential or something, because full elapsed time rather than the difference is added
        ball.fillColor = [SKColor colorWithRed: newr green: newg blue: newb alpha: ball.a];
        ball.r = newr;
        ball.g = newg;
        ball.b = newb;
    }
    ];
    [ball runAction: change];
//    ball.fillColor = [SKColor colorWithRed: ball.r green: ball.g blue: ball.b alpha: ball.a];
    
}
-(void) changeColor{
    int r = arc4random() % 3;
    int g = arc4random() % 3;
    int b = arc4random() % 3;
    SKAction* change =[SKAction customActionWithDuration:3      actionBlock:^(SKNode *node, CGFloat elapsedTime) {
    double newr = bgr;
    double newg = bgg;
    double newb = bgb;

    switch(r){
        case 0:
            newr = bgr;
            break;
        case 1:
            if(bgr < 1){
                newr = bgr + 5/10000.0f;
            }
            break;
        case 2:
            if(bgr > .05){
                newr = bgr - 5/10000.0f;
            }
            break;
    }
    switch(g){
        case 0:
            newg = bgg;
            break;
        case 1:
            if(bgg < 1){
                newg = bgg + 5/10000.0f;
                
            }
            break;
        case 2:
            if(bgg > .05){
                newg = bgg - 5/10000.0f;
                
            }
            break;
    }
    
    switch(b){
        case 0:
            newb = bgb;
            break;
        case 1:
            if(bgb < 1){
                newb = bgb + 5/10000.0f;
            }
            break;
        case 2:
            if(bgb > .05){
                newb = bgb - 5/10000.0f;
            }
            break;
    }
    self.backgroundColor = [SKColor colorWithRed: newr green: newg blue: newb alpha: 100];
    bgr = newr;
    bgg = newg;
    bgb = newb;
    }
    ];
    [self runAction: change];
}
//takes damage, returns true if it deletes
-(BOOL) damage: (BallNode *) ball{
    ball.health = ball.health - 1;
    if(ball.health <= 0){
        [self fadeAway: ball];
        return true;
//        ballNum5 = ballNum5 - 1;
    }
    else{
        return false;
    }
}
-(void) fadeAway: (BallNode *) ball {
//    int w = ball.ident;
    SKAction *fade = [SKAction fadeAlphaTo:0 duration:0.5];
//probably should fix this
    SKAction *delete = [SKAction customActionWithDuration:.1      actionBlock:^(SKNode *node, CGFloat elapsedTime) {
//        int j = ball.ident;
            [self deleteBall: ball];
    }
        ];
    SKAction *fadeLete = [SKAction sequence: @[fade, delete]];
//    ball.physicsBody.collisionBitMask = 0;
//    ball.physicsBody.contactTestBitMask = 0;
    [ball runAction: fadeLete];

}
-(void) deleteBall: (BallNode *) ball{
//    int k = ball.ident;
    if(ball.alive==0){
        NSLog(@"found it");
    }
    ball.alive = 0;
    ballNum = ballNum - 1;
    [self updateBall: ball];
    [ball removeFromParent];
}
-(void) expire: (BallNode *) ball length: (int) i{
    //please note, this only works if only ball5 expires: this is a strictly temporary solution
    ballNum5 = ballNum5 - 1;
    SKAction *wait = [SKAction waitForDuration: i];
    SKAction *fad = [SKAction runBlock:^{
        [self fadeAway: ball];
    }];
    SKAction *exp = [SKAction sequence: @[wait, fad]];
    [ball runAction: exp];
}

//victory condition stuff, no longer important
-(void) incvict1{
    vict1 = vict1 + 1;
    if((vict1 > 3)&&(vict2 > 3)) {
        [self nextLevel];
        return;
    }
    SKAction *wait = [SKAction waitForDuration: 2];
    SKAction *dec = [SKAction runBlock:^{
        vict1 = vict1-1;
    }];
    SKAction *seq = [SKAction sequence: @[wait, dec]];
    [self runAction: seq];
}
-(void) incvict2{
    vict2 = vict2 + 1;
    if((vict1 > 3)&&(vict2 > 3)) {
        [self nextLevel];
        return;
    }
    SKAction *wait = [SKAction waitForDuration: 2];
    SKAction *dec = [SKAction runBlock:^{
        vict2 = vict2-1;
    }];
    SKAction *seq = [SKAction sequence: @[wait, dec]];
    [self runAction: seq];
}

//designed to wait for a split second so as not to stack too many sounds
-(void) waitClip: (double) w {
    
    clippingOK = false;
    SKAction *wait = [SKAction waitForDuration: w];
    SKAction *dec = [SKAction runBlock:^{
        clippingOK = true;
    }];
    SKAction *seq = [SKAction sequence: @[wait, dec]];
    [self runAction: seq];
     
}

//volume stuff
-(void) potUp: (BallNode *) ball amt: (double) inc t: (double) rate{
    SKAction *up = [SKAction customActionWithDuration:rate      actionBlock:^(SKNode *node, CGFloat elapsedTime) {
        double newV = ball.volume;
        newV = newV + inc/at;
            [self.rtcmixManager setInlet:ball.ident withValue: newV];
//        [self.rtcmixManager setInlet:1 withValue: newV];
//        testInt++;
//        NSLog(@"%i", testInt);
//        ball.volume = newV;
//        double w = ball.volume;
        
        ball.volume = newV;
    }
    ];
    
    [self runAction: up completion:^{
        [self updateBall: ball];
    }
     ];
 //   ball.volume = ball.volume + inc;


//    [self updateBall: ball];
    if(ball.volume>= 1){
        goalActive = true;
    }
    
}
//Begin main code
//initiate
-(void)didMoveToView:(SKView *)view {

    blockPressed = [SKColor colorWithRed: .8 green: .75 blue: 0 alpha: 100];
    pausePressed = [SKColor colorWithRed: .2 green: .75 blue: 0 alpha: 100];
    pauseUn = [SKColor colorWithRed: 0 green: .8 blue: .1 alpha:100 ];
    
    gb = [SKColor colorWithRed: .1 green: .76 blue: .1 alpha: 100];
    yb = [SKColor colorWithRed: .9 green: .95 blue: .07 alpha: 100];
    rb = [SKColor colorWithRed: .8 green: .16 blue: .07 alpha: 100];
    pb = [SKColor colorWithRed: .8 green: .26 blue: .7 alpha: 100];
    ob = [SKColor colorWithRed: .8 green: .36 blue: .07 alpha: 100];
    bb = [SKColor colorWithRed: .1 green: .1 blue: .9 alpha: 100];
    
    
    
    
    goalActive = false;
    blockActive = false;
    clippingOK = true;
    tutorialLevel = 100;
//    SKScene labScene =
//    [self.view presentScene: GameScene];
    //Code copied from breakout tutorial

    bgr = (float)arc4random()/(0x100000000);//.25;
    bgg = (float)arc4random()/(0x100000000);//.75;
    bgb = (float)arc4random()/(0x100000000);//.5;
    self.backgroundColor = [SKColor colorWithRed: bgr green: bgg blue: bgb alpha: 100];
    self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);

    
    //RTcmix setup
    self.rtcmixManager = [RTcmixPlayer sharedManager];
    self.rtcmixManager.delegate = self;
    [self.rtcmixManager startAudio];
    [self.rtcmixManager parseScoreWithResource:@"setup" ofType:@"sco"];
    buttonSize = self.frame.size.width/5;
    player = CGPointMake ( self.frame.size.width/2, self.frame.size.height);
    negaPlayer = CGPointMake ( self.frame.size.width/2, 0);
    buttonPoint = CGPointMake (self.frame.size.width-buttonSize/2, buttonSize/2);
    buttonPoint2 = CGPointMake (self.frame.size.width-buttonSize*3/2, buttonSize/2);
    blockButtonPoint = CGPointMake (buttonSize/2, buttonSize/2);
    buttonPoint3 = CGPointMake (self.frame.size.width/2, buttonSize/2);
    pauseButtonPoint = CGPointMake (buttonSize*5/2, buttonSize/2);
    startButtonPoint = CGPointMake (self.frame.size.width/2, self.frame.size.height/2);
    tutorialButtonPoint = CGPointMake (self.frame.size.width/2, self.frame.size.height/2-100);
    //gets initiated at 0

    //sets up balls array
    //initiate balls array
    tutMessage= [[NSArray alloc] init];
    tutMessage = @[@"Start", @"Welcome to Music Chambers",@"Create music by launching balls",@"Different kinds of balls", @"To change the type of ball,", @"There are 5 different types of balls,",  @"Try each one out", @"If you toggle the ", @"Use this to create better", @"The orange button changes", @"The green button pauses", @"If you need to restart,", @"Ready to go?"];
    tutMessage2 = @[@"Instructions", @"",@"",@"produce different kinds of", @"press the red button", @"all with different effects",  @"", @"yellow button, this will ", @"environments for your balls", @"The type of blocks", @"", @"just press the blue button", @""];
    tutMessage3 = @[@"", @"",@"",@"sounds when they hit each other", @"", @"",  @"", @"allow you to create blocks", @"to bounce around in", @"which also changes sound", @"", @"", @""];
    
    balls = [[NSMutableArray alloc] init];
    //set up three initial arrays (should be for loop)
    [self newGame];
    
    //sets up ballStorage
    ballStorage = [[NSMutableArray alloc] init];
    //set up three initial arrays (should be for loop)
    for(int i = 0; i < maxBalls; i++){
        [ballStorage addObject: [[BallNode alloc] init: i vol: 0 hp: 5]];
    }
    //all tutorial message stuff

    
}
-(void)didMoveToViewOld:(SKView *)view {
    
    blockPressed = [SKColor colorWithRed: .8 green: .75 blue: 0 alpha: 100];
    pausePressed = [SKColor colorWithRed: .2 green: .75 blue: 0 alpha: 100];
    pauseUn = [SKColor colorWithRed: 0 green: .8 blue: .1 alpha:100 ];
    
    gb = [SKColor colorWithRed: .1 green: .76 blue: .1 alpha: 100];
    yb = [SKColor colorWithRed: .9 green: .95 blue: .07 alpha: 100];
    rb = [SKColor colorWithRed: .8 green: .16 blue: .07 alpha: 100];
    pb = [SKColor colorWithRed: .8 green: .26 blue: .7 alpha: 100];
    ob = [SKColor colorWithRed: .8 green: .36 blue: .07 alpha: 100];
    
    
    
    
    goalActive = false;
    blockActive = false;
    clippingOK = true;
    //    SKScene labScene =
    //    [self.view presentScene: GameScene];
    //Code copied from breakout tutorial
    
    bgr = .25;
    bgg = .75;
    bgb = .5;
    self.backgroundColor = [SKColor colorWithRed: bgr green: bgg blue: bgb alpha: 100];
    self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
    // 1 Create a physics body that borders the screen
    SKPhysicsBody* borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    // 2 Set physicsBody of scene to borderBody
    self.physicsBody = borderBody;
    // 3 Set the friction of that physicsBody to 0
    self.physicsBody.friction = 0.0f;
    self.physicsBody.categoryBitMask = bgCategory;
    self.physicsWorld.contactDelegate = self;
    
    //RTcmix setup
    self.rtcmixManager = [RTcmixPlayer sharedManager];
    self.rtcmixManager.delegate = self;
    [self.rtcmixManager startAudio];
    [self.rtcmixManager parseScoreWithResource:@"setup" ofType:@"sco"];
    buttonSize = self.frame.size.width/5;
    player = CGPointMake ( self.frame.size.width/2, self.frame.size.height);
    negaPlayer = CGPointMake ( self.frame.size.width/2, 0);
    buttonPoint = CGPointMake (self.frame.size.width-buttonSize/2, buttonSize/2);
    buttonPoint2 = CGPointMake (self.frame.size.width-buttonSize*3/2, buttonSize/2);
    blockButtonPoint = CGPointMake (buttonSize/2, buttonSize/2);
    buttonPoint3 = CGPointMake (self.frame.size.width/2, buttonSize/2);
    pauseButtonPoint = CGPointMake (buttonSize*5/2, buttonSize/2);
    startButtonPoint = CGPointMake (self.frame.size.width/2, self.frame.size.height/2);
    tutorialButtonPoint = CGPointMake (self.frame.size.width/2, self.frame.size.height/2-100);
    //gets initiated at 0
    ballNum = 0;
    ballNum2 = 0;
    ballNum3 = 0;
    ballNum4 = 0;
    ballNum5 = 0;
    //ballType starts at 1
    ballType = 1;
    blockType = 1;
    //sets up balls array
    //initiate balls array
    balls = [[NSMutableArray alloc] init];
    //set up three initial arrays (should be for loop)
    for(int i = 0; i < maxBalls; i++){
        NSArray *vals = @[[NSString stringWithFormat:@"%d", i], @"0.0", @"0", @"0"];
        NSMutableArray *bob = [[NSMutableArray alloc] init];
        NSString *tom1 = [vals objectAtIndex: 0];
        NSString *tom2 = [vals objectAtIndex: 1];
        NSString *tom3 = [vals objectAtIndex: 2];
        NSString *tom4 = [vals objectAtIndex: 3];
        [bob addObject: tom1];
        [bob addObject: tom2];
        [bob addObject: tom3];
        [bob addObject: tom4];
        [balls addObject: bob];
        
    }
    
    //sets up ballStorage
    ballStorage = [[NSMutableArray alloc] init];
    //set up three initial arrays (should be for loop)
    for(int i = 0; i < maxBalls; i++){
        [ballStorage addObject: [[BallNode alloc] init: i vol: 0 hp: 5]];
    }
    //all tutorial message stuff
    tutMessage= [[NSArray alloc] init];
    tutMessage = @[@"Start", @"Welcome to Music Chambers",@"Create music by launching balls",@"Different kinds of balls", @"To change the type of ball,", @"There are 5 different types of balls,",  @"Try each one out", @"If you toggle the ", @"Use this to create better", @"The orange button changes", @"The green button pauses", @"If you need to restart,", @"Ready to go?"];
    tutMessage2 = @[@"Instructions", @"",@"",@"produce different kinds of", @"press the red button", @"all with different effects",  @"", @"yellow button, this will ", @"environments for your balls", @"The type of blocks", @"", @"just press the blue button", @""];
    tutMessage3 = @[@"", @"",@"",@"sounds when they hit each other", @"", @"",  @"", @"allow you to create blocks", @"to bounce around in", @"which also changes sound", @"", @"", @""];
    //create button
    typeLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    typeLabel.text = @"1";
    typeLabel.fontSize = 20;
    typeLabel.position = buttonPoint;
    [self addChild: typeLabel];
    //blockLabel
    blockLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    blockLabel.text = @"1";
    blockLabel.fontSize = 20;
    blockLabel.position = CGPointMake(buttonSize*3/2, buttonSize/2);
    [self addChild: blockLabel];
    [self createMenuButtons];
    [self createButton];
    //    [self createObstacles];
    //    [self createStartBalls];
    //    [self createGoal];
    
    
    
    //    balls = [NSMutableArray array],[NSMutableArray array],[NSMutableArray array];
    //    [self addChild:myLabel];
    
    //set up balltype label
    
    
    
    
    
    
}

-(void) newGameOld{
    goalActive = false;

    SKPhysicsBody* borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    // 2 Set physicsBody of scene to borderBody
    self.physicsBody = borderBody;
    // 3 Set the friction of that physicsBody to 0
    self.physicsBody.friction = 0.0f;
    self.physicsBody.categoryBitMask = bgCategory;
    self.physicsWorld.contactDelegate = self;
    
    //RTcmix setup

    //gets initiated at 0
    ballNum = 0;
    //ballType starts at 1
    ballType = 1;
    blockType = 1;
    ballNum1 = 0;
    ballNum2 = 0;
    ballNum3 = 0;
    ballNum4 = 0;
    ballNum5 = 0;
    //sets up balls array
    //initiate balls array
    [balls removeAllObjects];
    //set up three initial arrays (should be for loop)
    for(int i = 0; i < maxBalls; i++){
        NSArray *vals = @[[NSString stringWithFormat:@"%d", i], @"0.0", @"0", @"0"];
        NSMutableArray *bob = [[NSMutableArray alloc] init];
        NSString *tom1 = [vals objectAtIndex: 0];
        NSString *tom2 = [vals objectAtIndex: 1];
        NSString *tom3 = [vals objectAtIndex: 2];
        NSString *tom4 = [vals objectAtIndex: 3];
        [bob addObject: tom1];
        [bob addObject: tom2];
        [bob addObject: tom3];
        [bob addObject: tom4];
        [balls addObject: bob];
        
    }
    //create button

//    [self createObstacles];
//    [self createStartBalls];
    //    [self createGoal];
    
    
    
    //    balls = [NSMutableArray array],[NSMutableArray array],[NSMutableArray array];
    //    [self addChild:myLabel];
    
    //set up balltype label
    //create button
    typeLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    typeLabel.text = @"1";
    typeLabel.fontSize = 20;
    typeLabel.position = buttonPoint;
    [self addChild: typeLabel];
    //blockLabel
    blockLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    blockLabel.text = @"1";
    blockLabel.fontSize = 20;
    blockLabel.position = CGPointMake(buttonSize*3/2, buttonSize/2);
    [self addChild: blockLabel];
    [self createMenuButtons];
    [self createButton];
    //set balls to 0
    [self createButton];
    if(blockActive){
        blockButton.fillColor = blockPressed;
    } else{
        blockButton.fillColor = yb;
    }
    gameActive = false;
    tutorialMode = false;
}

-(void) restart{
    for (SKNode* node in self.children) {
        [node removeFromParent];
    }
}
//makeball method
-(BallNode *)makeBall:(CGPoint) p{


    int curNum = -1;
    //for loop to find appropriate place in array
    for(int i = 0; i < maxBalls; i++){
        if([[[balls objectAtIndex: i] objectAtIndex: 1] floatValue] == 0.0){
            curNum = i;
            break;
        }
    }
    BallNode *ball;
    if(curNum == -1){
        [NSException raise:@"Crash!!!" format:@"size of %d is invalid", curNum];
        NSLog(@"Too many balls");
        return NULL;
    }else{
    
    
//    int slot = curNum;

    //slot, alive, voices, volume, health
//    NSArray *currencies;
        CGMutablePathRef myPath = CGPathCreateMutable();
    switch (ballType){
        case 1:
            ball = [[BallNode alloc] init: curNum vol: 1 hp: 5];

            ball.r = 1;
            ball.g = 0;//50/100.0f;
//            double k = arc4random() % 100;
            ball.b = 0;//(arc4random() % 100)/100.0f;
            ball.a = 100;
            CGPathAddArc(myPath, NULL, 0,0, 18, 0, M_PI*2, YES);
            ballNum1++;
            break;
        case 2:
            ball = [[BallNode alloc] init: curNum vol: 1 hp: 3];
            ball.r = (50 + (arc4random() % 25))/100.0f;
            ball.g = .5;
            ball.b = .25 + (arc4random() % 75)/100.0f;
            ball.a = 100;
            CGPathAddArc(myPath, NULL, 0,0, 15, 0, M_PI*2, YES);
            ballNum2++;
            break;
        case 3:
            ball = [[BallNode alloc] init: curNum vol: 0 hp: 5];
//            int wk = ball.alive;
            ball.r = 5;
            float m = (arc4random() % 100);
            m = m/100;
            float j = (arc4random() % 100)/100.0f;
            float l = (arc4random() % 100)/100.0f;
            ball.r = m;
            ball.g = j;
            ball.b = l;
            ball.a = 100;
            CGPathAddArc(myPath, NULL, 0,0, 5, 0, M_PI*2, YES);
            ballNum3++;
            break;
        case 4:
            ball = [[BallNode alloc] init: curNum vol: 1 hp: 3];
            ball.r = 0;
            ball.g = 50/100.0f;
            ball.b = (arc4random() % 100)/100.0f;
            ball.a = 100;
            CGPathAddArc(myPath, NULL, 0,0, 10, 0, M_PI*2, YES);
            ballNum4++;
            break;
        case 5:
            ball = [[BallNode alloc] init: curNum vol: 0 hp: 5];
            ball.r = 1;
            ball.g = 1;
            ball.b = 1;
            ball.a = 100;
            CGPathAddArc(myPath, NULL, 0,0, 20, 0, M_PI*2, YES);
            ballNum5++;
            break;
        //special drone block
        case 6:
            //cuts off after first if starting vol is "0.5"
            ball = [[BallNode alloc] init: curNum vol: 0.0 hp: 5];
            ball.r = 1;
            ball.g = 1;
            ball.b = 1;
            ball.a = 100;
            //creats at bottom left corner
            CGPathAddRect(myPath, NULL, CGRectMake(0, 0, 80, 80));
            break;
        case 7:
            //cuts off after first if starting vol is "0.5"
            ball = [[BallNode alloc] init: curNum vol: 0.0 hp: 5];
            ball.r = .5;
            ball.g = .5;
            ball.b = 1;
            ball.a = 100;
            //creats at bottom left corner
            CGPathAddRect(myPath, NULL, CGRectMake(0, 0, 80, 80));
            break;
        case 8:
            //cuts off after first if starting vol is "0.5"
            ball = [[BallNode alloc] init: curNum vol: 0.0 hp: 5];
            ball.r = 0;
            ball.g = .5;
            ball.b = .5;
            ball.a = 100;
            //creats at bottom left corner
            CGPathAddRect(myPath, NULL, CGRectMake(0, 0, 80, 80));
            break;
    }
    //adds the new ball to the ball array - currently assumes 5 elements

    [self updateBall: ball];
    ball.strokeColor = [SKColor whiteColor];
    ball.glowWidth = 0.5;
    ball.fillColor = [SKColor colorWithRed: ball.r green: ball.g blue: ball.b alpha: ball.a];
    ball.path = myPath;
    ball.lineWidth = 1.0;
    ball.name = ballCategoryName;
    ball.position = p;
    [self addChild:ball];
        if(ballType>5){
            if(ballType==6){
                ball.name = blockCategoryName5;
            }
            if(ballType==7){
                ball.name = blockCategoryName6;
            }
            if(ballType==8){
                ball.name = blockCategoryName7;
            }
            ball.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath: myPath];
        }
        else{
                ball.name = ballCategoryName;
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.frame.size.width/2];
        }
    
    switch(ballType){
        case 1:
            ball.physicsBody.categoryBitMask = BallCategory1;
            ball.physicsBody.contactTestBitMask = BubCategory|BallCategory1|BallCategory2|BallCategory3|BallCategory4|BallCategory5|BlockCategory|BlockCategory2|BlockCategory3|BlockCategory4;
            //removed from 3
            ball.physicsBody.collisionBitMask = bgCategory| BubCategory|ObstacleCategory | BallCategory1 | BallCategory2|BallCategory3|BallCategory4|BallCategory5|BlockCategory|BlockCategory|BlockCategory2|BlockCategory3|BlockCategory4|BlockCategory5;
            break;
        case 2:
            ball.physicsBody.categoryBitMask = BallCategory2;
            ball.physicsBody.contactTestBitMask = BallCategory1|BallCategory2|BallCategory3|BallCategory4|BallCategory5|BlockCategory|BlockCategory2|BlockCategory3|BlockCategory4;
            ball.physicsBody.collisionBitMask = bgCategory| BubCategory |ObstacleCategory| BallCategory1 | BallCategory2|BallCategory3|BallCategory4|BallCategory5|BlockCategory|BlockCategory2|BlockCategory3|BlockCategory4|BlockCategory5;
            break;
        case 3:
            ball.physicsBody.categoryBitMask = BallCategory3;
            ball.physicsBody.contactTestBitMask = BallCategory1|BallCategory2|BallCategory3|BallCategory4|BallCategory5|BlockCategory|BlockCategory2|BlockCategory3|BlockCategory4|BlockCategory5;
            //removed collision with itself and 1
            ball.physicsBody.collisionBitMask = bgCategory| BubCategory |ObstacleCategory | BallCategory1|BallCategory2|BallCategory4|BallCategory5|BlockCategory|BlockCategory2|BlockCategory3|BlockCategory4|BlockCategory5;
            break;
        case 4:
            ball.physicsBody.categoryBitMask = BallCategory4;
            ball.physicsBody.contactTestBitMask = BallCategory1|BallCategory2|BallCategory3|BallCategory4|BallCategory5|BlockCategory|BlockCategory2|BlockCategory3|BlockCategory4|BlockCategory5;
            ball.physicsBody.collisionBitMask = bgCategory| BubCategory |ObstacleCategory| BallCategory1 | BallCategory2|BallCategory3|BallCategory4|BallCategory5|BlockCategory|BlockCategory2|BlockCategory3|BlockCategory4;
            break;
        case 5:
            ball.physicsBody.categoryBitMask = BallCategory5;
            ball.physicsBody.contactTestBitMask = BallCategory1|BallCategory2|BallCategory3|BallCategory4|BallCategory5|BlockCategory|BlockCategory5;
            ball.physicsBody.collisionBitMask = bgCategory | BubCategory|ObstacleCategory| BallCategory1 | BallCategory2|BallCategory3|BallCategory4|BallCategory5|BlockCategory|BlockCategory2|BlockCategory3|BlockCategory4|BlockCategory5;
            break;
        //special drone block
        case 6:
            ball.physicsBody.categoryBitMask = BlockCategory5;
            ball.physicsBody.collisionBitMask = BallCategory1 | BallCategory2|BallCategory3|BallCategory4|BallCategory5;
            ball.physicsBody.contactTestBitMask = BallCategory4 | BallCategory3| BallCategory5;
            ball.physicsBody.dynamic = NO;
            break;
        case 7:
            ball.physicsBody.categoryBitMask = BlockCategory6;
            ball.physicsBody.collisionBitMask = BallCategory1 | BallCategory2|BallCategory3|BallCategory4|BallCategory5;
            ball.physicsBody.contactTestBitMask = BallCategory4 | BallCategory3| BallCategory5;
            ball.physicsBody.dynamic = NO;
            break;
        case 8:
            ball.physicsBody.categoryBitMask = BlockCategory7;
            ball.physicsBody.collisionBitMask = BallCategory1 | BallCategory2|BallCategory3|BallCategory4|BallCategory5;
            ball.physicsBody.contactTestBitMask = BallCategory4 | BallCategory3| BallCategory5;
            ball.physicsBody.dynamic = NO;
            break;
    }
    

    //set up mass (added when changing to shapenode
    ball.physicsBody.mass = 0.1f;
    ball.physicsBody.friction = 0.0f;
    ball.physicsBody.restitution = 1.0f;
    ball.physicsBody.linearDamping = 0.0f;
    ball.physicsBody.allowsRotation = NO;
    //Determing direction of ball
//    CGPoint offset = rwSub(p, player);
//    CGPoint direction = rwNormalize(offset);
//    [ball.physicsBody applyImpulse:CGVectorMake(direction.x*velocity, direction.y*velocity)];
    

    //begin continuous playing
if(ballType == 5){
        [self expire: ball length: 5];
    }
    else if(ballType == 6){
        NSString *values = [self convertArray: [balls objectAtIndex: curNum]];
        [self.rtcmixManager parseScoreWithNSString:values];
        NSString *scorePath = [[NSBundle mainBundle] pathForResource:@"eth" ofType:@"sco"];
        [self.rtcmixManager parseScoreWithFilePath:scorePath];
    }
    else if(ballType == 7){
        NSString *values = [self convertArray: [balls objectAtIndex: curNum]];
        [self.rtcmixManager parseScoreWithNSString:values];
        NSString *scorePath = [[NSBundle mainBundle] pathForResource:@"brad1" ofType:@"sco"];
        [self.rtcmixManager parseScoreWithFilePath:scorePath];
    }
    else if(ballType == 8){
        NSString *values = [self convertArray: [balls objectAtIndex: curNum]];
        [self.rtcmixManager parseScoreWithNSString:values];
        NSString *scorePath = [[NSBundle mainBundle] pathForResource:@"brad2" ofType:@"sco"];
        [self.rtcmixManager parseScoreWithFilePath:scorePath];
    }
    //updates ballnum to reflect it's creation
    //ballNum = ballNum*-1;
    ballNum++;
    [self changeColor];
    }

    return ball;
}

-(void)shootBall: (BallNode *) ball at: (CGPoint) t from: (CGPoint) p{
    CGPoint offset = rwSub(p, t);
    CGPoint direction = rwNormalize(offset);
    [ball.physicsBody applyImpulse:CGVectorMake(direction.x*velocity, direction.y*velocity)];
}


//Actual Game functions

//touches began
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(tutorialMode){
        [self tutorialCheck:touches withEvent:event];
    }
    
    else if(gameActive){
    /* Called when a touch begins */
        bool booble = false;
//    NSMutableArray *bob = [[NSMutableArray alloc] init];
        for (UITouch *touch in touches) {
            CGPoint location = [touch locationInNode:self];
        //for ball button
            SKNode *node = [self nodeAtPoint:location];

            if ([node.name isEqualToString:buttonCategoryName]) {
                [self changeBall];
            }
            else if ([node.name isEqualToString:buttonCategoryName2]) {
                [self restart];
                [self newGame];
            }
            else if ([node.name isEqualToString:buttonCategoryName3]) {
                blockActive = !blockActive;
                buttonTouch = touch;
                NSString *scorePath2 = [[NSBundle mainBundle] pathForResource:@"change" ofType:@"sco"];
                [self.rtcmixManager parseScoreWithFilePath:scorePath2];
                if(blockActive){
                    blockButton.fillColor = blockPressed;
                } else{
                    blockButton.fillColor = yb;
                }
            }
            else if ([node.name isEqualToString:buttonCategoryNamePause]) {
                
                if(self.scene.view.paused == NO){
//                    [self createMenuButtons];
//                    gameActive = false;
                    //pauseButton.fillColor = pausePressed;
                    //[self createMenuButtons];
                    pauseButton.fillColor = pausePressed;
                    SKAction *wait = [SKAction waitForDuration: .001];
                    SKAction *fad = [SKAction runBlock:^{
                        self.scene.view.paused = YES;
                        [self.rtcmixManager pauseRTcmix];
                    }];
                    SKAction *exp = [SKAction sequence: @[wait, fad]];
                    [self runAction: exp];
                    //self.scene.view.paused = YES;
                    //[self.rtcmixManager pauseRTcmix];
                    

                } else{
                    pauseButton.fillColor = pauseUn;
                    //[tutorialButton removeFromParent];
                    self.scene.view.paused = NO;
                    [self.rtcmixManager resumeRTcmix];
                }
            }
            else if ([node.name isEqualToString:buttonCategoryName4]) {
                [self changeBlock];
                NSString *scorePath2 = [[NSBundle mainBundle] pathForResource:@"record" ofType:@"sco"];
                [self.rtcmixManager parseScoreWithFilePath:scorePath2];
            }
            else if (blockActive){
                if ([node.name isEqualToString:blockCategoryName]) {
                    [node removeFromParent];
                }
                else if([node.name isEqualToString:blockCategoryName5]||[node.name isEqualToString:blockCategoryName6]||[node.name isEqualToString:blockCategoryName7]){
                    [self deleteBall: (BallNode *) node];
                }
                else{
                    [self createBlock: location];
                }
            }
            else if([node.name isEqualToString:ballCategoryName]){
                [self deleteBall: (BallNode *) node];
            }
            else if (ballNum < maxBalls && !blockActive){
                bool shootable = false;
                switch(ballType){
                    case 1:
                        if(ballNum1 < maxBalls1){
                            shootable = true;
                        }
                        break;
                    case 2:
                        if(ballNum2 < maxBalls2){
                            shootable = true;
                        }
                        break;
                    case 3:
                        if(ballNum3 < maxBalls3){
                            shootable = true;
                        }
                        break;
                    case 4:
                        if(ballNum4 < maxBalls4){
                            shootable = true;
                        }
                        break;
                    case 5:
                        if(ballNum1 < maxBalls1){
                            shootable = true;
                        }
                        break;
                }
                if(ballType != 5) {
                    if(ballNum == maxBalls -1){
                        shootable = false;
                    }
                }
                if(shootable&&shoot){
                    BallNode *ball = [self makeBall:player];
                    if(ball != NULL){
                        [self shootBall:ball at: player from: location];
                    }
                }
            }
        }
        if(booble){
            
        }
    } else if(tutActive){
        for (UITouch *touch in touches) {
            CGPoint location = [touch locationInNode:self];
            SKNode *node = [self nodeAtPoint:location];
            if ([node.name isEqualToString:buttonCategoryNameNext]) {
                tutNum++;
                if(tutNum==[tutMessage count]){
                    tutActive = false;
                    [node removeFromParent];
                    [tutLabel removeFromParent];
                    [tutLabel2 removeFromParent];
                    [tutLabel3 removeFromParent];
//                    gameActive = true;
                    [self createMenuButtons];
                    return;
                }
                tutLabel.text = [tutMessage objectAtIndex: tutNum];
                tutLabel2.text = [tutMessage2 objectAtIndex: tutNum];
                tutLabel3.text = [tutMessage3 objectAtIndex: tutNum];
            }
        }
    }
    else{
        for (UITouch *touch in touches) {
            CGPoint location = [touch locationInNode:self];
            SKNode *node = [self nodeAtPoint:location];
            if ([node.name isEqualToString:buttonCategoryNameStart]) {
                gameActive = true;
                [self deleteMenuButtons];
//                buildType = 1;
                
            }
            else if([node.name isEqualToString:@"2"]){
                gameActive = true;
                //place tutorialLevel outside usable range
                tutorialLevel = 100;
                [self deleteMenuButtons];
 //               buildType = 2;
            }
            else if([node.name isEqualToString:@"3"]){
                gameActive = true;
 //               [self deleteMenuButtons];
                buildType = 3;
            }
            else if ([node.name isEqualToString:buttonCategoryNameTutorial]) {
                //tutorialMode = true;
                //tutorialLevel = 0;
                [self runTutorialLevels];
                //[self runTutorial];
  //              buildType = 1;
            }
            //for fiddling with pause
/*            if(gameActive){
            if(self.scene.view.paused == YES){
                self.scene.view.paused = NO;
                [self.rtcmixManager resumeRTcmix];
            }
            }
 */

        }
    }
}
-(void) tutorialCheck:(NSSet *)touches withEvent:(UIEvent *)event {
    if(gameActive){
        /* Called when a touch begins */
        //    NSMutableArray *bob = [[NSMutableArray alloc] init];
        for (UITouch *touch in touches) {
            CGPoint location = [touch locationInNode:self];
            //for ball button
            SKNode *node = [self nodeAtPoint:location];
            
            if ([node.name isEqualToString:buttonCategoryName]) {
                if(ballButtonBool){
                    [self changeBall];
                }
            }
            else if ([node.name isEqualToString:buttonCategoryName2]) {
                if(restartbuttonBool){
                    [self restart];
                    [self newGame];
                }
            }
            else if ([node.name isEqualToString:buttonCategoryName3]) {
                if(blockButtonBool){
                    blockActive = !blockActive;
                    buttonTouch = touch;
                    if(blockActive){
                        blockButton.fillColor = blockPressed;
                    } else{
                        blockButton.fillColor = yb;
                    }
                }
            }
            else if ([node.name isEqualToString:buttonCategoryNamePause]) {
                
                if(self.scene.view.paused == NO){
                    //                    [self createMenuButtons];
                    //                    gameActive = false;
                    //pauseButton.fillColor = pausePressed;
                    //[self createMenuButtons];
                    pauseButton.fillColor = pausePressed;
                    SKAction *wait = [SKAction waitForDuration: .001];
                    SKAction *fad = [SKAction runBlock:^{
                        self.scene.view.paused = YES;
                        [self.rtcmixManager pauseRTcmix];
                    }];
                    SKAction *exp = [SKAction sequence: @[wait, fad]];
                    [self runAction: exp];
                    //self.scene.view.paused = YES;
                    //[self.rtcmixManager pauseRTcmix];
                    
                    
                } else{
                    pauseButton.fillColor = pauseUn;
                    //[tutorialButton removeFromParent];
                    self.scene.view.paused = NO;
                    [self.rtcmixManager resumeRTcmix];
                }
            }
            else if ([node.name isEqualToString:buttonCategoryName4]) {
                if(bchangebuttonBool){
                    [self changeBlock];
                }
            }
            else if ([node.name isEqualToString:buttonCategoryNameNext]){
                tutorialLevel++;
                [self tutorialLevelChange];
                [node removeFromParent];
            }
            else if (blockActive){
                if ([node.name isEqualToString:blockCategoryName]) {
                    [node removeFromParent];
                }
                else if([node.name isEqualToString:blockCategoryName5]||[node.name isEqualToString:blockCategoryName6]||[node.name isEqualToString:blockCategoryName7]){
                    [self deleteBall: (BallNode *) node];
                }
                else{
                    if(tutorialLevel==6){
                        ccounter++;
                        if(ccounter>2){
                            [self createNextButton];
                        }
                    }
                    if(tutorialLevel==8){
                        if(blockType==2){
                            vic1 = true;
                        }
                        if(blockType==3){
                            vic2 = true;
                        }
                        if(blockType==4){
                            vic3 = true;
                        }
                        if(vic1&&vic2&&vic3){
                            [self createNextButton];
                        }
                    }
                    if(tutorialLevel==9){
                        if(blockType==2){
                            vic1 = true;
                        }
                        if(blockType==3){
                            vic2 = true;
                        }
                        if(blockType==4){
                            vic3 = true;
                        }
                        if(vic1&&vic2&&vic3&&vic4&&vic5&&vic6){
                            [self createNextButton];
                        }
                    }
                    
                    
                    [self createBlock: location];
                }
            }
            else if([node.name isEqualToString:ballCategoryName]){
                [self deleteBall: (BallNode *) node];
            }
            else if (ballNum < maxBalls && !blockActive){
                bool shootable = false;
                switch(ballType){
                    case 1:
                        if(ballNum1 < maxBalls1){
                            shootable = true;
                        }
                        break;
                    case 2:
                        if(ballNum2 < maxBalls2){
                            shootable = true;
                        }
                        break;
                    case 3:
                        if(ballNum3 < maxBalls3){
                            shootable = true;
                        }
                        break;
                    case 4:
                        if(ballNum4 < maxBalls4){
                            shootable = true;
                        }
                        break;
                    case 5:
                        if(ballNum1 < maxBalls1){
                            shootable = true;
                        }
                        break;
                }
                if(ballType != 5) {
                    if(ballNum == maxBalls -1){
                        shootable = false;
                    }
                }
                if(shootable){
                    BallNode *ball = [self makeBall:player];
                    if(ball != NULL){
                        [self shootBall:ball at: player from: location];
                    }
                    
                    
                    if(tutorialLevel==9){
                        if(ballType==2){
                            vic4 = true;
                        }
                        if(ballType==3){
                            vic5 = true;
                        }
                        if(ballType==4){
                            vic6 = true;
                        }
                        if(vic1&&vic2&&vic3&&vic4&&vic5&&vic6){
                            [self createNextButton];
                        }
                    }
                    
                    
                }
            }

        }
    
    }
}


//currently if touch moves, the game breaks
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

}

//Collision Function

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    // 1
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }

    // 2
    if ((firstBody.categoryBitMask & BallCategory1) != 0 &&
        (secondBody.categoryBitMask & BallCategory1) != 0)
    {
        
        if(tutorialLevel==5){
            ccounter++;
            if(ccounter>10){
                [self createNextButton];
            }
        }

//        BallNode *a = (BallNode *) firstBody.node;
//        BallNode *b = (BallNode *) secondBody.node;
/*
        [self addVoice: (BallNode *) secondBody.node];
        [self changeColor: (BallNode *) secondBody.node r: arc4random()%3 g: arc4random()%3 b: arc4random()%3];
        [self fadeAway: (BallNode *) firstBody.node];
        [self changeColor];
        ballNum1 = ballNum1 - 1;
        //[self deleteBall: (BallNode *) firstBody.node];
        //NSString *scorePath3 = [[NSBundle mainBundle] pathForResource:@"a" ofType:@"sco"];
        //[self.rtcmixManager parseScoreWithFilePath:scorePath3];
        [self createEcho: contact.contactPoint];
 */
        if(clippingOK){
        NSString *scorePath2 = [[NSBundle mainBundle] pathForResource:@"mel" ofType:@"sco"];
        [self.rtcmixManager parseScoreWithFilePath:scorePath2];
        [self changeColor: (BallNode *) secondBody.node r: arc4random()%3 g: arc4random()%3 b: arc4random()%3];
         [self waitClip: .02];
        }
        if(tutorialLevel == 1){
            [self createNextButton];
        }
    }
    
    //this one never happens, 2 & 1

    else if ((firstBody.categoryBitMask & BallCategory1) != 0 &&
        (secondBody.categoryBitMask & BallCategory2) != 0)
    
    {
        if(tutorialLevel==5){
            ccounter++;
            if(ccounter>10){
                [self createNextButton];
            }
        }
        if(tutorialLevel==7){
            [self createNextButton];
        }
        /*
        if(buildType != 3){
        NSString *scorePath3 = [[NSBundle mainBundle] pathForResource:@"bars" ofType:@"sco"];
        [self.rtcmixManager parseScoreWithFilePath:scorePath3];
        [self changeColor: (BallNode *) secondBody.node r: arc4random()%3 g: arc4random()%3 b: arc4random()%3];
        [self incvict1];
                [self createEcho: contact.contactPoint];
         
        }
        */
        if(clippingOK){
        NSString *scorePath2 = [[NSBundle mainBundle] pathForResource:@"b" ofType:@"sco"];
        [self.rtcmixManager parseScoreWithFilePath:scorePath2];
        [self changeColor: (BallNode *) secondBody.node r: arc4random()%3 g: arc4random()%3 b: arc4random()%3];
         [self waitClip: .02];
            if(tutorialLevel == 2){
                [self createNextButton];
            }
            if(tutorialLevel==3){
                vic1 = true;
            }
        
        }
        
        


    }
    else if ((firstBody.categoryBitMask & BallCategory1) != 0 &&
        (secondBody.categoryBitMask & BallCategory3) != 0)
    {
        if(tutorialLevel==5){
            ccounter++;
            if(ccounter>10){
                [self createNextButton];
            }
        }
        /*
        BallNode *bnode = (BallNode *) firstBody.node;
        if(bnode.volume < 1){
                    [self potUp: (BallNode *) firstBody.node amt: 0.1 t: 1];
        }
        [self fadeAway: (BallNode*) secondBody.node];
        ballNum3--;
//        NSString *scorePath2 = [[NSBundle mainBundle] pathForResource:@"bars" ofType:@"sco"];
//        [self.rtcmixManager parseScoreWithFilePath:scorePath2];
         */
        NSString *scorePath2 = [[NSBundle mainBundle] pathForResource:@"saxs2" ofType:@"sco"];
        [self.rtcmixManager parseScoreWithFilePath:scorePath2];
        [self changeColor: (BallNode *) firstBody.node r: arc4random()%3 g: arc4random()%3 b: arc4random()%3];
    }
    else if ((firstBody.categoryBitMask & BallCategory1) != 0 &&
        (secondBody.categoryBitMask & BallCategory4) != 0)
    {
        if(tutorialLevel==5){
            ccounter++;
            if(ccounter>10){
                [self createNextButton];
            }
        }
        /*
        if(buildType != 3){
        NSString *scorePath2 = [[NSBundle mainBundle] pathForResource:@"a" ofType:@"sco"];
        [self.rtcmixManager parseScoreWithFilePath:scorePath2];
        [self incvict2];
        [self changeColor: (BallNode *) secondBody.node r: arc4random()%3 g: arc4random()%3 b: arc4random()%3];
                [self createEcho: contact.contactPoint];
        }
        
         */
        if(clippingOK){
        NSString *scorePath2 = [[NSBundle mainBundle] pathForResource:@"saxs" ofType:@"sco"];
        [self.rtcmixManager parseScoreWithFilePath:scorePath2];
        [self changeColor: (BallNode *) secondBody.node r: arc4random()%3 g: arc4random()%3 b: arc4random()%3];
         [self waitClip: .02];
            if(tutorialLevel==3){
                vic2 = true;
            }
        }
    }
    else if ((firstBody.categoryBitMask & BallCategory2) != 0 &&
             (secondBody.categoryBitMask & BallCategory4) != 0)
    {
        if(tutorialLevel==5){
            ccounter++;
            if(ccounter>10){
                [self createNextButton];
            }
        }

        if(clippingOK){
        NSString *scorePath2 = [[NSBundle mainBundle] pathForResource:@"nose" ofType:@"sco"];
        [self.rtcmixManager parseScoreWithFilePath:scorePath2];
        [self changeColor: (BallNode *) secondBody.node r: arc4random()%3 g: arc4random()%3 b: arc4random()%3];
         [self waitClip: .02];
            if(tutorialLevel==3){
                vic3 = true;
            }
        }
    }
    else if ((firstBody.categoryBitMask & BallCategory2) != 0 &&
             (secondBody.categoryBitMask & BallCategory3) != 0)
    {
        if(tutorialLevel==5){
            ccounter++;
            if(ccounter>10){
                [self createNextButton];
            }
        }

        [self changeColor: (BallNode *) secondBody.node r: arc4random()%3 g: arc4random()%3 b: arc4random()%3];
        [self changeColor: (BallNode *) firstBody.node r: arc4random()%3 g: arc4random()%3 b: arc4random()%3];
        NSString *scorePath2 = [[NSBundle mainBundle] pathForResource:@"bars2" ofType:@"sco"];
        [self.rtcmixManager parseScoreWithFilePath:scorePath2];
        [self createEcho: contact.contactPoint];
    }
    else if ((firstBody.categoryBitMask & BallCategory3) != 0 &&
             (secondBody.categoryBitMask & BallCategory4) != 0)
    {
        if(tutorialLevel==5){
            ccounter++;
            if(ccounter>10){
                [self createNextButton];
            }
        }
        
        
        NSString *scorePath2 = [[NSBundle mainBundle] pathForResource:@"mel" ofType:@"sco"];
        [self.rtcmixManager parseScoreWithFilePath:scorePath2];
        NSString *scorePath3 = [[NSBundle mainBundle] pathForResource:@"mel" ofType:@"sco"];
        [self.rtcmixManager parseScoreWithFilePath:scorePath3];
        [self createEcho: contact.contactPoint];
    }
    //Delete balls
    else if ((secondBody.categoryBitMask & BallCategory5) != 0){
        if(((firstBody.categoryBitMask & BallCategory1) != 0)||((firstBody.categoryBitMask & BallCategory2) != 0)||((firstBody.categoryBitMask & BallCategory3) != 0)||((firstBody.categoryBitMask & BallCategory4) != 0)){
            [self fadeAway: (BallNode *) firstBody.node];
            BallNode * ball = (BallNode *) secondBody.node;
            ball.health = ball.health - 1;
            if(ball.health <= 0){
                [self fadeAway: ball];
                ballNum5 = ballNum5 - 1;
            }
            if(tutorialLevel==4){
                [self createNextButton];
            }
            
            
            if((firstBody.categoryBitMask & BallCategory1) != 0){
                ballNum1 = ballNum1 - 1;
            }
            if((firstBody.categoryBitMask & BallCategory2) != 0){
                ballNum2 = ballNum2 - 1;
            }
            if((firstBody.categoryBitMask & BallCategory3) != 0){
                ballNum3 = ballNum3 - 1;
            }
            if((firstBody.categoryBitMask & BallCategory4) != 0){
                ballNum4 = ballNum4 - 1;
            }
        }
    }
    

//Drone block
    //block 5
    //handles voices
    else if ((firstBody.categoryBitMask & BallCategory4) != 0 &&
             (secondBody.categoryBitMask & BlockCategory5) != 0)
    {
        [self addVoice: (BallNode *) secondBody.node];
        [self fadeAway: (BallNode*) firstBody.node];
        if(tutorialLevel==10){
            BallNode *bnode = (BallNode *) secondBody.node;
            if(bnode.voices>2){
                vic2 = true;
            }
        }
        ballNum4--;
    }
    //handles volume
    else if ((firstBody.categoryBitMask & BallCategory3) != 0 &&
             (secondBody.categoryBitMask & BlockCategory5) != 0)
    {
        BallNode *bnode = (BallNode *) secondBody.node;
        if(bnode.volume < 1){
            [self potUp: (BallNode *) secondBody.node amt: 0.1 t: 1];
        }
        if(tutorialLevel==10){
            if(bnode.volume > .4){
                vic1 = true;
            }
        }
        [self fadeAway: (BallNode*) firstBody.node];
        ballNum3--;
    }
    //block 6
    //handles voices
    else if ((firstBody.categoryBitMask & BallCategory4) != 0 &&
             (secondBody.categoryBitMask & BlockCategory6) != 0)
    {
        [self addVoice: (BallNode *) secondBody.node];
        [self fadeAway: (BallNode*) firstBody.node];
        ballNum4--;
    }
    //handles volume
    else if ((firstBody.categoryBitMask & BallCategory3) != 0 &&
             (secondBody.categoryBitMask & BlockCategory6) != 0)
    {
        BallNode *bnode = (BallNode *) secondBody.node;
        if(bnode.volume < 1){
            [self potUp: (BallNode *) secondBody.node amt: 0.1 t: 1];
        }
        [self fadeAway: (BallNode*) firstBody.node];
        ballNum3--;
    }
    //block 7
    //handles voices
    else if ((firstBody.categoryBitMask & BallCategory4) != 0 &&
             (secondBody.categoryBitMask & BlockCategory7) != 0)
    {
        [self addVoice: (BallNode *) secondBody.node];
        [self fadeAway: (BallNode*) firstBody.node];
        ballNum4--;
    }
    //handles volume
    else if ((firstBody.categoryBitMask & BallCategory3) != 0 &&
             (secondBody.categoryBitMask & BlockCategory7) != 0)
    {
        BallNode *bnode = (BallNode *) secondBody.node;
        if(bnode.volume < 1){
            [self potUp: (BallNode *) secondBody.node amt: 0.1 t: 1];
        }
        [self fadeAway: (BallNode*) firstBody.node];
        ballNum3--;
    }
//Block collisions
    else if ((firstBody.categoryBitMask & BallCategory5) != 0 &&
             (secondBody.categoryBitMask & BlockCategory) != 0)
    {
        [self fadeAway: (BallNode *) firstBody.node];
        //[secondBody.node removeFromParent];
        [self deleteBall: (BallNode *) secondBody.node];
        ballNum5--;
    }
    if ((firstBody.categoryBitMask & BallCategory1) != 0 &&
             (secondBody.categoryBitMask & BlockCategory2) != 0)
    {
        if(clippingOK){
            NSString *scorePath3 = [[NSBundle mainBundle] pathForResource:@"bars" ofType:@"sco"];
            [self.rtcmixManager parseScoreWithFilePath:scorePath3];
            [self createEcho: contact.contactPoint];
            [self waitClip: .05];
            if(tutorialLevel==0){
                [self createNextButton];
            }
        }
    }
    else if ((firstBody.categoryBitMask & BallCategory1) != 0 &&
             (secondBody.categoryBitMask & BlockCategory3) != 0)
    {
        if(clippingOK){
        NSString *scorePath3 = [[NSBundle mainBundle] pathForResource:@"mel" ofType:@"sco"];
        [self.rtcmixManager parseScoreWithFilePath:scorePath3];
            [self createEcho: contact.contactPoint];
            [self waitClip: .02];
        }
    }
    else if ((firstBody.categoryBitMask & BallCategory1) != 0 &&
             (secondBody.categoryBitMask & BlockCategory4) != 0)
    {
        if(clippingOK){
        NSString *scorePath3 = [[NSBundle mainBundle] pathForResource:@"a" ofType:@"sco"];
        [self.rtcmixManager parseScoreWithFilePath:scorePath3];
            [self createEcho: contact.contactPoint];
         [self waitClip: .02];
        }
    }
    if ((firstBody.categoryBitMask & BallCategory2) != 0 &&
        (secondBody.categoryBitMask & BlockCategory2) != 0)
    {
        if(clippingOK){
        NSString *scorePath3 = [[NSBundle mainBundle] pathForResource:@"bars" ofType:@"sco"];
        [self.rtcmixManager parseScoreWithFilePath:scorePath3];
        [self createEcho: contact.contactPoint];
             [self waitClip: .02];
        }
    }
    else if ((firstBody.categoryBitMask & BallCategory2) != 0 &&
             (secondBody.categoryBitMask & BlockCategory3) != 0)
    {
        if(clippingOK){
        NSString *scorePath3 = [[NSBundle mainBundle] pathForResource:@"mel" ofType:@"sco"];
        [self.rtcmixManager parseScoreWithFilePath:scorePath3];
        [self createEcho: contact.contactPoint];
           [self waitClip: .02];
        }
    }
    else if ((firstBody.categoryBitMask & BallCategory2) != 0 &&
             (secondBody.categoryBitMask & BlockCategory4) != 0)
    {
        if(clippingOK){
        NSString *scorePath3 = [[NSBundle mainBundle] pathForResource:@"a" ofType:@"sco"];
        [self.rtcmixManager parseScoreWithFilePath:scorePath3];
        [self createEcho: contact.contactPoint];
           [self waitClip: .02];
        }
    }
    if ((firstBody.categoryBitMask & BallCategory3) != 0 &&
        (secondBody.categoryBitMask & BlockCategory2) != 0)
    {
        if(clippingOK){
        NSString *scorePath3 = [[NSBundle mainBundle] pathForResource:@"bars" ofType:@"sco"];
        [self.rtcmixManager parseScoreWithFilePath:scorePath3];
        [self createEcho: contact.contactPoint];
            [self waitClip: .02];
        }
    }
    else if ((firstBody.categoryBitMask & BallCategory3) != 0 &&
             (secondBody.categoryBitMask & BlockCategory3) != 0)
    {
        
        if(clippingOK){
        NSString *scorePath3 = [[NSBundle mainBundle] pathForResource:@"mel" ofType:@"sco"];
        [self.rtcmixManager parseScoreWithFilePath:scorePath3];
        [self createEcho: contact.contactPoint];
             [self waitClip: .02];
        }
    }
    else if ((firstBody.categoryBitMask & BallCategory3) != 0 &&
             (secondBody.categoryBitMask & BlockCategory4) != 0)
    {
        if(clippingOK){
        NSString *scorePath3 = [[NSBundle mainBundle] pathForResource:@"a" ofType:@"sco"];
        [self.rtcmixManager parseScoreWithFilePath:scorePath3];
        [self createEcho: contact.contactPoint];
             [self waitClip: .02];
        }
    }
    if ((firstBody.categoryBitMask & BallCategory4) != 0 &&
        (secondBody.categoryBitMask & BlockCategory2) != 0)
    {
        if(clippingOK){
        NSString *scorePath3 = [[NSBundle mainBundle] pathForResource:@"bars" ofType:@"sco"];
        [self.rtcmixManager parseScoreWithFilePath:scorePath3];
        [self createEcho: contact.contactPoint];
            [self waitClip: .02];
        }
    }
    else if ((firstBody.categoryBitMask & BallCategory4) != 0 &&
             (secondBody.categoryBitMask & BlockCategory3) != 0)
    {
        if(clippingOK){
        NSString *scorePath3 = [[NSBundle mainBundle] pathForResource:@"mel" ofType:@"sco"];
        [self.rtcmixManager parseScoreWithFilePath:scorePath3];
        [self createEcho: contact.contactPoint];
             [self waitClip: .02];
        }
    }
    else if ((firstBody.categoryBitMask & BallCategory4) != 0 &&
             (secondBody.categoryBitMask & BlockCategory4) != 0)
    {
        if(clippingOK){
        NSString *scorePath3 = [[NSBundle mainBundle] pathForResource:@"a" ofType:@"sco"];
        [self.rtcmixManager parseScoreWithFilePath:scorePath3];
        [self createEcho: contact.contactPoint];
             [self waitClip: .02];
        }
    }
//    }
    //other collisions
    else if ((firstBody.categoryBitMask & ObstacleCategory) != 0 &&
             (secondBody.categoryBitMask & BallCategory5) != 0)
    {
        [self fadeAway: (BallNode *) firstBody.node];
        [self deleteBall: (BallNode *) secondBody.node];
    }
    else if ((secondBody.categoryBitMask & BallCategory1) != 0 &&
        (firstBody.categoryBitMask & goalCategory) != 0)
    {
        if(goalActive){
            [self nextLevel];
        }
    }
    if(tutorialLevel==3){
        if(vic1&&vic2&&vic3){
            [self createNextButton];
        }
    }
    if(tutorialLevel==10){
        if(vic1&&vic2){
            [self createNextButton];
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}
//Max methods from Damon

#pragma mark - Delegate Methods (the actual delegate methods)

- (void)maxBang {
}

- (void)maxMessage:(NSArray *)message {
    if([[message objectAtIndex: 0] floatValue] == 0.0){
        int k = [[message objectAtIndex: 1] floatValue];
//        NSArray *steven = [balls objectAtIndex: 0];
        NSString *values = [self convertArray: [balls objectAtIndex: k]];
        NSString *scorePath = [[NSBundle mainBundle] pathForResource:@"eth" ofType:@"sco"];

        [self.rtcmixManager parseScoreWithNSString:values];
        [self.rtcmixManager parseScoreWithFilePath:scorePath];
        [self.rtcmixManager setInlet:k withValue: [[[balls objectAtIndex: k] objectAtIndex: 3] floatValue]];
        if([[[balls objectAtIndex: k] objectAtIndex: 3] floatValue]>0){
            BallNode *tj = (BallNode *) [ballStorage objectAtIndex: k];
            [self createEcho: tj.position];
        }
    }
    else if([[message objectAtIndex: 0] floatValue] == 1.0){
        int k = [[message objectAtIndex: 1] floatValue];
        //        NSArray *steven = [balls objectAtIndex: 0];
        NSString *values = [self convertArray: [balls objectAtIndex: k]];
        NSString *scorePath = [[NSBundle mainBundle] pathForResource:@"brad1" ofType:@"sco"];
        
        [self.rtcmixManager parseScoreWithNSString:values];
        [self.rtcmixManager parseScoreWithFilePath:scorePath];
        [self.rtcmixManager setInlet:k withValue: [[[balls objectAtIndex: k] objectAtIndex: 3] floatValue]];
        if([[[balls objectAtIndex: k] objectAtIndex: 3] floatValue]>0){
            BallNode *tj = (BallNode *) [ballStorage objectAtIndex: k];
            [self createEcho: tj.position];
        }
    }
    else if([[message objectAtIndex: 0] floatValue] == 2.0){
        int k = [[message objectAtIndex: 1] floatValue];
        //        NSArray *steven = [balls objectAtIndex: 0];
        NSString *values = [self convertArray: [balls objectAtIndex: k]];
        NSString *scorePath = [[NSBundle mainBundle] pathForResource:@"brad2" ofType:@"sco"];
        
        [self.rtcmixManager parseScoreWithNSString:values];
        [self.rtcmixManager parseScoreWithFilePath:scorePath];
        [self.rtcmixManager setInlet:k withValue: [[[balls objectAtIndex: k] objectAtIndex: 3] floatValue]];
        if([[[balls objectAtIndex: k] objectAtIndex: 3] floatValue]>0){
            BallNode *tj = (BallNode *) [ballStorage objectAtIndex: k];
            [self createEcho: tj.position];
        }
    }

}

- (void)maxError:(NSString *)error {
    NSLog(@"maxError: %@", error);
//    NSLog(@"hey");
    if([error hasPrefix:@"CLIPPING:"]){
//        NSRange range = NSMakeRange(10, 13);
//        NSLog([error substringWithRange: range]);
    }
}



-(void) refresh{
    goalActive = false;
    SKPhysicsBody* borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    // 2 Set physicsBody of scene to borderBody
    self.physicsBody = borderBody;
    // 3 Set the friction of that physicsBody to 0
    self.physicsBody.friction = 0.0f;
    self.physicsBody.categoryBitMask = bgCategory;
    self.physicsWorld.contactDelegate = self;
    
    //gets initiated at 0
    ballNum = 0;
    //ballType starts at 1
    ballType = 1;
    blockType = 1;
    ballNum1 = 0;
    ballNum2 = 0;
    ballNum3 = 0;
    ballNum4 = 0;
    ballNum5 = 0;
    //sets up balls array
    //initiate balls array
    [balls removeAllObjects];
    //    balls = [[NSMutableArray alloc] init];
    //set up three initial arrays (should be for loop)
    for(int i = 0; i < maxBalls; i++){
        NSArray *vals = @[[NSString stringWithFormat:@"%d", i], @"0.0", @"0", @"0"];
        NSMutableArray *bob = [[NSMutableArray alloc] init];
        NSString *tom1 = [vals objectAtIndex: 0];
        NSString *tom2 = [vals objectAtIndex: 1];
        NSString *tom3 = [vals objectAtIndex: 2];
        NSString *tom4 = [vals objectAtIndex: 3];
        [bob addObject: tom1];
        [bob addObject: tom2];
        [bob addObject: tom3];
        [bob addObject: tom4];
        [balls addObject: bob];
        
    }
    
    //set up balltype label
    //create button
    typeLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    typeLabel.text = @"1";
    typeLabel.fontSize = 20;
    typeLabel.position = buttonPoint;
    [self addChild: typeLabel];
    //blockLabel
    blockLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    blockLabel.text = @"1";
    blockLabel.fontSize = 20;
    blockLabel.position = CGPointMake(buttonSize*3/2, buttonSize/2);
    [self addChild: blockLabel];
    [self createButton];
    //set balls to 0
    [self createButton];
    if(blockActive){
        blockButton.fillColor = blockPressed;
    } else{
        blockButton.fillColor = [SKColor yellowColor];
    }
    
    
    blockActive = false;
    if(blockActive){
        blockButton.fillColor = blockPressed;
    } else{
        blockButton.fillColor = [SKColor yellowColor];
    }
    
}
-(void) newGame{
    goalActive = false;
    [self setStartValues];
    [self createBounds];
    //RTcmix setup
    
    
    //sets up balls array
    //initiate balls array
    [balls removeAllObjects];
    //    balls = [[NSMutableArray alloc] init];
    //set up three initial arrays (should be for loop)
    [self populateBalls];
    //set up balltype label
    //create button
    [self newLabels];

}
-(void) newLabels{
    typeLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    typeLabel.text = @"1";
    typeLabel.fontSize = 20;
    typeLabel.position = buttonPoint;
    [self addChild: typeLabel];
    //blockLabel
    blockLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    blockLabel.text = @"1";
    blockLabel.fontSize = 20;
    blockLabel.position = CGPointMake(buttonSize*3/2, buttonSize/2);
    [self addChild: blockLabel];
    [self createMenuButtons];
    [self createButton];
    //set balls to 0
    [self createButton];
    if(blockActive){
        blockButton.fillColor = blockPressed;
    } else{
        blockButton.fillColor = yb;
    }
}
-(void) populateBalls{
    for(int i = 0; i < maxBalls; i++){
        NSArray *vals = @[[NSString stringWithFormat:@"%d", i], @"0.0", @"0", @"0"];
        NSMutableArray *bob = [[NSMutableArray alloc] init];
        NSString *tom1 = [vals objectAtIndex: 0];
        NSString *tom2 = [vals objectAtIndex: 1];
        NSString *tom3 = [vals objectAtIndex: 2];
        NSString *tom4 = [vals objectAtIndex: 3];
        [bob addObject: tom1];
        [bob addObject: tom2];
        [bob addObject: tom3];
        [bob addObject: tom4];
        [balls addObject: bob];
        
    }
}
-(void) createBounds{
    SKPhysicsBody* borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    // 2 Set physicsBody of scene to borderBody
    self.physicsBody = borderBody;
    // 3 Set the friction of that physicsBody to 0
    self.physicsBody.friction = 0.0f;
    self.physicsBody.categoryBitMask = bgCategory;
    self.physicsWorld.contactDelegate = self;
}
-(void) setStartValues{
    //gets initiated at 0
    ballNum = 0;
    //ballType starts at 1
    ballType = 1;
    blockType = 1;
    ballNum1 = 0;
    ballNum2 = 0;
    ballNum3 = 0;
    ballNum4 = 0;
    ballNum5 = 0;
    
    gameActive = false;
    tutorialMode = false;
}

//Discarded drawRect function
-(void) drawRect: (CGRect) rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor * redColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    
    CGContextSetFillColorWithColor(context, redColor.CGColor);
    CGContextFillRect(context, self.frame);
}




@end

