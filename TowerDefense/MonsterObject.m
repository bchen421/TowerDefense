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
@synthesize monsterID = _monsterID, monsterState = _monsterState, maxHP = _maxHP, currentHP = _currentHP, movementSpeed = _movementSpeed, goalLocation = _goalLocation, spawnPoint = _spawnPoint, nextDestination = _nextDestination, doneMoving = _doneMoving, pathArray = _pathArray, currentPathIndex = _currentPathIndex;

#pragma mark - State Management Methods
-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects
{
    [super updateStateWithDeltaTime:deltaTime andListOfGameObjects:listOfGameObjects];
    
    if ([_pathArray count] == 0)
    {
        CCLOG(@"Populating path array with data");
        GameScene *currentScene = [[GameManager sharedManager] currentRunningGameScene];
        _pathArray = [[[currentScene mobPathingDict] objectForKey:_spawnPoint] objectForKey:@"pathArray"];
    }
}

-(void)changeState:(MonsterState)newState
{
    CCLOG(@"STUB METHOD, PLEASE OVERRIDE ME");
}

-(void)takeDamage:(NSInteger)amount
{
    CCLOG(@"I TOOK %i amount of damage!", amount);
    self.currentHP = self.currentHP - amount;
}

-(void)hasDied
{
    [self stopAllActions];
    //[self runAction:[CCBlink actionWithDuration:1.0 blinks:5]];
    //[self removeFromParentAndCleanup:YES];
    CCAction *deathAction = [CCSequence actions:[CCBlink actionWithDuration:1.0 blinks:5], [CCCallFuncND actionWithTarget:self selector:@selector(removeFromParentAndCleanup:) data:YES], nil];
    [self runAction:deathAction];
}

#pragma mark - Movement Helper Methods

-(void)moveTowardsGoalWithDeltaTime:(ccTime)dt
{
    GameScene *currentScene = [[GameManager sharedManager] currentRunningGameScene];
    
    if ([self currentPathIndex] >= ([[self pathArray] count] - 1))
    {
        CCLOG(@"DONE MOVING");
        [self setDoneMoving:YES];
        return;
    }
    
    if ([[self pathArray] count] == 0)
    {
        CCLOG(@"No path found yet");
        return;
    }
    
    self.nextDestination = [[[self pathArray] objectAtIndex:(_currentPathIndex + 1)] CGPointValue];
    self.nextDestination = [currentScene positionForTileCoord:self.nextDestination];
    
    float offSetX;
    float offSetY;
    CGPoint travelPoint;
    float time2Travel;
    float distance;
        
    offSetX = self.nextDestination.x - self.position.x;
    offSetY = self.nextDestination.y - self.position.y;
    
    //if (ABS(offSetY) <= 0.0)
    //{
        //offSetY = 0.0;
    //}
    
    distance = sqrtf((offSetX * offSetX) + (offSetY * offSetY));
    time2Travel = [self movementSpeed] / distance;
    travelPoint.x = offSetX * time2Travel;
    travelPoint.y = offSetY * time2Travel;
    
    // Move monster towards player
    self.position = ccp((self.position.x + (travelPoint.x * dt)), self.position.y + (travelPoint.y * dt) );
    
    if ((ABS(offSetX) <= 2.0) && (ABS(offSetY) <= 2.0))
    {
        _currentPathIndex += 1;
    }
}

#pragma mark - Initialization
-(id)initWithSpriteFrame:(CCSpriteFrame*)spriteFrame
{
    if ((self = [super initWithSpriteFrame:spriteFrame]))
    {
        _gameObjectType = kMonsterObject;
        _monsterID = kGenericMonster;
        _monsterState = kMonsterIdle;
        _maxHP = 1;
        _currentHP = 1;
        _movementSpeed = 40.0;
        
        _nextDestination = ccp(0,0);
        _doneMoving = NO;
        _pathArray = [[NSMutableArray alloc] initWithCapacity:0];
        _currentPathIndex = 0;
        [[self texture] setAliasTexParameters];
    }
    return self;
}

@end
