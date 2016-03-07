//
//  GameScene.h
//
//  Created by : 黄 信尧
//  Project    : DaFeiJi
//  Date       : 2/22/16
//
//  Copyright (c) 2016 黄 信尧.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"

// -----------------------------------------------------------------

@interface GameScene : CCScene

// -----------------------------------------------------------------
// properties
@property (nonatomic) BOOL breakRecord;
@property (nonatomic) NSUInteger score;
@property (nonatomic) NSUInteger record;
@property (nonatomic, strong) NSDate *beginTime;

@property (nonatomic) BOOL over;
@property (nonatomic, strong) CCLabelTTF *scoreLabel;

// -----------------------------------------------------------------
// methods

+ (instancetype)node;
- (instancetype)init;

// -----------------------------------------------------------------

@end




