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
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_backgroundLayer;
    CCTMXObjectGroup *_objectData;
}

@property (readonly) CCTMXTiledMap *tileMap;
@property (readonly) CCTMXLayer *backgroundLayer;
@property (readonly) CCTMXObjectGroup *objectData;
@property (readonly) GameUILayer *gameUILayer;

@end
