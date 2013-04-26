//
//  TowerObject.m
//  TowerDefense
//
//  Created by Benjamin Chen on 4/25/13.
//
//

#import "TowerObject.h"

@implementation TowerObject
@synthesize towerID=_towerID, towerState=_towerState, attackSpeed=_attackSpeed, attackRange=_attackRange, currentTarget=_currentTarget;

#pragma mark - State Management Methods
-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects
{
    [super updateStateWithDeltaTime:deltaTime andListOfGameObjects:listOfGameObjects];
}

-(void)changeState:(TowerState)newState
{
    CCLOG(@"STUB METHOD, PLEASE OVERRIDE ME");
}

#pragma mark - Initialization
-(id)initWithSpriteFrame:(CCSpriteFrame*)spriteFrame
{
    if ((self = [super initWithSpriteFrame:spriteFrame]))
    {
        _gameObjectType = kTowerObject;
        _towerID = kGenericTower;
        _towerState = kMonsterIdle;
        _attackSpeed = 0.25;
        _attackRange = 100.0;
        _currentTarget = nil;
    }
    return self;
}

@end
