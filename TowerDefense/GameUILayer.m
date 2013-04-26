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

#pragma mark - Touch Management
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    GameScene *currentScene = [[GameManager sharedManager] getCurrentRunningGameScene];
    
    [[GameManager sharedManager] spawnTower:kBlueTower forScene:currentScene atLocation:touchLocation];
    /*
    if (specialButton.active)
    {
        if ((self.objectState == kStateDefending) || (self.objectState == kStateIdle) || (self.objectState == kStateRunning) || (self.objectState == kStateWalking) || (self.objectState == kStateUpRecovery))
        {
            CGPoint touchMoved = [parent_ convertTouchToNodeSpace:touch];
            CGPoint offSet;
            offSet.x = (touchMoved.x - touchBegin.x);
            offSet.y = (touchMoved.y - touchBegin.y);
        }
    }
     */
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
