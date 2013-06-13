//
//  GameUILayer.h
//  TowerDefense
//
//  Created by Benjamin Chen on 4/25/13.
//
//

#import "cocos2d.h"

@interface GameUILayer : CCLayer <CCTargetedTouchDelegate>
{
    CGRect _touchedTowerNode;
    CGPoint _startingTouchLocation;     // This holds touch location based on the tiled map to be use for interaction calculations
    CGPoint _scrollingTouchLocation;            // This holds touch location based on the scene to be used for velocity calculations
    long unsigned int _startingTouchTime;
    BOOL _beingTouched;
    BOOL _touchMoved;
}

@property (readwrite) CGRect touchedTowerNode;
@property (nonatomic, readwrite) CGPoint startingTouchLocation;
@property (nonatomic, readwrite) CGPoint scrollingTouchLocation;

-(void)translateViewBy:(CGPoint)translation;
-(void)scrollViewBy:(CGPoint)translation;
-(BOOL)checkTouchInTower:(CGPoint)touchLocation;
-(CGPoint)towerNodeAtTouchLocation:(CGPoint)touchLocation;

@end
