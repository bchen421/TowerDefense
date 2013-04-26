//
//  GameManager.h
//  Tower Defense
//
//  Created by Benjamin Chen on 4/15/13.
//
//

#import "cocos2d.h"
#import "GameConstants.h"

#import "MonsterObject.h"

@class GameScene;

@interface GameManager : NSObject
{
    GameSceneID _currentSceneID;
}

// Class Methods
+(GameManager *)sharedManager;

// Scene Management
-(void)runGameScene:(GameSceneID)sceneID;
-(CGSize)getDimensionsOfCurrentScene;
-(GameScene *)getCurrentRunningGameScene;

// Monster Management
-(MonsterObject *)spawnMonster:(MonsterID)monsterID withGoalLocation:(CGPoint)goalLocation;

// Tower Management
-(void)spawnTower:(TowerID)towerID forScene:(GameScene *)gameScene atLocation:(CGPoint)spawnLocation;

@end