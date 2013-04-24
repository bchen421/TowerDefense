//
//  GameManager.h
//  Tower Defense
//
//  Created by Benjamin Chen on 4/15/13.
//
//

#import "cocos2d.h"
#import "GameConstants.h"
@class GameScene;

#import "MonsterObject.h"

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

@end
