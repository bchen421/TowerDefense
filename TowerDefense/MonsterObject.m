//
//  MonsterObject.m
//  TowerDefense
//
//  Created by Benjamin Chen on 4/18/13.
//
//

#import "MonsterObject.h"
#import "GameConstants.h"
#import "GameManager.h"

@implementation MonsterObject
@synthesize monsterID = _monsterID, monsterState = _monsterState, movementSpeed = _movementSpeed, goalLocation = _goalLocation;

#pragma mark - State Management Methods
-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects
{
    [super updateStateWithDeltaTime:deltaTime andListOfGameObjects:listOfGameObjects];
}

-(void)changeState:(MonsterState)newState
{
    CCLOG(@"STUB METHOD, PLEASE OVERRIDE ME");
}

-(void)takeDamage:(NSUInteger)amount
{
    CCLOG(@"I TOOK %i amount of damage!", amount);
}

#pragma mark - Initialization
-(id)initWithSpriteFrame:(CCSpriteFrame*)spriteFrame
{
    if ((self = [super initWithSpriteFrame:spriteFrame]))
    {
        _gameObjectType = kMonsterObject;
        _monsterID = kGenericMonster;
        _monsterState = kMonsterIdle;
        _movementSpeed = 50.0;
        _goalLocation = CGPointMake(0.0, 0.0);
    }
    return self;
}

@end
