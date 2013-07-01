//
//  GameScene.m
//  TowerDefense
//
//  Created by Benjamin Chen on 4/23/13.
//
//

#import "GameScene.h"
#import "GameManager.h"
#import "GameUILayer.h"

@implementation GameScene

@synthesize tileMap = _tileMap, backgroundLayer = _backgroundLayer, metadataLayer = _metadataLayer, objectData = _objectData, gameUILayer = _gameUILayer, sceneSpriteBatchNode = _sceneSpriteBatchNode, mobSpawns = _mobSpawns;

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

#pragma mark - Tower Loading Management
-(void)checkAndLoadTowerSpawns
{
    BOOL retina = [[[[self tileMap] properties] valueForKey:@"retina"] boolValue];
    for (NSDictionary *tmxObject in [[self objectData] objects])
    {
        NSString *tmxObjectName = [tmxObject valueForKey:@"name"];
        if ([tmxObjectName isEqualToString:@"towerSpawn"])
        {
            float width = [[tmxObject valueForKey:@"width"] floatValue];
            float height = [[tmxObject valueForKey:@"height"] floatValue];
            int x = [[tmxObject valueForKey:@"x"] integerValue];
            int y = [[tmxObject valueForKey:@"y"] integerValue];
            CGPoint towerLocation;
            
            if (retina)
            {
                towerLocation = ccp((x/2.0) + (width/4.0), (y/2.0) + (height/4.0));
            }
            else
            {
                towerLocation = ccp(x + width/2.0, y + height/2.0);
            }
            
            [[GameManager sharedManager] spawnTower:kTowerNode forScene:self atLocation:towerLocation];
        }
    }
}

#pragma mark - Metadata Management
-(CGPoint)positionForTileCoord:(CGPoint)tileCoord
{
    CGPoint position = [[self backgroundLayer] positionAt:tileCoord];
    CGSize tileSize = [[self tileMap] tileSize];
    
    BOOL retina = [[[[self tileMap] properties] valueForKey:@"retina"] boolValue];
    
    if (retina)
    {
        return ccp(position.x + tileSize.width/4.0, position.y + tileSize.height/4.0);
    }
    else
    {
        return ccp(position.x + tileSize.width/2.0, position.y + tileSize.height/2.0);
    }
}

-(CGPoint)tileMapCoordForPosition:(CGPoint)position
{
    BOOL retina = [[[[self tileMap] properties] valueForKey:@"retina"] boolValue];
    if (!retina)
    {
        CGSize mapSize = [[self tileMap] mapSize];
        CGSize tileSize = [[self tileMap] tileSize];
        int x = position.x / tileSize.width;
        int y = ((mapSize.height * tileSize.height) - position.y) / tileSize.height;
        return ccp(x, y);
    }
    else
    {
        CGSize mapSize = [[self tileMap] mapSize];
        CGSize tileSize = [[self tileMap] tileSize];
        tileSize.width = tileSize.width / 2.0;
        tileSize.height = tileSize.height / 2.0;
        int x = position.x / tileSize.width;
        int y = ((mapSize.height * tileSize.height) - position.y) / tileSize.height;
        return ccp(x, y);
    }
}

-(CGPoint)locationForDataObject:(NSString *)dataObject
{
    BOOL retina = [[[[self tileMap] properties] valueForKey:@"retina"] boolValue];
    
    NSDictionary *dict = [[self objectData] objectNamed:dataObject];
    int width = [[dict valueForKey:@"width"] integerValue];
    int height = [[dict valueForKey:@"height"] integerValue];
    int x = [[dict valueForKey:@"x"] integerValue];
    int y = [[dict valueForKey:@"y"] integerValue];
    
    if (!retina)
    {
        return ccp(x + width/2,y + height/2);
    }
    else
    {
        return ccp(x/2 + width/4, y/2 + height/4);
    }
}

