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
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_backgroundLayer;
    CCTMXObjectGroup *_metadata;
    GameUILayer *_gameUILayer;    
}

@property (readonly) CCTMXTiledMap *tileMap;
@property (readonly) CCTMXLayer *backgroundLayer;
@property (readonly) CCTMXObjectGroup *metadata;
@property (readonly) GameUILayer *gameUILayer;

-(CGPoint)locationForMetadataObject:(NSString *)metadataObject;
-(void)setupTowerNodes;

@end