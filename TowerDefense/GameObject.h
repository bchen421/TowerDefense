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
    GameObjectType _gameObjectType;
    GameObjectState _gameObjectState;
}
@property (nonatomic, readwrite) GameObjectType gameObjectType;
@property (nonatomic, readwrite) GameObjectState gameObjectState;

-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects;

@end
