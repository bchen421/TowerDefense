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

@interface SandboxScene : GameScene
{
    SandboxLayer *_gameplayLayer;
}

@property (readonly) SandboxLayer *gameplayLayer;

@end
