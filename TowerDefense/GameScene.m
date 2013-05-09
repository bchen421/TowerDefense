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

@synthesize tileMap = _tileMap, backgroundLayer = _backgroundLayer, metadataLayer = _metadataLayer, objectData = _objectData, gameUILayer = _gameUILayer, sceneSpriteBatchNode = _sceneSpriteBatchNode, towerNodes = _towerNodes;

#pragma mark - Metadata Management
-(CGPoint)positionForTileCoord:(CGPoint)tileCoord
{
    CGPoint position = [[self metadataLayer] positionAt:tileCoord];
    CGSize tileSize = [[self tileMap] tileSize];
    
    BOOL retina = [[[[self objectData] properties] valueForKey:@"retina"] boolValue];
    
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
    BOOL retinaEnabled = [[[[self objectData] properties] valueForKey:@"retina"] boolValue];
    if (!retinaEnabled)
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
    BOOL retinaEnabled = [[[[self objectData] properties] valueForKey:@"retina"] boolValue];
    
    NSDictionary *dict = [[self objectData] objectNamed:dataObject];
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
    int numberOfTowers = [[[[self objectData] properties] valueForKey:@"numberOfTowers"] integerValue];
    BOOL retinaEnabled = [[[[self objectData] properties] valueForKey:@"retina"] boolValue];
    
    NSDictionary *dict;
    
    for (int i = 1; i <= numberOfTowers; i++)
    {
        dict = [[self objectData] objectNamed:[NSString stringWithFormat:@"towerSpawnPoint%i",i]];
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

#pragma mark - Monster Spawning
-(void)spawnMonster:(MonsterID)monsterID atLocation:(CGPoint)startLocation withGoalLocation:(CGPoint)endLocation
{
    MonsterObject *testMonster = [[GameManager sharedManager] spawnMonster:monsterID withGoalLocation:endLocation];
    [testMonster setPosition:startLocation];
    
    [[self sceneSpriteBatchNode] addChild:testMonster z:20];
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
        
        // Temporary: Move to tile metadata
        _towerNodes = nil;
    }
    
    return self;
}

@end
