//
//  TowerNode.m
//  TowerDefense
//
//  Created by Benjamin Chen on 6/18/13.
//
//

#import "TowerNode.h"
#import "GameManager.h"

@implementation TowerNode

#pragma mark - Touch Management
-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [parent_ convertTouchToNodeSpace:touch];
    if (CGRectContainsPoint([self boundingBox], touchLocation))
    {
        GameScene *currentScene = [[GameManager sharedManager] currentRunningGameScene];
        
        CGPoint towerPosition = [self position];
        [self removeFromParentAndCleanup:YES];
        
        [[GameManager sharedManager] spawnTower:kBlueTower forScene:currentScene atLocation:towerPosition];
    }
}

#pragma mark - Tower Factory
+(TowerObject *)spawnTower
{
    TowerObject *newTower = [[TowerNode alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"tower.png"]];
    [newTower setTowerID:kTowerNode];
    [newTower setColor:ccRED];
    
    return newTower;
}

#pragma mark - Initialization
-(id)initWithSpriteFrame:(CCSpriteFrame*)spriteFrame
{
    if (self = [super initWithSpriteFrame:spriteFrame])
    {
        _towerID = kTowerNode;
        _attackRate = 0.0;
        _attackRange = 0.0;
    }
    
    return self;
}

@end
