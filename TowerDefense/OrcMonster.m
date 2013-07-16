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

@synthesize walkingAnim = _walkingAnim;

#pragma mark - State Management Methods
-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects
{
    [super updateStateWithDeltaTime:deltaTime andListOfGameObjects:listOfGameObjects];
    
    // State change checking section

    if (self.currentHP <= 0 && (self.monsterState != kMonsterDead))
    {
        [self changeState:kMonsterDead];
    }
    
    if (([self numberOfRunningActions] == 0) && (self.monsterState != kMonsterDead) && [self doneMoving] && (self.monsterState != kMonsterIdle))
    {
        [self changeState:kMonsterIdle];
    }
        
    if ( (self.monsterState == kMonsterIdle) && (![self doneMoving]) && ([self numberOfRunningActions] == 0))
    {
        [self changeState:kMonsterMoving];
    }
    
    // State Management
    if (self.monsterState == kMonsterMoving)
    {
        [self moveTowardsGoalWithDeltaTime:deltaTime];
    }
}

- (void) moveMe:(ccTime)dt
{
    // State Management
    if (self.monsterState == kMonsterMoving)
    {
       [self moveTowardsGoalWithDeltaTime:dt];
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
            id walkingAction = nil;
            walkingAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:_walkingAnim]];
            [self runAction:walkingAction];
            break;
            
        case kMonsterDead:
            CCLOG(@"OrcMonster is dead noooooo");
            [self hasDied];
            break;
            
        default:
            break;
    }
}

#pragma mark - Animation Management Methods
-(void)runWalkingAnimation
{
    // Check _nextDestination for heading, and set proper sprite prefix
    //CGPoint currentPosition = self.position;
}

#pragma mark - Orc Factory
+(MonsterObject *)spawnOrc
{
    MonsterObject *newOrc = [[OrcMonster alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"goblin_front.png"]];
    [newOrc setScale:0.75];
    [newOrc setMonsterID:kOrc];
    
    return newOrc;
}

+(MonsterObject *)spawnBigOrc
{
    MonsterObject *newOrc = [[OrcMonster alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"goblin_front.png"]];
    [newOrc setScale:1.0];
    [newOrc setMonsterID:kBigOrc];
    
    return newOrc;
}

#pragma mark - Initialization
-(void)initAnimations
{
    [self setWalkingAnim:[self loadPlistForAnimationWithName:@"walkingAnim" andClassName:NSStringFromClass([self class])]];
}

-(id)initWithSpriteFrame:(CCSpriteFrame*)spriteFrame
{
    if (self = [super initWithSpriteFrame:spriteFrame])
    {
        _monsterID = kOrc;
        _maxHP = 30;
        _currentHP = 30;
        _movementSpeed = 25.0;
        [self initAnimations];
        [self changeState:kMonsterIdle];
    }
    
    return self;
}

@end
