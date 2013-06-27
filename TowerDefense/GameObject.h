//
//  GameObject.h
//  TowerDefense
//
//  Created by Benjamin Chen on 4/17/13.
//
//

#import "CCSprite.h"
#import "GameConstants.h"
#import "GameScene.h"

@interface GameObject : CCSprite
{
    GameObjectType _gameObjectType;
}
@property (nonatomic, readwrite) GameObjectType gameObjectType;


-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects;
-(CCAnimation*)loadPlistForAnimationWithName:(NSString*)animationName andClassName:(NSString*)className;
-(void)initAnimations;

@end
