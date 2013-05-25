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

#pragma mark - Scene Management
-(void)onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
    
    // Setup UI layer
    _gameUILayer = [GameUILayer node];
    [self addChild:_gameUILayer z:2];
    
    // Schedule updates for this scene
    [self scheduleUpdate];
    
    // Temp location for monster pawning for now
    //[self spawnMonster:kOrc atLocation:[self locationForDataObject:@"spawnPoint1"] onPath:@"walkableA"];
    //[self spawnMonster:kOrc atLocation:[self locationForDataObject:@"spawnPoint1"] onPath:@"walkableB"];
    [self performSelector:@selector(spawnMonsterFromDictionary:) withObject:nil afterDelay:1.0f];
    [self performSelector:@selector(spawnMonsterFromDictionary:) withObject:nil afterDelay:5.0f];
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
        
        // Setup Sprite Atlas for gameplay layer
        [[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFramesWithFile:@"sandboxAtlas.plist"];
        _sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"sandboxAtlas.png"];
        [self addChild:_sceneSpriteBatchNode z:1];
    }
    
    return self;
}


@end
