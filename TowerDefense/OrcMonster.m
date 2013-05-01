//
//  OrcMonster.m
//  TowerDefense
//
//  Created by Benjamin Chen on 4/19/13.
//
//

#import "OrcMonster.h"

@implementation OrcMonster

#pragma mark - State Management Methods
-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects
{
    [super updateStateWithDeltaTime:deltaTime andListOfGameObjects:listOfGameObjects];
    if (self.currentHP <= 0 && (self.monsterState != kMonsterDead))
    {
        [self changeState:kMonsterDead];
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

-(void)hasDied
{
    [self stopAllActions];
    //[self runAction:[CCBlink actionWithDuration:1.0 blinks:5]];
    //[self removeFromParentAndCleanup:YES];
    CCAction *deathAction = [CCSequence actions:[CCBlink actionWithDuration:1.0 blinks:5], [CCCallFuncND actionWithTarget:self selector:@selector(removeFromParentAndCleanup:) data:YES], nil];
    [self runAction:deathAction];
}

#pragma mark - Internal helper methods
-(void)moveTowardsGoal
{
    CCLOG(@"I SHOULD BE MOVING TOWARDS THE GOAL");
    CCAction *moveAction;
    CGPoint offSet;
    float distance;
    float travelTime;

    offSet.x = ABS(self.position.x - self.goalLocation.x);
    offSet.y = ABS(self.position.y - self.goalLocation.y);
    distance = sqrt((offSet.x * offSet.x) + (offSet.y * offSet.y));
    travelTime = (distance / self.movementSpeed);
        
    moveAction = [CCMoveTo actionWithDuration:travelTime position:self.goalLocation];
    [self runAction:moveAction];
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
        [self changeState:kMonsterIdle];
    }
    
    return self;
}

@end
