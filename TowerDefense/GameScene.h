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

@interface GameScene : CCScene
{
    CGPoint _startLocation01;
    CGPoint _goalLocation01;
    
    CCSpriteBatchNode *_sceneSpriteBatchNode;
}

@property (readonly) CGPoint startLocation01;
@property (readonly) CGPoint goalLocation01;
@property (readwrite, retain) CCSpriteBatchNode *sceneSpriteBatchNode;

-(void)spawnMonster:(MonsterID)monsterID atLocation:(CGPoint)startLocation withGoalLocation:(CGPoint)endLocation;

@end
