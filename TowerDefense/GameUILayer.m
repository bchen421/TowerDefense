//
//  GameUILayer.m
//  TowerDefense
//
//  Created by Benjamin Chen on 4/25/13.
//
//

#import "GameUILayer.h"
#import "GameConstants.h"
#import "GameManager.h"

@implementation GameUILayer
@synthesize touchedTowerNode = _touchedTowerNode, startingTouchLocation = _startingTouchLocation, scrollingTouchLocation = _scrollingTouchLocation;

#pragma mark - Internal Helper Methods
-(BOOL)checkTouchInTower:(CGPoint)touchLocation
{
    GameScene *currentScene = [[GameManager sharedManager] currentRunningGameScene];
    CGSize levelSize = [[GameManager sharedManager] dimensionsOfCurrentScene];
    CGRect levelBoundingBox = CGRectMake(0.0, 0.0, levelSize.width, levelSize.height);
    CGPoint tileCoord = [currentScene tileMapCoordForPosition:touchLocation];
    BOOL returnValue = NO;

    if (CGRectContainsPoint(levelBoundingBox, touchLocation))
    {
        NSUInteger tileGID = [[currentScene metadataLayer] tileGIDAt:tileCoord];
        if (tileGID)
        {
            NSDictionary *properties = [[currentScene tileMap] propertiesForGID:tileGID];
            if (properties)
            {
                returnValue = [[properties valueForKey:@"towerNode"] boolValue];
            }
        }
    }
    
    return returnValue;
}

-(CGPoint)towerNodeAtTouchLocation:(CGPoint)touchLocation
{
    GameScene *currentScene = [[GameManager sharedManager] currentRunningGameScene];
    CGPoint tileCoord = [currentScene tileMapCoordForPosition:touchLocation];
    CGPoint towerLocation;
    BOOL retina = [[[[currentScene tileMap] properties] valueForKey:@"retina"] boolValue];
    if (retina)
    {
        CGSize tileSize = [[currentScene tileMap] tileSize];
        CGPoint originPoint = [[currentScene metadataLayer] positionAt:tileCoord];
        self.touchedTowerNode = CGRectMake(originPoint.x, originPoint.y, tileSize.width/2.0, tileSize.height/2.0);
        towerLocation = CGPointMake(originPoint.x + tileSize.width/4.0, originPoint.y + tileSize.height/4.0);
    }
    else
    {
        CGSize tileSize = [[currentScene tileMap] tileSize];
        CGPoint originPoint = [[currentScene metadataLayer] positionAt:tileCoord];
        towerLocation = CGPointMake(originPoint.x + tileSize.width/2.0, originPoint.y + tileSize.height/2.0);
    }
    
    return towerLocation;
}

#pragma mark - Game Tilemap View Management
-(void)translateViewBy:(CGPoint)translation
{
    GameScene *currentScene = [[GameManager sharedManager] currentRunningGameScene];
    CCTMXTiledMap *tiledMap = [currentScene tileMap];
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGSize levelSize = [[GameManager sharedManager] dimensionsOfCurrentScene];
    CGPoint newPosition = ccp((tiledMap.position.x - translation.x), (tiledMap.position.y - translation.y));
    
    if (newPosition.x > 0)
    {
        newPosition.x = MIN(newPosition.x / 2.0, 10.0);
    }
    else if (newPosition.x < -(levelSize.width - screenSize.width))
    {
        float diff = newPosition.x - -(levelSize.width - screenSize.width);
        newPosition.x = MAX(newPosition.x - diff/2.0, -(levelSize.width - screenSize.width + 10.0));
    }
    
    if (newPosition.y > 0)
    {
        newPosition.y = MIN(newPosition.y / 2.0, 10.0);
    }
    else if (newPosition.y < -(levelSize.height - screenSize.height))
    {
        float diff = newPosition.y - -(levelSize.height - screenSize.height);
        newPosition.y = MAX(newPosition.y - diff/2.0, -(levelSize.height - screenSize.height + 10.0));
    }
    
    newPosition.x = round(newPosition.x);
    newPosition.y = round(newPosition.y);
    
    [tiledMap setPosition:newPosition];
}

