//
//  TiledScene.m
//  TowerDefense
//
//  Created by Benjamin Chen on 5/1/13.
//
//

#import "TiledScene.h"
#import "GameManager.h"
#import "GameUILayer.h"

@implementation TiledScene

#pragma mark - Scene Update Management
-(void)update:(ccTime)deltaTime
{
    CCArray *listOfGameObjects = [_sceneSpriteBatchNode children];
    GameObject *tempObject;
    CCARRAY_FOREACH(listOfGameObjects, tempObject)
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
        CCLOG(@"Screen Width: %g Height: %g", screenSize.width, screenSize.height);
        
        // Setup gameplay and metadata
        _tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"tilemap.tmx"];
        [self addChild:_tileMap z:0];
        _backgroundLayer = [[self tileMap] layerNamed:@"background"];
        _metadataLayer = [[self tileMap] layerNamed:@"metadata"];
        _objectData = [[self tileMap] objectGroupNamed:@"objectData"];
        
        // Setup UI layer
        _gameUILayer = [GameUILayer node];
        [self addChild:_gameUILayer z:2];
        
        // Setup Sprite Atlas for gameplay layer
        [[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFramesWithFile:@"sandboxAtlas.plist"];
        _sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"sandboxAtlas.png"];
        [self addChild:_sceneSpriteBatchNode z:1];
        
        // Schedule updates for this scene
        [self scheduleUpdate];
                
        // Temp location for monster pawning for now
        [self spawnMonster:kOrc atLocation:[self locationForDataObject:@"spawnPoint1"] withGoalLocation:[self locationForDataObject:@"goalPoint1"]];
        //[self spawnMonster:kOrc atLocation:CGPointMake(screenSize.width/2, screenSize.height) withGoalLocation:CGPointMake(screenSize.width/2, 0)];
        //[self spawnMonster:kBigOrc atLocation:CGPointMake(screenSize.width/2.0 - 75.0, screenSize.height - 25.0) withGoalLocation:CGPointMake(screenSize.width/2 - 75.0, screenSize.height/2.0)];
    }
    
    return self;
}


@end
