//
//  GameObject.h
//  TowerDefense
//
//  Created by Benjamin Chen on 4/17/13.
//
//

#import "CCSprite.h"
#import "GameConstants.h"

@interface GameObject : CCSprite
{
    GameObjectType _objectType;
}

@property (readonly) GameObjectType objectType;

@end