-(void)scrollViewBy:(CGPoint)translation
{
    GameScene *currentScene = [[GameManager sharedManager] currentRunningGameScene];
    CCTMXTiledMap *tiledMap = [currentScene tileMap];
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGSize levelSize = [[GameManager sharedManager] dimensionsOfCurrentScene];
    CGPoint newPosition = ccp((tiledMap.position.x - translation.x), (tiledMap.position.y - translation.y));
    
    if (newPosition.x > 0)
    {
        newPosition.x = 0;
    }
    else if (newPosition.x < -(levelSize.width - screenSize.width))
    {
        newPosition.x = -(levelSize.width - screenSize.width);
    }
    
    if (newPosition.y > 0)
    {
        newPosition.y = 0;
    }
    else if (newPosition.y < -(levelSize.height - screenSize.height))
    {
        newPosition.y = -(levelSize.height - screenSize.height);
    }
    
    newPosition.x = round(newPosition.x);
    newPosition.y = round(newPosition.y);
    
    CCMoveTo *moveTo = [CCMoveTo actionWithDuration:(6.0/60.0) position:newPosition];
    [tiledMap runAction:moveTo];
}

#pragma mark - Touch Management
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"TOUCH BEGAN");
    _beingTouched = YES;
    _touchMoved = NO;
    
    GameScene *currentScene = [[GameManager sharedManager] currentRunningGameScene];
    struct timeval time;
    gettimeofday(&time, NULL);
    _startingTouchTime = (time.tv_sec * 1000) + (time.tv_usec / 1000);
    // POC code
    [[currentScene tileMap] stopAllActions];
    CGPoint touchLocation = [[currentScene tileMap] convertTouchToNodeSpace:touch];
    
    self.startingTouchLocation = touchLocation;
    self.scrollingTouchLocation = [currentScene convertTouchToNodeSpace:touch];
    
    return YES;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    GameScene *currentScene = [[GameManager sharedManager] currentRunningGameScene];
    _touchMoved = YES;
    CGPoint touchLocation = [[currentScene tileMap] convertTouchToNodeSpace:touch];
    CGPoint translation = ccp(self.startingTouchLocation.x - touchLocation.x, self.startingTouchLocation.y - touchLocation.y);
    [self translateViewBy:translation];
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    _beingTouched = NO;
    GameScene *currentScene = [[GameManager sharedManager] currentRunningGameScene];
    CGPoint touchLocation = [[currentScene tileMap] convertTouchToNodeSpace:touch];
    CGPoint scrolledToLocation = [currentScene convertTouchToNodeSpace:touch];
    
    if (!_touchMoved)
    {
        if ([self checkTouchInTower:touchLocation])
        {
            [[GameManager sharedManager] spawnTower:kBlueTower forScene:currentScene atLocation:[self towerNodeAtTouchLocation:touchLocation]];
        }
    }
    else
    {
        CCLOG(@"TOUCH ENDED");
        struct timeval time;
        gettimeofday(&time, NULL);
        long unsigned int currentTime = (time.tv_sec * 1000) + (time.tv_usec / 1000);
        unsigned int deltaTime = currentTime - _startingTouchTime;
        CCLOG(@"TIME: %lu", currentTime);
        
        CGPoint velocity = ccp((self.scrollingTouchLocation.x - scrolledToLocation.x)/deltaTime, (self.scrollingTouchLocation.y - scrolledToLocation.y)/deltaTime);
        velocity = ccpMult(velocity, 100.0);
        [self scrollViewBy:velocity];
    }
}

#pragma mark - Touch Delegate Management
- (void) onEnterTransitionDidFinish
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
}

- (void) onExit
{
	[[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
}

@end
