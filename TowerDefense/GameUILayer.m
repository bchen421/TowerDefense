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
@synthesize touchedTowerNode = _touchedTowerNode;

#pragma mark - Run Time Loop
-(void)update:(ccTime)deltaTime
{
    if ( (![self viewInBounds]) && !(_beingTouched) && ([[[GameManager sharedManager] currentRunningGameScene] numberOfRunningActions] == 0) )
    {
        [self returnInBounds];
    }
}

#pragma mark - Game Tilemap View Management
-(BOOL)viewInBounds
{
    GameScene *currentScene = [[GameManager sharedManager] currentRunningGameScene];
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGSize levelSize = [[GameManager sharedManager] dimensionsOfCurrentScene];
    if (currentScene.position.x > 0)
    {
        return NO;
    }
    else if (currentScene.position.x < -(levelSize.width - screenSize.width))
    {
        return NO;
    }
    
    if (currentScene.position.y > 0)
    {
        return NO;
    }
    else if (currentScene.position.y < -(levelSize.height - screenSize.height))
    {
        return NO;
    }
    
    return YES;
}

-(void)translateViewBy:(CGPoint)translation
{
    GameScene *currentScene = [[GameManager sharedManager] currentRunningGameScene];
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGSize levelSize = [[GameManager sharedManager] dimensionsOfCurrentScene];
    CGPoint newPosition = ccp((currentScene.position.x - translation.x), (currentScene.position.y - translation.y));
    /*    if (newPosition.x > 0)
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
    }*/
    
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
    
    CCLOG(@"NEWPOSITION X: %g Y: %g", newPosition.x, newPosition.y);
    [currentScene setPosition:newPosition];
}

-(void)scrollViewBy:(CGPoint)translation
{
    GameScene *currentScene = [[GameManager sharedManager] currentRunningGameScene];
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGSize levelSize = [[GameManager sharedManager] dimensionsOfCurrentScene];
    CGPoint newPosition = ccp((currentScene.position.x - translation.x), (currentScene.position.y - translation.y));
    
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
    [currentScene runAction:moveTo];
}

-(void)returnInBounds
{
    GameScene *currentScene = [[GameManager sharedManager] currentRunningGameScene];
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGSize levelSize = [[GameManager sharedManager] dimensionsOfCurrentScene];
    
    CGPoint newPosition = currentScene.position;
    
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
    
    CCMoveTo *moveTo = [CCMoveTo actionWithDuration:(12.0/60.0) position:newPosition];
    [currentScene runAction:moveTo];
}

#pragma mark - Touch Management
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    GameScene *currentScene = [[GameManager sharedManager] currentRunningGameScene];
    CGSize levelSize = [[GameManager sharedManager] dimensionsOfCurrentScene];
    CGRect levelBoundingBox = CGRectMake(0.0, 0.0, levelSize.width, levelSize.height);
    struct timeval time;
    gettimeofday(&time, NULL);
    _startingTouchTime = (time.tv_sec * 1000) + (time.tv_usec / 1000);
    [currentScene stopAllActions];
    
    _beingTouched = YES;
    _touchMoved = NO;
    _inTowerNode = NO;
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    CGPoint tileCoord = [currentScene tileMapCoordForPosition:touchLocation];
    
    self.startingTouchLocation = touchLocation;
    
    if (CGRectContainsPoint(levelBoundingBox, touchLocation))
    {
        NSUInteger tileGID = [[currentScene metadataLayer] tileGIDAt:tileCoord];
        if (tileGID)
        {
            NSDictionary *properties = [[currentScene tileMap] propertiesForGID:tileGID];
            if (properties)
            {
                _inTowerNode = [[properties valueForKey:@"towerNode"] boolValue];
                BOOL retina = [[[[currentScene tileMap] properties] valueForKey:@"retina"] boolValue];
                if (retina)
                {
                    CGSize tileSize = [[currentScene tileMap] tileSize];
                    CGPoint originPoint = [[currentScene metadataLayer] positionAt:tileCoord];
                    self.touchedTowerNode = CGRectMake(originPoint.x, originPoint.y, tileSize.width/2.0, tileSize.height/2.0);
                }
                else
                {
                    CGSize tileSize = [[currentScene tileMap] tileSize];
                    CGPoint originPoint = [[currentScene metadataLayer] positionAt:tileCoord];
                    self.touchedTowerNode = CGRectMake(originPoint.x, originPoint.y, tileSize.width, tileSize.height);
                }
            }
        }
    }
    
    return YES;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    _touchMoved = YES;
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    CGPoint translation = ccp(self.startingTouchLocation.x - touchLocation.x, self.startingTouchLocation.y - touchLocation.y);
    [self translateViewBy:translation];
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    _beingTouched = NO;
    GameScene *currentScene = [[GameManager sharedManager] currentRunningGameScene];
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    if (_inTowerNode && (!_touchMoved))
    {
        if (CGRectContainsPoint(self.touchedTowerNode, touchLocation))
        {
            CGPoint towerLocation = CGPointMake(self.touchedTowerNode.origin.x + self.touchedTowerNode.size.width/2.0, self.touchedTowerNode.origin.y + self.touchedTowerNode.size.height/2.0);
            [[GameManager sharedManager] spawnTower:kBlueTower forScene:currentScene atLocation:towerLocation];
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
        
        CGPoint velocity = ccp((self.startingTouchLocation.x - touchLocation.x)/deltaTime, (self.startingTouchLocation.y - touchLocation.y)/deltaTime);
        velocity = ccpMult(velocity, 1000.0);
        [self scrollViewBy:velocity];
    }
}

#pragma mark - Touch Delegate Management
- (void) onEnterTransitionDidFinish
{
    [self scheduleUpdate];
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
}

- (void) onExit
{
	[[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
}

@end
