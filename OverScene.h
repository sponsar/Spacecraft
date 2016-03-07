//
//  OverScene.h
//
//  Created by : 黄 信尧
//  Project    : DaFeiJi
//  Date       : 2/27/16
//
//  Copyright (c) 2016 黄 信尧.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "GameScene.h"

// -----------------------------------------------------------------

@interface OverScene : CCNodeColor

// -----------------------------------------------------------------
// properties
@property (nonatomic, strong) GameScene *game;

// -----------------------------------------------------------------
// methods

+ (instancetype)node;
//- (instancetype)initWithScore:(NSUInteger)score andRecord:(NSUInteger)record breakRecord:(BOOL)breakRecord;
- (instancetype)init;
- (void)showLabel;

// -----------------------------------------------------------------

@end




