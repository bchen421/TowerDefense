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
@synthesize gameplayLayer = _gameplayLayer;

#pragma mark - Scene Update Management
-(void)update:(ccTime)deltaTime
{
    CCArray *listOfGameObjects = [_sceneSpriteBatchNode children];
    for (MonsterObject *tempObject in listOfGameObjects)
    {
        [tempObject updateStateWithDeltaTime:deltaTime andListOfGameObjects:listOfGameObjects];
    }
}

#pragma mark - Initialization
-(id)init
{
    self = [super init];
    if (self)
    {
        // Setup Default Start and End Locations
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        _startLocation01 = CGPointMake(screenSize.width/2, screenSize.height - 25.0);
        _goalLocation01 = CGPointMake(screenSize.width/2, 0);
        
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
        [self spawnMonster:kOrc atLocation:[self startLocation01] withGoalLocation:[self goalLocation01]];
        [self spawnMonster:kOrc atLocation:CGPointMake(screenSize.width/2 - 50.0, screenSize.height - 25.0) withGoalLocation:CGPointMake(screenSize.width/2 - 50.0, 0)];
        [self spawnMonster:kBigOrc atLocation:CGPointMake(screenSize.width/2 - 75.0, screenSize.height - 25.0) withGoalLocation:CGPointMake(screenSize.width/2 - 75.0, 0)];
    }
    
    return self;
}

@end
