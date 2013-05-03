//
//  GameUILayer.h
//  TowerDefense
//
//  Created by Benjamin Chen on 4/25/13.
//
//

#import "cocos2d.h"

@interface GameUILayer : CCLayer <CCTargetedTouchDelegate>
{
    CGRect _touchedTowerNode;
}

@property (readwrite) CGRect touchedTowerNode;

@end
