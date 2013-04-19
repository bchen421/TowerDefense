//
//  SandboxScene.h
//  TowerDefense
//
//  Created by Benjamin Chen on 4/17/13.
//
//

#import "cocos2d.h"
@class SandboxLayer;

@interface SandboxScene : CCScene
{
    CCSpriteBatchNode *_sceneSpriteBatchNode;
    SandboxLayer *_gameplayLayer;
}

@property (readwrite, retain) CCSpriteBatchNode *sceneSpriteBatchNode;
@property (readonly) SandboxLayer *gameplayLayer;

@end
