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
@synthesize startLocation = _startLocation, endLocation = _endLocation, sceneSpriteBatchNode = _sceneSpriteBatchNode, gameplayLayer = _gameplayLayer;

#pragma mark - Scene Update Management
-(void)update:(ccTime)deltaTime
{
    CCArray *listOfGameObjects = [_sceneSpriteBatchNode children];
    for (MonsterObject *tempObject in listOfGameObjects)
    {
        [tempObject updateStateWithDeltaTime:deltaTime andListOfGameObjects:listOfGameObjects];
    }
}

#pragma mark - Monster Spawning
-(void)spawnMonster:(MonsterID)monsterID atLocation:(CGPoint)location
{    
    MonsterObject *testMonster = [[GameManager sharedManager] spawnMonster:monsterID];
    [testMonster setPosition:location];
    
    [[self sceneSpriteBatchNode] addChild:testMonster z:10];
}


#pragma mark - Initialization
-(id)init
{
    self = [super init];
    if (self)
    {
        // Setup Default Start Location
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        _startLocation = CGPointMake(screenSize.width/2, screenSize.height - 100);
        
        // Setup layers in scene
        _gameplayLayer = [SandboxLayer node];
        [self addChild:_gameplayLayer z:0];
        
        // Setup Sprite Atlas for gameplay layer
        
        [[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFramesWithFile:@"sandboxAtlas.plist"];
        _sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"sandboxAtlas.png"];
        [self addChild:_sceneSpriteBatchNode z:10];
        
        // Schedule updates for this scene
        [self scheduleUpdate];
        
        // Temp location for monster spawning for now
        [self spawnMonster:kOrc atLocation:self.startLocation];
    }
    
    return self;
}

@end
