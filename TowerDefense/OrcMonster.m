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

-(void)hasDied
{
    [self stopAllActions];
    //[self runAction:[CCBlink actionWithDuration:1.0 blinks:5]];
    //[self removeFromParentAndCleanup:YES];
    CCAction *deathAction = [CCSequence actions:[CCBlink actionWithDuration:1.0 blinks:5], [CCCallFuncND actionWithTarget:self selector:@selector(removeFromParentAndCleanup:) data:YES], nil];
    [self runAction:deathAction];
}

#pragma mark - Movement Helper Methods
-(CGPoint)findNextMovableTile
{
    GameScene *currentScene = [[GameManager sharedManager] getCurrentRunningGameScene];
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
        return CGPointMake(-1.0, -1.0);
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

-(CGPoint)positionForTileCoord:(CGPoint)tileCoord
{
    GameScene *currentScene = [[GameManager sharedManager] getCurrentRunningGameScene];
    CGPoint position = [[currentScene metadataLayer] positionAt:tileCoord];
    CGSize tileSize = [[currentScene tileMap] tileSize];
    
    BOOL retina = [[[[currentScene objectData] properties] valueForKey:@"retina"] boolValue];
    
    if (retina)
    {
        return CGPointMake(position.x + tileSize.width/4.0, position.y + tileSize.height/4.0);
    }
    else
    {
        return CGPointMake(position.x + tileSize.width/2.0, position.y + tileSize.height/2.0);
    }
}

-(void)moveTowardsGoal
{
    CCLOG(@"I SHOULD BE MOVING TOWARDS THE GOAL");
    
    GameScene *currentScene = [[GameManager sharedManager] getCurrentRunningGameScene];

    CGPoint nextTile = [self findNextMovableTile];
    if (CGPointEqualToPoint(nextTile, ccp(-1,-1)))
    {
        CCLOG(@"NO MOVEABLE TILE FOUND");
        return;
    }
    

    CGPoint tileCoord = [currentScene tileMapCoordForPosition:self.position];
    _previousLocationTile = tileCoord;
    
     self.nextDestination = [self positionForTileCoord:nextTile];
    
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
