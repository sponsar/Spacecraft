//
//  GameScene.m
//
//  Created by : 黄 信尧
//  Project    : DaFeiJi
//  Date       : 2/22/16
//
//  Copyright (c) 2016 黄 信尧.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "GameScene.h"
#import "OverScene.h"
#define SPEEDOFSCENE1 0.001
#define SPEEDOFSCENE2 0.007

// -----------------------------------------------------------------

@implementation GameScene{
    CCSprite *_background1, *_background2;
    CCSprite *_boat;
    CGSize _screenSize;
    NSMutableArray *_rocksArray;
    double _rockSpeed;
    double _xOfLastRock1;
    double _xOfLastRock2;
    BOOL _crash;
}

// -----------------------------------------------------------------

+ (instancetype)node
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    
    _screenSize = [CCDirector sharedDirector].viewSize;
    _rocksArray = [[NSMutableArray alloc] init];
    _score = 0;
    //_rockSpeed = 0.008;
    _crash = NO;
    self.over = NO;
    _beginTime = [NSDate date];
    _record = [self loadRecord];
    _breakRecord = NO;
    
    self.userInteractionEnabled = YES;
    
    // Background1
    _background1 = [CCSprite spriteWithImageNamed:@"universe.jpg"];
    _background1.scale = 0.5;
    _background1.positionType = CCPositionTypeNormalized;
    _background1.position = (CGPoint){0.5, 0.5};
    [self addChild:_background1];
    
    // Background2
    _background2 = [CCSprite spriteWithImageNamed:@"universe.jpg"];
    _background2.scale = 0.5;
    _background2.positionType = CCPositionTypeNormalized;
    _background2.position = (CGPoint){0.5, 1.5};
    [self addChild:_background2];
    
    // firstTwoRocks
    CCSprite *rock1 = [CCSprite spriteWithImageNamed:@"rock.png"];
    rock1.scale = 0.4;
    rock1.positionType = CCPositionTypeNormalized;
    CCSprite *rock2 = [CCSprite spriteWithImageNamed:@"rock.png"];
    rock2.scale = 0.4;
    rock2.positionType = CCPositionTypeNormalized;
    
    rock1.rotation = (arc4random() % 40);
    rock1.rotationalSkewY = (arc4random() % 20);
    
    rock2.rotation = (arc4random() % 40);
    rock2.rotationalSkewY = (arc4random() % 20);
    
    int rockPosition1, rockPosition2;
    rockPosition1 = arc4random() % 3;
    while ((rockPosition2 = (arc4random() % 3)) == rockPosition1);
    _xOfLastRock1 = [self convertForMid:rockPosition1];
    _xOfLastRock2 = [self convertForMid:rockPosition2];
    rock1.position = CGPointMake(_xOfLastRock1, 1.1);
    rock2.position = CGPointMake(_xOfLastRock2, 1.1);
    [self addChild:rock1];
    [self addChild:rock2];
    [_rocksArray addObject:rock1];
    [_rocksArray addObject:rock2];
    
    // boat
    _boat = [CCSprite spriteWithImageNamed:@"boat3.png"];
    _boat.scale = 0.2;
    _boat.positionType = CCPositionTypeNormalized;
    _boat.position = (CGPoint){0.5, 0.1};
    [self addChild:_boat];
    
    // score
    _scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%lu", (unsigned long)_score] fontName:nil fontSize:20];
    _scoreLabel.positionType = CCPositionTypeNormalized;
    _scoreLabel.position = (CGPoint){0.5, 0.98};
    _scoreLabel.color = [CCColor whiteColor];
    [self addChild:_scoreLabel];
    
    return self;
}

// -----------------------------------------------------------------

-(void)update:(CCTime)delta
{
    

    if (!self.over)
    {
        _background1.position = CGPointMake(0.5, _background1.position.y - SPEEDOFSCENE1);
        _background2.position = CGPointMake(0.5, _background2.position.y - SPEEDOFSCENE1);
        if (_background1.position.y < -0.49) _background1.position = CGPointMake(0.5, 1.5);
        if (_background2.position.y < -0.49) _background2.position = CGPointMake(0.5, 1.5);
        
        if (![self crash])//碰撞前
        {
            _score = [[NSDate date] timeIntervalSinceDate:_beginTime];
            
            _scoreLabel.string = [NSString stringWithFormat:@"%lu", (unsigned long)_score];
            if (_score > _record) _scoreLabel.color = [CCColor redColor];
            
            _rockSpeed = (_score / 5) * 0.001 + 0.008;
            
            //当速度达到0.02的时候停止加速
            if (_rockSpeed > 0.025) _rockSpeed = 0.025;
            
            //遍历数组，把所有石头往下移
            for (CCSprite *rock in _rocksArray)
            {
                rock.position = CGPointMake(rock.position.x, rock.position.y - _rockSpeed);
            }
            
            //如果石头在下方消失了，remove这个石头
            CCSprite *rock = [_rocksArray firstObject];
            if (rock.position.y < -0.1)
            {
                [_rocksArray removeObjectAtIndex:0];
                [self removeChild:rock cleanup:YES];
                rock = [_rocksArray firstObject];
                [_rocksArray removeObjectAtIndex:0];
                [self removeChild:rock cleanup:YES];
            }
            
            //当最上一批石头出现的时候，制造下一批石头
            rock = [_rocksArray lastObject];
            if (rock.position.y<1)
                [self rocksCreate];
        }
        else//碰撞后，提示页面出现，只出现一次
        {
            [[OALSimpleAudio sharedInstance] playBg:@"killed.wav"];
            self.over = YES;
        }
    }
    else
    {
        _background1.position = CGPointMake(0.5, _background1.position.y - SPEEDOFSCENE2);
        _background2.position = CGPointMake(0.5, _background2.position.y - SPEEDOFSCENE2);
        if (_background1.position.y < -0.49) _background1.position = CGPointMake(0.5, 1.5);
        if (_background2.position.y < -0.49) _background2.position = CGPointMake(0.5, 1.5);
    }
}

