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
            //[self moveTowardsGoal];
            [self findNextMovableTile];
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
-(void)findNextMovableTile
{
    CCLOG(@"I AM SEARCHING FOR THE NEXT WAYPOINT");
    GameScene *currentScene = [[GameManager sharedManager] getCurrentRunningGameScene];
    CGPoint currentTile = [currentScene tileMapCoordForPosition:self.position];
    CCLOG(@"SELF.POSITION MOVEABLE: %i", [self tileCoordIsMoveable:currentTile]);
    CGPoint southTile = CGPointMake(currentTile.x, currentTile.y + 1.0);
    CGPoint northTile = CGPointMake(currentTile.x, currentTile.y - 1.0);
    CGPoint westTile = CGPointMake(currentTile.x - 1.0, currentTile.y);
    CGPoint eastTile = CGPointMake(currentTile.x + 1.0, currentTile.y);

    CCLOG(@"SOUTHTILE: %i", [self tileCoordIsMoveable:southTile]);
    CCLOG(@"NORTHTILE: %i", [self tileCoordIsMoveable:northTile]);
    CCLOG(@"WESTTILE: %i", [self tileCoordIsMoveable:westTile]);
    CCLOG(@"EASTTILE: %i", [self tileCoordIsMoveable:eastTile]);
    
    if ([self tileCoordIsMoveable:southTile])
    {
        
    }
}

-(BOOL)tileCoordIsMoveable:(CGPoint)coord
{
    GameScene *currentScene = [[GameManager sharedManager] getCurrentRunningGameScene];
    
    // Check if coordinates are out of map bounds before grabbing tile GID
    CGSize mapSize = [[currentScene tileMap] mapSize];
    if (coord.x < 0)
    {
        return NO;
    }
    else if (coord.x >= mapSize.width)
    {
        return NO;
    }
    if (coord.y < 0)
    {
        return NO;
    }
    else if (coord.y >= mapSize.height)
    {
        return NO;
    }
    
    // Grab tileGID from metadata layer and check if walkable by myself
    NSUInteger *tileGID = [[currentScene metadataLayer] tileGIDAt:coord];
    if (tileGID)
    {
        NSDictionary *properties = [[currentScene tileMap] propertiesForGID:tileGID];
        if (properties)
        {
            return [[properties valueForKey:_assignedPath] boolValue];
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
}

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
        _previousTildGID = 0;
        _assignedPath = @"walkableA";
        _nextDestination = nil;
        [self changeState:kMonsterIdle];
    }
    
    return self;
}

@end
