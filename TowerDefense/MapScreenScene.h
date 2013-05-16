//
//  MapScreenScene.h
//  TowerDefense
//
//  Created by Benjamin Chen on 5/14/13.
//
//

#import "cocos2d.h"
#import "GameManager.h"

@interface MapScreenScene : CCScene <CCTargetedTouchDelegate>
{    
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_backgroundLayer;
    CCTMXObjectGroup *_objectData;
    
    NSMutableArray *_levelSelectNodes;
}

@property (readonly) CCTMXTiledMap *tileMap;
@property (readonly) CCTMXLayer *backgroundLayer;
@property (readonly) CCTMXObjectGroup *objectData;
@property (readonly) GameUILayer *gameUILayer;
@property (nonatomic,readonly) NSMutableArray *levelSelectNodes;

-(void)setupLevelSelectNodes;

@end
