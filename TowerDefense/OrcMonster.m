//
//  OrcMonster.m
//  TowerDefense
//
//  Created by Benjamin Chen on 4/19/13.
//
//

#import "OrcMonster.h"
#import "GameManager.h"

@implementation OrcMonster

#pragma mark - State Management Methods
-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects
{
    [super updateStateWithDeltaTime:deltaTime andListOfGameObjects:listOfGameObjects];
    if (self.currentHP <= 0 && (self.monsterState != kMonsterDead))
    {
        [self changeState:kMonsterDead];
    }
    
    if (([self numberOfRunningActions] == 0) && (self.monsterState != kMonsterDead))
    {
        [self changeState:kMonsterIdle];
    }
        
    // If I am idle, I should try and move towards the goal
    if (self.monsterState == kMonsterIdle)
    {
        [self changeState:kMonsterMoving];
    }
}

-(void)changeState:(MonsterState)newState
{
    self.monsterState = newState;
    
    switch (newState)
    {
        case kMonsterIdle:
            CCLOG(@"OrcMonster is idle!");
            break;
        
        case kMonsterMoving:
            CCLOG(@"OrcMonster is starting to move");
            [self moveTowardsGoal];
            break;
            
        case kMonsterDead:
            CCLOG(@"OrcMonster is dead noooooo");
            [self hasDied];
            break;
            
        default:
            break;
    }
}

#pragma mark - Orc Factory
+(MonsterObject *)spawnOrc
{
    MonsterObject *newOrc = [[OrcMonster alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"orc.png"]];
    [newOrc setScale:0.75];
    [newOrc setMonsterID:kOrc];
    
    return newOrc;
}

+(MonsterObject *)spawnBigOrc
{
    MonsterObject *newOrc = [[OrcMonster alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"orc.png"]];
    [newOrc setScale:1.0];
    [newOrc setMonsterID:kBigOrc];
    
    return newOrc;
}

#pragma mark - Initialization
-(id)initWithSpriteFrame:(CCSpriteFrame*)spriteFrame
{
    if (self = [super initWithSpriteFrame:spriteFrame])
    {
        _monsterID = kOrc;
        _maxHP = 30;
        _currentHP = 30;
        _assignedPath = @"walkableA";
        [self changeState:kMonsterIdle];
    }
    
    return self;
}

@end
