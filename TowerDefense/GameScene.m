//
//  GameScene.m
//  TowerDefense
//
//  Created by Benjamin Chen on 4/23/13.
//
//

#import "GameScene.h"
#import "GameManager.h"

@implementation GameScene

@synthesize tileMap = _tileMap, backgroundLayer = _backgroundLayer, metadataLayer = _metadataLayer, objectData = _objectData, gameUILayer = _gameUILayer, sceneSpriteBatchNode = _sceneSpriteBatchNode, mobSpawns = _mobSpawns;

#pragma mark - Metadata Management
-(CGPoint)positionForTileCoord:(CGPoint)tileCoord
{
    CGPoint position = [[self backgroundLayer] positionAt:tileCoord];
    CGSize tileSize = [[self tileMap] tileSize];
    
    BOOL retina = [[[[self tileMap] properties] valueForKey:@"retina"] boolValue];
    
    if (retina)
    {
        return CGPointMake(position.x + tileSize.width/4.0, position.y + tileSize.height/4.0);
    }
    else
    {
        return CGPointMake(position.x + tileSize.width/2.0, position.y + tileSize.height/2.0);
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

#pragma mark - Monster Spawning
-(void)spawnMonster:(MonsterID)monsterID atLocation:(CGPoint)startLocation onPath:(NSString *)pathName
{
    MonsterObject *newMonster = [[GameManager sharedManager] spawnMonster:monsterID];
    [newMonster setPosition:startLocation];
    [newMonster setAssignedPath:pathName];
    
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
        MonsterID mobID = [[nextSpawn objectForKey:@"type"] integerValue];
        CGPoint spawnLoc = [self locationForDataObject:[nextSpawn objectForKey:@"location"]];
        NSString *path = [nextSpawn objectForKey:@"path"];
        [self spawnMonster:mobID atLocation:spawnLoc onPath:path];
        _currentWave += 1;
        _spawnTimer = 0;
    }
}

#pragma mark - Initialization
-(id)init
{
    self = [super init];
    if (self)
    {
        _sceneSpriteBatchNode = nil;
        _tileMap = nil;
        _backgroundLayer = nil;
        _metadataLayer = nil;
        _objectData = nil;
        _gameUILayer = nil;
        _sceneSpriteBatchNode = nil;
        _spawnTimer = 0.0;
        _mobSpawns = [[NSMutableArray alloc] initWithCapacity:0];
        _currentWave = 0;
    }
    
    return self;
}

@end
