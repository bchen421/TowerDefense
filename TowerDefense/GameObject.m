//
//  GameObject.m
//  TowerDefense
//
//  Created by Benjamin Chen on 4/17/13.
//
//

#import "GameObject.h"
#import "GameConstants.h"

@implementation GameObject
@synthesize gameObjectType = _gameObjectType;

#pragma mark - GameObject Update Management
-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects
{
}


#pragma mark - Initialization
-(id)initWithSpriteFrame:(CCSpriteFrame *)spriteFrame
{
    if ((self = [super initWithSpriteFrame:spriteFrame]))
    {
        _gameObjectType = kGenericGameObject;
    }
    return self;
}

@end
