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
   
}

-(CGPoint)locationForDataObject:(NSString *)dataObject;
-(void)setupTowerNodes;

@end