-(void)generateMobPaths
{
    CCLOG(@"GENERATING MOB PATHS");
    BOOL retina = [[[[self tileMap] properties] valueForKey:@"retina"] boolValue];
    for (NSDictionary *tmxObject in [[self objectData] objects])
    {
        NSString *tmxObjectName = [tmxObject valueForKey:@"name"];
        NSString *tmxObjectType = [tmxObject valueForKey:@"type"];
        if ([tmxObjectType isEqualToString:@"spawnPoint"])
        {
            CCLOG(@"FOUND SPAWNPOINT: %@", [tmxObject description]);
            CGPoint tilePosition = CGPointMake([[tmxObject valueForKey:@"x"] intValue], [[tmxObject valueForKey:@"y"] intValue]);
            if (retina)
            {
                tilePosition = ccp(tilePosition.x/2.0, tilePosition.y/2.0);
            }
            NSString *spawnPath;
            NSUInteger tileGID = [[self metadataLayer] tileGIDAt:[self tileMapCoordForPosition:tilePosition]];
            if (tileGID)
            {
                NSDictionary *properties = [[self tileMap] propertiesForGID:tileGID];
                if (properties)
                {
                    if ([[properties valueForKey:@"walkableA"] boolValue])
                    {
                        spawnPath = @"walkableA";
                    }
                    else if ([[properties valueForKey:@"walkableB"] boolValue])
                    {
                        spawnPath = @"walkableB";
                    }
                    else if ([[properties valueForKey:@"walkableC"] boolValue])
                    {
                        spawnPath = @"walkableC";
                    }
                }
                else
                {
                    spawnPath = nil;
                }
            }
            else
            {
                spawnPath = nil;
            }
            
            NSArray *pathArray = [self createTravelPathArrayFromStartingPoint:tilePosition andPathName:spawnPath];
            
            NSMutableDictionary *spawnInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
            [spawnInfo setObject:spawnPath forKey:@"spawnPath"];
            NSValue *tilePosValue = [NSValue valueWithCGPoint:tilePosition];
            [spawnInfo setObject:tilePosValue forKey:@"spawnPosition"];
            [spawnInfo setObject:pathArray forKey:@"pathArray"];
            
            
            [_mobPathingDict setObject:spawnInfo forKey:tmxObjectName];
        }
    }
}

-(NSArray *)createTravelPathArrayFromStartingPoint:(CGPoint)startingPoint andPathName:(NSString *)pathName
{
    NSValue *startingTile = [NSValue valueWithCGPoint:[self tileMapCoordForPosition:startingPoint]];
    CGPoint previousTile = ccp(-1,-1);
    
    NSMutableArray *pathArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSUInteger currentPathIndex = 0;
    
    [pathArray addObject:startingTile];
    BOOL doneCreating = NO;
    
    while (!doneCreating)
    {
        CGPoint currentTile = [[pathArray objectAtIndex:currentPathIndex] CGPointValue];
        NSValue *nextTile = [NSValue valueWithCGPoint:[self findNextMovableTileFromTile:currentTile andPreviousTile:previousTile withPathName:pathName]];
        if (CGPointEqualToPoint(ccp(-1.0, -1.0), [nextTile CGPointValue]))
        {
            doneCreating = YES;
        }
        else
        {
            [pathArray addObject:nextTile];
            previousTile = currentTile;
            currentPathIndex += 1;
        }
    }
    
    return (NSArray *)pathArray;
}

