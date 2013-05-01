//
//  BlueTower.m
//  TowerDefense
//
//  Created by Benjamin Chen on 4/25/13.
//
//

#import "BlueTower.h"
#import "TowerProjectile.h"

@implementation BlueTower

#pragma mark - State Management Methods
-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects
{
    [super updateStateWithDeltaTime:deltaTime andListOfGameObjects:listOfGameObjects];
    
    if (([self numberOfRunningActions] == 0) && ([self towerState] != kTowerIdle))
    {
        CCLOG(@"CHANGING TOWER STATE TO IDLE");
        [self changeState:kTowerIdle];
    }
    
    if (self.currentTarget.monsterState == kMonsterDead)
    {
        self.currentTarget = nil;
    }
    
    if ([self towerState] == kTowerIdle)
    {
        if (self.currentTarget == nil)
        {
            [self findTargetFrom:listOfGameObjects];
        }
        else
        {
            if ([self isMonsterInRange:self.currentTarget])
            {
                CCLOG(@"ATTACKING MONSTER");
                [self changeState:kTowerAttacking];
            }
            else
            {
                CCLOG(@"MONSTER HAS MOVED OUT OF RANGE");
                self.currentTarget = nil;
            }
        }
    }
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
            [self attackCurrentTarget];
            break;
            
        default:
            break;
    }
}

-(void)attackCurrentTarget
{
    TowerProjectile *projectile = [TowerProjectile shootProjectile:@"projectile.png" WithDamage:10 andSpeed:0.0 atMonster:self.currentTarget];
    [projectile setPosition:self.position];
    
    [parent_ addChild:projectile z:30];
    
    CCAction *attackActions = [CCSequence actions:[CCDelayTime actionWithDuration:(1.0/[self attackRate])], nil];
    [self runAction:attackActions];
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
        _attackRate = 1.0;
        _attackRange = 128.0;
        [self createRangeFinder];
        [self changeState:kTowerIdle];
    }
    
    return self;
}

@end
