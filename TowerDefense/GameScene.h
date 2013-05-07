//
//  GameScene.h
//  TowerDefense
//
//  Created by Benjamin Chen on 4/23/13.
//
//

#import "cocos2d.h"
#import "GameConstants.h"
@class SandboxLayer;
@class GameUILayer;

@interface GameScene : CCScene
{
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_backgroundLayer;
    CCTMXLayer *_metadataLayer;
    CCTMXObjectGroup *_objectData;
    GameUILayer *_gameUILayer;
    
    CGPoint _startLocation01;
    CGPoint _goalLocation01;
    NSMutableArray *_towerNodes;
    
    
    CCSpriteBatchNode *_sceneSpriteBatchNode;
}

@property (readonly) CCTMXTiledMap *tileMap;
@property (readonly) CCTMXLayer *backgroundLayer;
@property (readonly) CCTMXLayer *metadataLayer;
@property (readonly) CCTMXObjectGroup *objectData;
@property (readonly) GameUILayer *gameUILayer;

@property (readonly) CGPoint startLocation01;
@property (readonly) CGPoint goalLocation01;
@property (nonatomic, retain, readwrite) NSMutableArray *towerNodes;
@property (readwrite, retain) CCSpriteBatchNode *sceneSpriteBatchNode;

-(void)spawnMonster:(MonsterID)monsterID atLocation:(CGPoint)startLocation withGoalLocation:(CGPoint)endLocation;
-(CGPoint)tileMapCoordForPosition:(CGPoint)position;

@end
