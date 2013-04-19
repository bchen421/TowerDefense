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
-(void)spawnMonster:(MonsterID)monsterID atLocation:(CGPoint)location
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    MonsterObject *testMonster = [[GameManager sharedManager] spawnMonster:monsterID];
    [testMonster setPosition:ccp( location.x, location.y )];
    
    [_sceneSpriteBatchNode addChild:testMonster z:100];
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
        [self addChild:_sceneSpriteBatchNode z:1];
        
        //[self scheduleUpdate];
        [_gameplayLayer scheduleUpdate];
        
        [self spawnMonster:kOrc atLocation:CGPointMake(0, 0)];
    }
    
    return self;
}

@end
