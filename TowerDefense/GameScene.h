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
}

@property (readonly) CCTMXTiledMap *tileMap;
@property (readonly) CCTMXLayer *backgroundLayer;
@property (readonly) CCTMXLayer *metadataLayer;
@property (readonly) CCTMXObjectGroup *objectData;
@property (readonly) GameUILayer *gameUILayer;
@property (readwrite, retain) CCSpriteBatchNode *sceneSpriteBatchNode;

-(void)spawnMonster:(MonsterID)monsterID atLocation:(CGPoint)startLocation onPath:(NSString *)pathName;
-(void)spawnMonsterFromDictionary:(NSDictionary *)spawnInfo;
-(CGPoint)positionForTileCoord:(CGPoint)tileCoord;
-(CGPoint)tileMapCoordForPosition:(CGPoint)position;
-(CGPoint)locationForDataObject:(NSString *)dataObject;

@end
