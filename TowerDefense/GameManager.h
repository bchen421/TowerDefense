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

@interface GameManager : NSObject
{
    GameSceneID _currentScene;
}

// Class Methods
+(GameManager *)sharedManager;

// Scene Management
-(void)runGameScene:(GameSceneID)sceneID;
-(CGSize)getDimensionsOfCurrentScene;

// Monster Management
-(MonsterObject *)spawnMonster:(MonsterID)monsterID;

@end