-(CGPoint)findNextMovableTileFromTile:(CGPoint)currentTile andPreviousTile:(CGPoint)previousTile withPathName:(NSString *)pathName
{
    CGPoint southTile = ccp(currentTile.x, currentTile.y + 1.0);
    CGPoint northTile = ccp(currentTile.x, currentTile.y - 1.0);
    CGPoint westTile = ccp(currentTile.x - 1.0, currentTile.y);
    CGPoint eastTile = ccp(currentTile.x + 1.0, currentTile.y);
    CGPoint southWestTile = ccp(currentTile.x - 1.0, currentTile.y + 1.0);
    CGPoint southEastTile = ccp(currentTile.x + 1.0, currentTile.y + 1.0);
    CGPoint northWestTile = ccp(currentTile.x - 1.0, currentTile.y - 1.0);
    CGPoint northEastTile = ccp(currentTile.x + 1.0, currentTile.y - 1.0);
    
    
    if ([self tileCoordIsMoveable:southTile forPath:pathName] && (!CGPointEqualToPoint(southTile, previousTile)))
        return southTile;
    else if ([self tileCoordIsMoveable:westTile forPath:pathName] && (!CGPointEqualToPoint(westTile, previousTile)))
        return westTile;
    else if ([self tileCoordIsMoveable:eastTile forPath:pathName] && (!CGPointEqualToPoint(eastTile, previousTile)))
        return eastTile;
    else if ([self tileCoordIsMoveable:northTile forPath:pathName] && (!CGPointEqualToPoint(northTile, previousTile)))
        return northTile;
    else if ([self tileCoordIsMoveable:southWestTile forPath:pathName] && (!CGPointEqualToPoint(southWestTile, previousTile)))
        return southWestTile;
    else if ([self tileCoordIsMoveable:southEastTile forPath:pathName] && (!CGPointEqualToPoint(southEastTile, previousTile)))
        return southEastTile;
    else if ([self tileCoordIsMoveable:northWestTile forPath:pathName] && (!CGPointEqualToPoint(northWestTile, previousTile)))
        return northWestTile;
    else if ([self tileCoordIsMoveable:northEastTile forPath:pathName] && (!CGPointEqualToPoint(northEastTile, previousTile)))
        return northEastTile;
    else
    {
        return ccp(-1.0, -1.0);
    }
}

