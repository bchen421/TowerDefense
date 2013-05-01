//
//  TiledScene.m
//  TowerDefense
//
//  Created by Benjamin Chen on 5/1/13.
//
//

#import "TiledScene.h"
#import "GameUILayer.h"

@implementation TiledScene
@synthesize tiledLayer=_tiledLayer,gameUILayer=_gameUILayer;


#pragma mark - Initialization
-(id)init
{
    self = [super init];
    if (self)
    {
        // Setup Default Start and End Locations
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        CCLOG(@"Screen Width: %g Height: %g", screenSize.width, screenSize.height);
        //_startLocation01 = CGPointMake(screenSize.width/2, screenSize.height - 25.0);
        //_goalLocation01 = CGPointMake(screenSize.width/2, 0);
        
        // Setup gameplay layer
        _tiledLayer = [CCTMXTiledMap tiledMapWithTMXFile:@"tilemap.tmx"];
        [self addChild:_tiledLayer z:0];
        
        // Setup UI layer
        _gameUILayer = [GameUILayer node];
        [self addChild:_gameUILayer z:2];
        
        // Setup Sprite Atlas for gameplay layer
        [[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFramesWithFile:@"sandboxAtlas.plist"];
        _sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"sandboxAtlas.png"];
        [self addChild:_sceneSpriteBatchNode z:1];
        
        // Schedule updates for this scene
        //[self scheduleUpdate];
        
        // Temp location for monster pawning for now
        //[self spawnMonster:kOrc atLocation:[self startLocation01] withGoalLocation:[self goalLocation01]];
        //[self spawnMonster:kOrc atLocation:CGPointMake(screenSize.width/2 - 50.0, screenSize.height - 25.0) withGoalLocation:CGPointMake(screenSize.width/2 - 50.0, 0)];
        //[self spawnMonster:kBigOrc atLocation:CGPointMake(screenSize.width/2.0 - 75.0, screenSize.height - 25.0) withGoalLocation:CGPointMake(screenSize.width/2 - 75.0, screenSize.height/2.0)];
    }
    
    return self;
}


@end
