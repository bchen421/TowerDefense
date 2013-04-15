//
//  GameManager.h
//  Tower Defense
//
//  Created by Benjamin Chen on 4/15/13.
//
//

#import "cocos2d.h"
#import "GameConstants.h"

@interface GameManager : NSObject
{
    GameSceneID currentScene;
}

+(GameManager *)sharedManager;
-(void)runGameScene:(GameSceneID)sceneID;
-(CGSize)getDimensionsOfCurrentScene;

@end
