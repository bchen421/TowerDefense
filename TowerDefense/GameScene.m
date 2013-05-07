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

@synthesize tileMap=_tileMap, backgroundLayer=_backgroundLayer, metadataLayer=_metadataLayer, objectData=_objectData, gameUILayer=_gameUILayer;
@synthesize startLocation01 = _startLocation01, goalLocation01 = _goalLocation01, sceneSpriteBatchNode = _sceneSpriteBatchNode, towerNodes = _towerNodes;

#pragma mark - Metadata Management
-(CGPoint)tileMapCoordForPosition:(CGPoint)position
{
    CCLOG(@"STUB METHOD");
    return ccp(0,0);
}

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
