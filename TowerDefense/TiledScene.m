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
    [self checkAndLoadMobSpawns];
    _spawnTimer += deltaTime;
    [self displaySecs:_spawnTimer];

}

-(void)gameTime
{
    [self checkAndLoadMobSpawns];
    _spawnTimer += 0.1f;
    [self displaySecs:_spawnTimer];
}

#pragma mark - Scene Management
-(void)onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
        
    // Setup UI layer
    _gameUILayer = [GameUILayer node];
    [self addChild:_gameUILayer z:2];
    
    // Load plist data
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"TiledScene" ofType:@"plist"];
    [_mobSpawns addObjectsFromArray:[NSMutableArray arrayWithContentsOfFile:plistPath]];
    
    // Schedule updates for this scene
    [self scheduleUpdate];
    //[self schedule:@selector(gameTime) interval:0.1f];
    
    // Start Mob Spawning
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
        
        // Setup static background image
        CCSprite *background = [CCSprite spriteWithFile:@"background.png"];
        [background setPosition:ccp(screenSize.width/2, screenSize.height/2)];
        [self addChild:background z:0];
        
        // Setup gameplay and metadata
        _tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"tilemap.tmx"];
        [self addChild:_tileMap z:1];
        _backgroundLayer = [[self tileMap] layerNamed:@"background"];
        _metadataLayer = [[self tileMap] layerNamed:@"metadata"];
        _objectData = [[self tileMap] objectGroupNamed:@"objectData"];
        
        // Setup Sprite Atlas for gameplay layer
        [[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFramesWithFile:@"sandboxAtlas.plist"];
        _sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"sandboxAtlas.png"];
        [_tileMap addChild:_sceneSpriteBatchNode z:100];
        
        // Timer Test code
        _label = [CCLabelTTF labelWithString:@"" fontName:@"AmericanTypewriter-Bold" fontSize:40.0];
        _label.anchorPoint = ccp(1, 1);
        _label.position = ccp(screenSize.width - 20, screenSize.height - 20);
        [self addChild:_label z:2];
        
        // Load Tower Nodes
        [self checkAndLoadTowerSpawns];
    }
    
    return self;
}


@end
