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
@synthesize monsterID = _monsterID, monsterState = _monsterState, maxHP = _maxHP, currentHP = _currentHP, movementSpeed = _movementSpeed, goalLocation = _goalLocation, previousLocationTile = _previousLocationTile, assignedPath = _assignedPath, nextDestination = _nextDestination, doneMoving = _doneMoving, pathArray = _pathArray, currentPathIndex = _currentPathIndex;

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

-(CGPoint)findNextMovableTile
{
    GameScene *currentScene = [[GameManager sharedManager] currentRunningGameScene];
    CGPoint currentTile = [currentScene tileMapCoordForPosition:self.position];
    
    CGPoint southTile = CGPointMake(currentTile.x, currentTile.y + 1.0);
    CGPoint northTile = CGPointMake(currentTile.x, currentTile.y - 1.0);
    CGPoint westTile = CGPointMake(currentTile.x - 1.0, currentTile.y);
    CGPoint eastTile = CGPointMake(currentTile.x + 1.0, currentTile.y);
    CGPoint southWestTile = CGPointMake(currentTile.x - 1.0, currentTile.y + 1.0);
    CGPoint southEastTile = CGPointMake(currentTile.x + 1.0, currentTile.y + 1.0);
    CGPoint northWestTile = CGPointMake(currentTile.x - 1.0, currentTile.y - 1.0);
    CGPoint northEastTile = CGPointMake(currentTile.x + 1.0, currentTile.y - 1.0);
    
    
    if ([self tileCoordIsMoveable:southTile] && (!CGPointEqualToPoint(southTile, _previousLocationTile)))
        return southTile;
    else if ([self tileCoordIsMoveable:westTile] && (!CGPointEqualToPoint(westTile, _previousLocationTile)))
        return westTile;
    else if ([self tileCoordIsMoveable:eastTile] && (!CGPointEqualToPoint(eastTile, _previousLocationTile)))
        return eastTile;
    else if ([self tileCoordIsMoveable:northTile] && (!CGPointEqualToPoint(northTile, _previousLocationTile)))
        return northTile;
    else if ([self tileCoordIsMoveable:southWestTile] && (!CGPointEqualToPoint(southWestTile, _previousLocationTile)))
        return southWestTile;
    else if ([self tileCoordIsMoveable:southEastTile] && (!CGPointEqualToPoint(southEastTile, _previousLocationTile)))
        return southEastTile;
    else if ([self tileCoordIsMoveable:northWestTile] && (!CGPointEqualToPoint(northWestTile, _previousLocationTile)))
        return northWestTile;
    else if ([self tileCoordIsMoveable:northEastTile] && (!CGPointEqualToPoint(northEastTile, _previousLocationTile)))
        return northEastTile;
    else
    {
        CCLOG(@"No adjacent moveable tiles found!");
        [self setDoneMoving:YES];
        return CGPointMake(-1.0, -1.0);
    }
}

-(CGPoint)findNextMovableTileFromTile:(CGPoint)currentTile andPreviousTile:(CGPoint)previousTile
{    
    CGPoint southTile = CGPointMake(currentTile.x, currentTile.y + 1.0);
    CGPoint northTile = CGPointMake(currentTile.x, currentTile.y - 1.0);
    CGPoint westTile = CGPointMake(currentTile.x - 1.0, currentTile.y);
    CGPoint eastTile = CGPointMake(currentTile.x + 1.0, currentTile.y);
    CGPoint southWestTile = CGPointMake(currentTile.x - 1.0, currentTile.y + 1.0);
    CGPoint southEastTile = CGPointMake(currentTile.x + 1.0, currentTile.y + 1.0);
    CGPoint northWestTile = CGPointMake(currentTile.x - 1.0, currentTile.y - 1.0);
    CGPoint northEastTile = CGPointMake(currentTile.x + 1.0, currentTile.y - 1.0);
    
    
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
        CCLOG(@"No adjacent moveable tiles found!");
        [self setDoneMoving:YES];
        return CGPointMake(-1.0, -1.0);
    }
}

-(void)createTravelPathArray
{
    _pathArray = [[NSMutableArray alloc] initWithCapacity:0];
    _currentPathIndex = 0;
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
        if (CGPointEqualToPoint(CGPointMake(-1.0, -1.0), [nextTile CGPointValue]))
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

-(void)moveTowardsGoal
{
    //CCLOG(@"I SHOULD BE MOVING TOWARDS THE GOAL");
    
    GameScene *currentScene = [[GameManager sharedManager] currentRunningGameScene];
    
    CGPoint nextTile = [self findNextMovableTile];
    if (CGPointEqualToPoint(nextTile, ccp(-1,-1)))
    {
        CCLOG(@"NO MOVEABLE TILE FOUND");
        return;
    }
    
    
    CGPoint tileCoord = [currentScene tileMapCoordForPosition:self.position];
    _previousLocationTile = tileCoord;
    
    self.nextDestination = [currentScene positionForTileCoord:nextTile];
    
    CCAction *moveAction;
    CGPoint offSet;
    float distance;
    float travelTime;
    
    offSet.x = ABS(self.position.x - self.nextDestination.x);
    offSet.y = ABS(self.position.y - self.nextDestination.y);
    distance = sqrt((offSet.x * offSet.x) + (offSet.y * offSet.y));
    travelTime = (distance / self.movementSpeed);
    
    moveAction = [CCMoveTo actionWithDuration:travelTime position:self.nextDestination];
    [self runAction:moveAction];
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
        _movementSpeed = 50.0;
        
        _previousLocationTile = ccp(-1,-1);
        _assignedPath = nil;
        _nextDestination = ccp(0,0);
        _doneMoving = NO;
    }
    return self;
}

@end
