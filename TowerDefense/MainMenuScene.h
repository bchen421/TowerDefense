//
//  MainMenuScene.h
//  TowerDefense
//
//  Created by Benjamin Chen on 4/16/13.
//
//

#import "cocos2d.h"
@class MainMenuLayer;

@interface MainMenuScene : CCScene
{
    MainMenuLayer *_mainMenuLayer;
}

@property (readonly) MainMenuLayer *mainMenulayer;

@end