-(BOOL)tileCoordIsMoveable:(CGPoint)coord forPath:(NSString *)pathName
{    
    // Check if coordinates are out of map bounds before grabbing tile GID
    CGSize mapSize = [[self tileMap] mapSize];
    if (coord.x < 0)
    {
        return NO;
    }
    else if (coord.x >= mapSize.width)
    {
        return NO;
    }
    if (coord.y < 0)
    {
        return NO;
    }
    else if (coord.y >= mapSize.height)
    {
        return NO;
    }
    
    // Grab tileGID from metadata layer and check if walkable by myself
    NSUInteger tileGID = [[self metadataLayer] tileGIDAt:coord];
    if (tileGID)
    {
        NSDictionary *properties = [[self tileMap] propertiesForGID:tileGID];
        if (properties)
        {
            return [[properties valueForKey:pathName] boolValue];
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
}

#pragma mark - Monster Spawning
-(void)deployFormation:(NSDictionary *)deployment
{
    NSString *formation = [deployment objectForKey:@"formation"];
    NSString *loc = [deployment objectForKey:@"loc"];
    NSString *locA = [loc stringByAppendingFormat:@"a"];
    NSString *locB = [loc stringByAppendingFormat:@"b"];
    NSString *locC = [loc stringByAppendingFormat:@"c"];
        
    if ([formation isEqualToString:@"tripleOrc"])
    {
        _nextMonsterID = kOrc;
        float delay = 0.5;
                
        CCAction *spawnAction = [CCSequence actions:[CCCallFuncO actionWithTarget:self selector:@selector(spawnNextMonsterAtLocation:) object:locA], [CCDelayTime actionWithDuration:delay], [CCCallFuncO actionWithTarget:self selector:@selector(spawnNextMonsterAtLocation:) object:locB], [CCDelayTime actionWithDuration:delay], [CCCallFuncO actionWithTarget:self selector:@selector(spawnNextMonsterAtLocation:) object:locC], nil];
        [self runAction:spawnAction];
    }
    else if ([formation isEqualToString:@"triangleOrcs"])
    {
        _nextMonsterID = kOrc;
        float delay = 0.5;
        
        CCAction *spawnAction = [CCSequence actions:[CCCallFuncO actionWithTarget:self selector:@selector(spawnNextMonsterAtLocation:) object:locB], [CCDelayTime actionWithDuration:delay], [CCCallFuncO actionWithTarget:self selector:@selector(spawnNextMonsterAtLocation:) object:locA], [CCCallFuncO actionWithTarget:self selector:@selector(spawnNextMonsterAtLocation:) object:locC], nil];
        [self runAction:spawnAction];
    }
    else if ([formation isEqualToString:@"singleOrc"])
    {
        _nextMonsterID = kOrc;
        [self spawnNextMonsterAtLocation:locA];
    }
}

-(void)spawnNextMonsterAtLocation:(NSString *)location
{
    MonsterObject *newMonster = [[GameManager sharedManager] spawnMonster:_nextMonsterID];
    [newMonster setPosition:[self locationForDataObject:location]];
    
    [[self sceneSpriteBatchNode] addChild:newMonster z:20];
}

-(void)checkAndLoadMobSpawns
{
    if (_currentWave >= [_mobSpawns count])
    {
        return;
    }
        
    NSDictionary *nextSpawn = [_mobSpawns objectAtIndex:_currentWave];
    float loadTime = [[nextSpawn objectForKey:@"time"] floatValue];
    
    if (_spawnTimer >= loadTime)
    {
        [self deployFormation:nextSpawn];
        _currentWave += 1;
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
    //[self schedule:@selector(gameTime) interval:0.1f];
    
    // Setup Mob Pathing Array
    _mobPathingDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [self generateMobPaths];
    NSLog(@"%@", [_mobPathingDict description]);
    
    // Start Mob Spawning
    [self checkAndLoadMobSpawns];
}

#pragma mark - Gamescene Designated Parameterized Initializer
-(id)initWithTileMap:(NSString *)map spriteAtlas:(NSString *)spriteAtlas andMobs:(NSString *)mobs
{
    self = [super init];
    if (self)
    {
        NSString *mapTMX = [map stringByAppendingFormat:@".tmx"];
        NSString *spriteAtlasPlist = [spriteAtlas stringByAppendingFormat:@".plist"];
        NSString *spriteAtlasPng = [spriteAtlas stringByAppendingFormat:@".png"];

        // Setup Default Start and End Locations
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        CCLOG(@"Screen Width: %g Height: %g", screenSize.width, screenSize.height);
        
        // Setup static background image
        CCSprite *background = [CCSprite spriteWithFile:@"background.png"];
        [background setPosition:ccp(screenSize.width/2, screenSize.height/2)];
        [self addChild:background z:0];
        
        // Setup gameplay and metadata
        _tileMap = [CCTMXTiledMap tiledMapWithTMXFile:mapTMX];
        [self addChild:_tileMap z:1];
        _backgroundLayer = [[self tileMap] layerNamed:@"background"];
        _metadataLayer = [[self tileMap] layerNamed:@"metadata"];
        _objectData = [[self tileMap] objectGroupNamed:@"objectData"];
        
        // Setup Sprite Atlas for gameplay layer
        [[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFramesWithFile:spriteAtlasPlist];
        _sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:spriteAtlasPng];
        [[_sceneSpriteBatchNode texture] setAliasTexParameters];
        [[self tileMap] addChild:_sceneSpriteBatchNode z:100];
        
        // Timer Test code
        _label = [CCLabelTTF labelWithString:@"" fontName:@"AmericanTypewriter-Bold" fontSize:40.0];
        _label.anchorPoint = ccp(1, 1);
        _label.position = ccp(screenSize.width - 20, screenSize.height - 20);
        [self addChild:_label z:2];
        
        // Load Tower Nodes
        [self checkAndLoadTowerSpawns];
        
        // Load Monster plist Data
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:mobs ofType:@"plist"];
        _mobSpawns = [[NSMutableArray alloc] initWithCapacity:0];
        [_mobSpawns addObjectsFromArray:[NSMutableArray arrayWithContentsOfFile:plistPath]];
    }
    
    return [self autorelease];
}

@end