- (void)setOver:(BOOL)over
{
    if (over)
    {
        self.userInteractionEnabled = NO;
        _scoreLabel.visible = NO;
        if (_score > _record)
        {
            _breakRecord = YES;
            _record = _score;
            [self saveRecord:_record];
        }
        OverScene *temp = [[OverScene alloc] init];
        temp.game = self;
        [temp showLabel];
        [self addChild:temp];//加了这个之后抓取频率下降
    }
    _over = over;
}

- (void)rocksCreate
{
    CCSprite *rock1 = [CCSprite spriteWithImageNamed:@"rock.png"];
    rock1.scale = 0.4;
    rock1.positionType = CCPositionTypeNormalized;
    CCSprite *rock2 = [CCSprite spriteWithImageNamed:@"rock.png"];
    rock2.scale = 0.4;
    rock2.positionType = CCPositionTypeNormalized;
    
    rock1.rotation = (arc4random() % 40);
    rock1.rotationalSkewY = (arc4random() % 20);
    
    rock2.rotation = (arc4random() % 40);
    rock2.rotationalSkewY = (arc4random() % 20);
    
    //分三种情况讨论
    if (_xOfLastRock1 == 0.2 && _xOfLastRock2 == 0.8)//如果上一轮陨石在左右
    {
        if (![self oneOutOfTen])//继续放在左右
        {
            if ([self oneOutOfTwo])
            {
                _xOfLastRock1 = 0.2;
                _xOfLastRock2 = 0.5;
            }
            else
            {
                _xOfLastRock1 = 0.5;
                _xOfLastRock2 = 0.8;
            }
        }
    }
    else if (_xOfLastRock1 == 0.2 && _xOfLastRock2 == 0.5)//左中
    {
        if (![self oneOutOfTen])
        {
            _xOfLastRock1 = 0.2;
            _xOfLastRock2 = 0.8;
        }
    }
    else//中右
    {
        if (![self oneOutOfTen])
        {
            _xOfLastRock1 = 0.2;
            _xOfLastRock2 = 0.8;
        }
    }
    rock1.position = CGPointMake(_xOfLastRock1, 1.3);
    rock2.position = CGPointMake(_xOfLastRock2, 1.3);
    [self addChild:rock1];
    [self addChild:rock2];
    [_rocksArray addObject:rock1];
    [_rocksArray addObject:rock2];
}

- (double)convertForMid:(int)rockPosition
{
    if (rockPosition == 0) return 0.2;
    else if (rockPosition == 1) return 0.5;
    else return 0.8;
}

- (BOOL)oneOutOfTen//十分之一概率
{
    if (arc4random() % 10 == 0) return YES;
    else return NO;
}

- (BOOL)oneOutOfTwo//二分之一概率
{
    if (arc4random() % 2 == 0) return YES;
    else return NO;
}

- (BOOL)crash
{
    if (!_crash)
    {
        for (CCSprite *rock in _rocksArray)
        {
            if ((rock.position.y - 0.03 < _boat.position.y + 0.03) && (rock.position.y + 0.03 > _boat.position.y - 0.03) && (rock.position.x == _boat.position.x))
            {
                _crash = YES;
                 CCSprite *explode = [CCSprite spriteWithImageNamed:@"explode.png"];
                 explode.scale = 0.2;
                 explode.positionType = CCPositionTypeNormalized;
                 explode.position = CGPointMake(_boat.position.x, _boat.position.y);
                 [self addChild:explode];
            }
        }
    }
    return _crash;
}

- (NSString *)filePathOfRecord//statusArray
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
            stringByAppendingPathComponent:@"record"];
}

- (void)saveRecord:(NSUInteger)record
{
    NSNumber *num = [NSNumber numberWithUnsignedInteger:record];
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject: num];
    [encodedData writeToFile:[self filePathOfRecord] atomically:YES];
}

- (NSUInteger)loadRecord
{
    NSData* decodedData = [NSData dataWithContentsOfFile: [self filePathOfRecord]];
    if (decodedData)
    {
        return [[NSKeyedUnarchiver unarchiveObjectWithData:decodedData] unsignedIntegerValue];//NSUInteger
    }
    else
    {
        return 0;
    }
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event//这个方法属于父类，override这个方法
{
    CGPoint point = [touch locationInWorld];
    // 判断点击左还是右
    if (point.x / _screenSize.width < 0.5)//左
    {
        CCLOG(@"left");
        if (_boat.position.x > 0.5) _boat.position = CGPointMake(0.5, 0.1);
        else if (_boat.position.x == 0.5) _boat.position = CGPointMake(0.2, 0.1);
    }
    else//右
    {
        CCLOG(@"right");
        if (_boat.position.x < 0.5) _boat.position = CGPointMake(0.5, 0.1);
        else if (_boat.position.x == 0.5) _boat.position = CGPointMake(0.8, 0.1);
    }
}

@end




















