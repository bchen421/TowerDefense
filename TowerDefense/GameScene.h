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

@property (nonatomic, readonly) CCTMXTiledMap *tileMap;
@property (nonatomic, readonly) CCTMXLayer *backgroundLayer;
@property (nonatomic, readonly) CCTMXLayer *metadataLayer;
@property (nonatomic, readonly) CCTMXObjectGroup *objectData;
@property (nonatomic, readonly) GameUILayer *gameUILayer;
@property (nonatomic, readonly) CCSpriteBatchNode *sceneSpriteBatchNode;
@property (nonatomic, readonly) NSMutableArray *mobSpawns;

-(id)initWithTileMap:(NSString *)map spriteAtlas:(NSString *)spriteAtlas andMobs:(NSString *)mobs;
-(void)spawnNextMonsterAtLocation:(NSString *)location;
- (void)displaySecs:(float)secs;
-(void)checkAndLoadMobSpawns;
-(void)checkAndLoadTowerSpawns;
-(void)deployFormation:(NSDictionary *)deployment;
-(CGPoint)positionForTileCoord:(CGPoint)tileCoord;
-(CGPoint)tileMapCoordForPosition:(CGPoint)position;
-(CGPoint)locationForDataObject:(NSString *)dataObject;

@end
