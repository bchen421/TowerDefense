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
@synthesize touchedTowerNode=_touchedTowerNode;

#pragma mark - Touch Management
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    GameScene *currentScene = [[GameManager sharedManager] currentRunningGameScene];
    BOOL inTowerNode = NO;
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    CGPoint tileCoord = [currentScene tileMapCoordForPosition:touchLocation];
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
     
    NSUInteger tileGID = [[currentScene metadataLayer] tileGIDAt:tileCoord];
    if (tileGID)
    {
        NSDictionary *properties = [[currentScene tileMap] propertiesForGID:tileGID];
        if (properties)
        {
            inTowerNode = [[properties valueForKey:@"towerNode"] boolValue];
        }
        else
        {
            inTowerNode = NO;
        }
    }
    else
    {
        inTowerNode = NO;
    }
        
    return inTowerNode;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    GameScene *currentScene = [[GameManager sharedManager] currentRunningGameScene];
    
    if (CGRectContainsPoint(self.touchedTowerNode, touchLocation))
    {
        CGPoint towerLocation = CGPointMake(self.touchedTowerNode.origin.x + self.touchedTowerNode.size.width/2.0, self.touchedTowerNode.origin.y + self.touchedTowerNode.size.height/2.0);
        [[GameManager sharedManager] spawnTower:kBlueTower forScene:currentScene atLocation:towerLocation];
    }
}

#pragma mark - Tilemap Management Methods
-(void)translateViewBy:(CGPoint)translation
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGSize levelSize = [[GameManager sharedManager] dimensionsOfCurrentScene];
    CCTMXTiledMap *currentMap = [[[GameManager sharedManager] currentRunningGameScene] tileMap];
    CGPoint newPosition = ccp((currentMap.position.x - translation.x), (currentMap.position.y - translation.y));
    
    if (newPosition.x > 0)
    {
        newPosition.x = MIN(newPosition.x / 2.0, 100.0);
    }
    else if (newPosition.x < -(levelSize.width - screenSize.width))
    {
        float diff = newPosition.x - -(levelSize.width - screenSize.width);
        newPosition.x = MAX(newPosition.x - diff/2.0, -(levelSize.width - screenSize.width + 100.0));
    }
    
    if (newPosition.y > 0)
    {
        newPosition.y = MIN(newPosition.y / 2.0, 100.0);
    }
    else if (newPosition.y < -(levelSize.height - screenSize.height))
    {
        float diff = newPosition.y - -(levelSize.height - screenSize.height);
        newPosition.y = MAX(newPosition.y - diff/2.0, -(levelSize.height - screenSize.height + 100.0));
    }
    
    CCLOG(@"NEWPOSITION X: %g Y: %g", newPosition.x, newPosition.y);
    [self setPosition:newPosition];
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
