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
@synthesize monsterID = _monsterID, monsterState = _monsterState, maxHP = _maxHP, currentHP = _currentHP, movementSpeed = _movementSpeed, goalLocation = _goalLocation, assignedPath = _assignedPath, nextDestination = _nextDestination, doneMoving = _doneMoving, pathArray = _pathArray, currentPathIndex = _currentPathIndex;

#pragma mark - State Management Methods
-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects
{
    [super updateStateWithDeltaTime:deltaTime andListOfGameObjects:listOfGameObjects];
    if (!self.assignedPath)
    {
        [self findAssignedPath];
        [self createTravelPathArray];
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
-(void)findAssignedPath
{
    CCLOG(@"TRYING TO FIND ASSIGNED PATH");
    GameScene *currentScene = [[GameManager sharedManager] currentRunningGameScene];
    CGPoint currentTile = [currentScene tileMapCoordForPosition:self.position];
    NSUInteger tileGID = [[currentScene metadataLayer] tileGIDAt:currentTile];
    
    if (tileGID)
    {
        NSDictionary *properties = [[currentScene tileMap] propertiesForGID:tileGID];
        if (properties)
        {
            if ([[properties valueForKey:@"walkableA"] boolValue])
            {
                [self setAssignedPath:@"walkableA"];
            }
            else if ([[properties valueForKey:@"walkableB"] boolValue])
            {
                [self setAssignedPath:@"walkableB"];
            }
            else if ([[properties valueForKey:@"walkableC"] boolValue])
            {
                [self setAssignedPath:@"walkableC"];
            }
        }
        else
        {
            self.assignedPath = nil;
        }
    }
    else
    {
        self.assignedPath = nil;
    }
}


-(BOOL)tileCoordIsMoveable:(CGPoint)coord
{
    GameScene *currentScene = [[GameManager sharedManager] currentRunningGameScene];
    
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
    NSUInteger tileGID = [[currentScene metadataLayer] tileGIDAt:coord];
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

-(CGPoint)findNextMovableTileFromTile:(CGPoint)currentTile andPreviousTile:(CGPoint)previousTile
{    
    CGPoint southTile = ccp(currentTile.x, currentTile.y + 1.0);
    CGPoint northTile = ccp(currentTile.x, currentTile.y - 1.0);
    CGPoint westTile = ccp(currentTile.x - 1.0, currentTile.y);
    CGPoint eastTile = ccp(currentTile.x + 1.0, currentTile.y);
    CGPoint southWestTile = ccp(currentTile.x - 1.0, currentTile.y + 1.0);
    CGPoint southEastTile = ccp(currentTile.x + 1.0, currentTile.y + 1.0);
    CGPoint northWestTile = ccp(currentTile.x - 1.0, currentTile.y - 1.0);
    CGPoint northEastTile = ccp(currentTile.x + 1.0, currentTile.y - 1.0);
    
    
    if ([self tileCoordIsMoveable:southTile] && (!CGPointEqualToPoint(southTile, previousTile)))
        return southTile;
    else if ([self tileCoordIsMoveable:westTile] && (!CGPointEqualToPoint(westTile, previousTile)))
        return westTile;
    else if ([self tileCoordIsMoveable:eastTile] && (!CGPointEqualToPoint(eastTile, previousTile)))
        return eastTile;
    else if ([self tileCoordIsMoveable:northTile] && (!CGPointEqualToPoint(northTile, previousTile)))
        return northTile;
    else if ([self tileCoordIsMoveable:southWestTile] && (!CGPointEqualToPoint(southWestTile, previousTile)))
        return southWestTile;
    else if ([self tileCoordIsMoveable:southEastTile] && (!CGPointEqualToPoint(southEastTile, previousTile)))
        return southEastTile;
    else if ([self tileCoordIsMoveable:northWestTile] && (!CGPointEqualToPoint(northWestTile, previousTile)))
        return northWestTile;
    else if ([self tileCoordIsMoveable:northEastTile] && (!CGPointEqualToPoint(northEastTile, previousTile)))
        return northEastTile;
    else
    {
        return ccp(-1.0, -1.0);
    }
}

-(void)createTravelPathArray
{
    GameScene *currentScene = [[GameManager sharedManager] currentRunningGameScene];
    CGPoint startingPoint = [currentScene tileMapCoordForPosition:self.position];
    NSLog(@"X: %g, Y:%g", startingPoint.x, startingPoint.y);
    NSValue *startingTile = [NSValue valueWithCGPoint:[currentScene tileMapCoordForPosition:self.position]];
    CGPoint previousTile = ccp(-1,-1);
    
    [_pathArray addObject:startingTile];
    BOOL doneCreating = NO;
    
    while (!doneCreating)
    {
        CGPoint currentTile = [[_pathArray objectAtIndex:[self currentPathIndex]] CGPointValue];
        NSValue *nextTile = [NSValue valueWithCGPoint:[self findNextMovableTileFromTile:currentTile andPreviousTile:previousTile]];
        if (CGPointEqualToPoint(ccp(-1.0, -1.0), [nextTile CGPointValue]))
        {
            doneCreating = YES;
        }
        else
        {
            [_pathArray addObject:nextTile];
            previousTile = currentTile;
            _currentPathIndex += 1;
        }
    }
    
    _currentPathIndex = 0;
    CCLOG(@"%@", [_pathArray description]);
}

-(void)moveTowardsGoalWithDeltaTime:(ccTime)dt
{
    GameScene *currentScene = [[GameManager sharedManager] currentRunningGameScene];
    
    if ([self currentPathIndex] >= ([[self pathArray] count] - 1))
    {
        CCLOG(@"DONE MOVING");
        [self setDoneMoving:YES];
        return;
    }
    
    self.nextDestination = [[[self pathArray] objectAtIndex:(_currentPathIndex + 1)] CGPointValue];
    self.nextDestination = [currentScene positionForTileCoord:self.nextDestination];
    
    CGPoint offSet;
    CGPoint travelPoint;
    float time2Travel;
    float distance;
        
    offSet.x = self.nextDestination.x - self.position.x;
    offSet.y = self.nextDestination.y - self.position.y;
    if (ABS(offSet.y) <= 1)
    {
        travelPoint.y = 0;
    }
    if (ABS(offSet.x) <= 1)
    {
        travelPoint.x = 0;
    }
    distance = sqrt((offSet.x * offSet.x) + (offSet.y * offSet.y));
    time2Travel = [self movementSpeed] / distance;
    travelPoint.x = offSet.x * time2Travel;
    travelPoint.y = offSet.y * time2Travel;
        
    // Move monster towards player
    self.position = ccp((self.position.x + (travelPoint.x * dt)), self.position.y + (travelPoint.y * dt) );
    
    if ((ABS(offSet.x) <= 2.0) && (ABS(offSet.y) <= 2.0))
    {
        _currentPathIndex += 1;
    }
}

-(void)incrementPathIndex
{
    _currentPathIndex += 1;
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
        
        _assignedPath = nil;
        _nextDestination = ccp(0,0);
        _doneMoving = NO;
        _pathArray = [[NSMutableArray alloc] initWithCapacity:0];
        _currentPathIndex = 0;
        [[self texture] setAliasTexParameters];
    }
    return self;
}

@end
