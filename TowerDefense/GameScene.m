//
//  GameScene.m
//  TowerDefense
//
//  Created by Benjamin Chen on 4/23/13.
//
//

#import "GameScene.h"

#import "GameManager.h"

@implementation GameScene
@synthesize startLocation01 = _startLocation01, goalLocation01 = _goalLocation01, sceneSpriteBatchNode = _sceneSpriteBatchNode;

#pragma mark - Monster Spawning
-(void)spawnMonster:(MonsterID)monsterID atLocation:(CGPoint)startLocation withGoalLocation:(CGPoint)endLocation
{
    MonsterObject *testMonster = [[GameManager sharedManager] spawnMonster:monsterID withGoalLocation:endLocation];
    [testMonster setPosition:startLocation];
    
    [[self sceneSpriteBatchNode] addChild:testMonster z:20];
}

#pragma mark - Initialization
-(id)init
{
    self = [super init];
    if (self)
    {
        _startLocation01 = CGPointMake(0.0, 0.0);
        _goalLocation01 = CGPointMake(0.0, 0.0);
        _sceneSpriteBatchNode = nil;
    }
    
    return self;
}

@end
