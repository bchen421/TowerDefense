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
    CGPoint touchLocation = [parent_ convertTouchToNodeSpace:touch];
    CGPoint tileCoord = [currentScene tileMapCoordForPosition:touchLocation];
    BOOL retina = [[[[currentScene objectData] properties] valueForKey:@"retina"] boolValue];
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
