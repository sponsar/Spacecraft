//
//  OverScene.m
//
//  Created by : 黄 信尧
//  Project    : DaFeiJi
//  Date       : 2/27/16
//
//  Copyright (c) 2016 黄 信尧.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "OverScene.h"
#import "GameScene.h"

// -----------------------------------------------------------------

@implementation OverScene

// -----------------------------------------------------------------

+ (instancetype)node
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super initWithColor:[CCColor colorWithRed:0 green:0 blue:0 alpha:0.3]];//size自动是windows size
    //self.userInteractionEnabled = YES;
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    
    return self;
}

- (void)clickStartButton
{
    [[CCDirector sharedDirector] presentScene:[GameScene new]];
}

- (void)showLabel
{
    // score
    CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%lu", (unsigned long)_game.score] fontName:@"ArialMT" fontSize:50];//这个弄粗一点
    scoreLabel.color = [CCColor whiteColor];
    scoreLabel.positionType = CCPositionTypeNormalized;
    scoreLabel.position = (CGPoint){0.5, 0.8};
    [self addChild:scoreLabel];
    
    // record
    CCLabelTTF *recordLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"BEST %lu", (unsigned long)_game.record] fontName:@"ArialMT" fontSize:33];//这个弄细一点
    recordLabel.color = [CCColor whiteColor];
    recordLabel.positionType = CCPositionTypeNormalized;
    recordLabel.position = (CGPoint){0.5, 0.7};
    [self addChild:recordLabel];
    
    if (_game.breakRecord) recordLabel.string = [NSString stringWithFormat:@"NEW RECORD"];
    
    // startButton
    CCButton *start = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"start.png"]];
    //start.scale = 1;
    start.positionType = CCPositionTypeNormalized;
    start.position = (CGPoint){0.5, 0.5};
    [start setTarget:self selector:@selector(clickStartButton)];
    [self addChild:start];
}

// -----------------------------------------------------------------

@end





