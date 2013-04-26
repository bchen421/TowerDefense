//
//  SandboxScene.h
//  TowerDefense
//
//  Created by Benjamin Chen on 4/17/13.
//
//

#import "GameScene.h"
#import "cocos2d.h"
#import "GameConstants.h"
@class SandboxLayer;
@class GameUILayer;

@interface SandboxScene : GameScene
{
    SandboxLayer *_gameplayLayer;
    GameUILayer *_gameUILayer;
}

@property (readonly) SandboxLayer *gameplayLayer;
@property (readonly) GameUILayer *gameUILayer;

@end
