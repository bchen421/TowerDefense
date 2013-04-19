//
//  SandboxScene.m
//  TowerDefense
//
//  Created by Benjamin Chen on 4/17/13.
//
//

#import "SandboxScene.h"
#import "SandboxLayer.h"
#import "GameManager.h"

@implementation SandboxScene
@synthesize gameplayLayer = _gameplayLayer, sceneSpriteBatchNode = _sceneSpriteBatchNode;

#pragma mark - Monster Spawning
-(void)spawnMonster:(MonsterID)monsterID
{
    
}


#pragma mark - Initialization
-(id)init
{
    self = [super init];
    if (self)
    {
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        _gameplayLayer = [SandboxLayer node];
        [self addChild:_gameplayLayer];
        
        
        [[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFramesWithFile:@"sandboxAtlas.plist"];
        _sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"sandboxAtlas.png"];
        [self addChild:_sceneSpriteBatchNode z:0];
        
        MonsterObject *testMonster = [[GameManager sharedManager] spawnMonster:kOrc];
        [testMonster setPosition:ccp( (screenSize.width / 2), (screenSize.height / 2) )];
        
        [_sceneSpriteBatchNode addChild:testMonster z:100];
        
        //[self scheduleUpdate];
        [_gameplayLayer scheduleUpdate];
    }
    
    return self;
}

@end
