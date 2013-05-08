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
    
    // Temporary: Move to tile metadata
    NSMutableArray *_towerNodes;
}

@property (readonly) CCTMXTiledMap *tileMap;
@property (readonly) CCTMXLayer *backgroundLayer;
@property (readonly) CCTMXLayer *metadataLayer;
@property (readonly) CCTMXObjectGroup *objectData;
@property (readonly) GameUILayer *gameUILayer;
@property (readwrite, retain) CCSpriteBatchNode *sceneSpriteBatchNode;
@property (nonatomic, retain, readwrite) NSMutableArray *towerNodes;

-(void)spawnMonster:(MonsterID)monsterID atLocation:(CGPoint)startLocation withGoalLocation:(CGPoint)endLocation;
-(CGPoint)tileMapCoordForPosition:(CGPoint)position;
-(CGPoint)locationForDataObject:(NSString *)dataObject;

// Temporary: Move to tile metadata
-(void)setupTowerNodes;

@end
