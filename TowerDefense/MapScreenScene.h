//
//  MapScreenScene.h
//  TowerDefense
//
//  Created by Benjamin Chen on 5/14/13.
//
//

#import "cocos2d.h"
#import "GameManager.h"

@interface MapScreenScene : CCScene
{
    CCLayer *_backgroundLayer;
}

@property (nonatomic,readonly) CCLayer *backgroundLayer;

@end
