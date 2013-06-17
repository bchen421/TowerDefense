//
//  GameScene.h
//  TowerDefense
//
//  Created by Benjamin Chen on 4/23/13.
//
//

#import "cocos2d.h"
#import "GameConstants.h"
@class GameUILayer;

@interface GameScene : CCScene
{
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_backgroundLayer;
    CCTMXLayer *_metadataLayer;
    CCTMXObjectGroup *_objectData;
    GameUILayer *_gameUILayer;
    CCSpriteBatchNode *_sceneSpriteBatchNode;
    float _spawnTimer;
    CCLabelTTF *_label;
    
    NSMutableArray *_mobSpawns;
    NSUInteger _currentWave;
    
    MonsterID _nextMonsterID;
}

@property (readonly) CCTMXTiledMap *tileMap;
@property (readonly) CCTMXLayer *backgroundLayer;
@property (readonly) CCTMXLayer *metadataLayer;
@property (readonly) CCTMXObjectGroup *objectData;
@property (readonly) GameUILayer *gameUILayer;
@property (readwrite, retain) CCSpriteBatchNode *sceneSpriteBatchNode;
@property (nonatomic, readonly) NSMutableArray *mobSpawns;

-(void)spawnNextMonsterAtLocation:(NSString *)location;
-(void)checkAndLoadMobSpawns;
-(void)checkAndLoadTowerSpawns;
-(void)deployFormation:(NSDictionary *)deployment;
-(CGPoint)positionForTileCoord:(CGPoint)tileCoord;
-(CGPoint)tileMapCoordForPosition:(CGPoint)position;
-(CGPoint)locationForDataObject:(NSString *)dataObject;

@end
