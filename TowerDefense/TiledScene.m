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
    //_timeInLevel += deltaTime;
    //[self displaySecs:_timeInLevel];
    CCArray *listOfGameObjects = [_sceneSpriteBatchNode children];
    GameObject *tempObject;
    CCARRAY_FOREACH(listOfGameObjects, tempObject)
    {
        [tempObject updateStateWithDeltaTime:deltaTime andListOfGameObjects:listOfGameObjects];
    }
}

-(void)gameTime
{
    _timeInLevel += 0.1f;
    [self displaySecs:_timeInLevel];
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
    [self schedule:@selector(gameTime) interval:0.1f];
    
    // Temp mob spawn
    //[self spawnMonsterOnPath:@"walkableA"];
    //[self spawnMonster:kOrc atLocation:[self locationForDataObject:@"spawnPoint1"] onPath:@"walkableB"];
    
    // Load plist data
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"TiledScene" ofType:@"plist"];
    _mobSpawns = [NSMutableArray arrayWithContentsOfFile:plistPath];
    //NSLog(@"ARRAY DATA: %@", [[self mobSpawns] description]);
    
    // Temp Location for mob loading
    [self checkAndLoadMobSpawns];
}

- (void)displaySecs:(float)secs {
    double intPart = 0;
    double fractPart = modf(secs, &intPart);
    int isecs = (int)intPart;
    int min = isecs / 60;
    int sec = isecs % 60;
    int hund = (int) (fractPart * 100);
    [_label setString:[NSString stringWithFormat:@"%02d:%02d:%02d",
                      min, sec, hund]];
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
        
        // Timer Test code
        _label = [CCLabelTTF labelWithString:@"" fontName:@"AmericanTypewriter-Bold" fontSize:40.0];
        _label.anchorPoint = ccp(1, 1);
        _label.position = ccp(screenSize.width - 20, screenSize.height - 20);
        [self addChild:_label];
        
        /* PList sample code
         NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"TowersPosition" ofType:@"plist"];
         NSArray * towerPositions = [NSArray arrayWithContentsOfFile:plistPath];
         towerBases = [[NSMutableArray alloc] initWithCapacity:10];
         
         for(NSDictionary * towerPos in towerPositions)
         {
         CCSprite * towerBase = [CCSprite spriteWithFile:@"open_spot.png"];
         [self addChild:towerBase];
         [towerBase setPosition:ccp([[towerPos objectForKey:@"x"] intValue],[[towerPos objectForKey:@"y"] intValue])];
         [towerBases addObject:towerBase];
         }
        */
    }
    
    return self;
}


@end
