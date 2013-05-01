//
//  TiledScene.h
//  TowerDefense
//
//  Created by Benjamin Chen on 5/1/13.
//
//

#import "GameScene.h"
#import "cocos2d.h"
#import "GameConstants.h"
@class GameUILayer;

@interface TiledScene : GameScene
{
    CCTMXLayer *_tiledLayer;
    GameUILayer *_gameUILayer;
}

@property (readonly) CCTMXLayer *tiledLayer;
@property (readonly) GameUILayer *gameUILayer;

@end