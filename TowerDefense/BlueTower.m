//
//  BlueTower.m
//  TowerDefense
//
//  Created by Benjamin Chen on 4/25/13.
//
//

#import "BlueTower.h"

@implementation BlueTower

#pragma mark - State Management Methods
-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects
{
    [super updateStateWithDeltaTime:deltaTime andListOfGameObjects:listOfGameObjects];
}

-(void)changeState:(TowerState)newState
{
    self.towerState = newState;
    
    switch (newState)
    {
        case kTowerIdle:
            CCLOG(@"BlueTower is idle!");
            break;
            
        case kTowerAttacking:
            CCLOG(@"BlueTower is starting to attack!");
            break;
            
        default:
            break;
    }
}

#pragma mark - Tower Factory
+(TowerObject *)spawnTower
{
    TowerObject *newTower = [[BlueTower alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"tower.png"]];
    [newTower setTowerID:kBlueTower];
    
    return newTower;
}

#pragma mark - Initialization
-(id)initWithSpriteFrame:(CCSpriteFrame*)spriteFrame
{
    if (self = [super initWithSpriteFrame:spriteFrame])
    {
        _towerID = kBlueTower;
        [self changeState:kTowerIdle];
    }
    
    return self;
}

@end
