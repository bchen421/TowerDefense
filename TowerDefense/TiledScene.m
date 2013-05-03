//
//  TiledScene.m
//  TowerDefense
//
//  Created by Benjamin Chen on 5/1/13.
//
//

#import "TiledScene.h"
#import "GameUILayer.h"
#import "GameManager.h"

@implementation TiledScene
@synthesize tileMap=_tileMap, backgroundLayer=_backgroundLayer, metadata=_metadata, gameUILayer=_gameUILayer;

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

#pragma mark - Metadata Management
-(CGPoint)locationForMetadataObject:(NSString *)metadataObject
{
    BOOL retinaEnabled = [[[[self metadata] properties] valueForKey:@"retina"] boolValue];

    NSDictionary *dict = [[self metadata] objectNamed:metadataObject];
    int width = [[dict valueForKey:@"width"] integerValue];
    int height = [[dict valueForKey:@"height"] integerValue];
    int x = [[dict valueForKey:@"x"] integerValue];
    int y = [[dict valueForKey:@"y"] integerValue];
    
    if (!retinaEnabled)
    {
        return ccp(x + width/2,y + height/2);
    }
    else
    {
        return ccp(x/2 + width/4, y/2 + height/4);
    }
}

-(void)setupTowerNodes
{
    int numberOfTowers = [[[[self metadata] properties] valueForKey:@"numberOfTowers"] integerValue];
    BOOL retinaEnabled = [[[[self metadata] properties] valueForKey:@"retina"] boolValue];
    
    NSDictionary *dict;

    for (int i = 1; i <= numberOfTowers; i++)
    {
        dict = [[self metadata] objectNamed:[NSString stringWithFormat:@"towerSpawnPoint0%i",i]];
        CGRect towerBox = CGRectMake([[dict valueForKey:@"x"] floatValue], [[dict valueForKey:@"y"] floatValue], [[dict valueForKey:@"width"] floatValue], [[dict valueForKey:@"height"] floatValue]);
        if (retinaEnabled)
        {
            towerBox.size.width = towerBox.size.width/2.0;
            towerBox.size.height = towerBox.size.height/2.0;
            towerBox.origin.x = towerBox.origin.x / 2.0;
            towerBox.origin.y = towerBox.origin.y / 2.0;
        }
        [_towerNodes addObject:[NSValue valueWithCGRect:towerBox]];
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
        //_startLocation01 = CGPointMake(screenSize.width/2, screenSize.height - 25.0);
        //_goalLocation01 = CGPointMake(screenSize.width/2, 0);
        
        // Setup gameplay and metadata
        _tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"tilemap.tmx"];
        [self addChild:_tileMap z:0];
        _backgroundLayer = [[self tileMap] layerNamed:@"Background"];
        _metadata = [[self tileMap] objectGroupNamed:@"Metadata"];
        _towerNodes = [[NSMutableArray alloc] init];
        [self setupTowerNodes];
        
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
        [self spawnMonster:kOrc atLocation:[self locationForMetadataObject:@"spawnPoint01"] withGoalLocation:[self locationForMetadataObject:@"goalPoint01"]];
        //[self spawnMonster:kOrc atLocation:CGPointMake(screenSize.width/2, screenSize.height) withGoalLocation:CGPointMake(screenSize.width/2, 0)];
        //[self spawnMonster:kBigOrc atLocation:CGPointMake(screenSize.width/2.0 - 75.0, screenSize.height - 25.0) withGoalLocation:CGPointMake(screenSize.width/2 - 75.0, screenSize.height/2.0)];
    }
    
    return self;
}


@end
