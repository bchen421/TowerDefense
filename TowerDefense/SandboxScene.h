//
//  SandboxScene.h
//  TowerDefense
//
//  Created by Benjamin Chen on 4/17/13.
//
//

#import "cocos2d.h"
#import "GameConstants.h"
@class SandboxLayer;

@interface SandboxScene : CCScene
{
    CGPoint _startLocation;
    CGPoint _endLocation;

    CCSpriteBatchNode *_sceneSpriteBatchNode;
    SandboxLayer *_gameplayLayer;
}

@property (readonly) CGPoint startLocation;
@property (readonly) CGPoint endLocation;
@property (readwrite, retain) CCSpriteBatchNode *sceneSpriteBatchNode;
@property (readonly) SandboxLayer *gameplayLayer;

-(void)spawnMonster:(MonsterID)monsterID atLocation:(CGPoint)location;

@end
