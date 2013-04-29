//
//  TowerObject.h
//  TowerDefense
//
//  Created by Benjamin Chen on 4/25/13.
//
//

#import "GameObject.h"
#import "GameConstants.h"
@class MonsterObject;

@interface TowerObject : GameObject <CCTargetedTouchDelegate>
{
    TowerID _towerID;
    TowerState _towerState;
    CGFloat _attackRate;
    CGFloat _attackRange;
    CCSprite *_rangeFinder;
    
    MonsterObject *_currentTarget;
}

@property (nonatomic,readwrite) TowerID towerID;
@property (nonatomic,readwrite) TowerState towerState;
@property (nonatomic,readwrite) CGFloat attackRate;
@property (nonatomic,readwrite) CGFloat attackRange;
@property (nonatomic,assign,readwrite) MonsterObject *currentTarget;

-(void)changeState:(TowerState)newState;
-(void)findTargetFrom:(CCArray *)listOfGameObjects;
-(void)attackCurrentTarget;
-(void)createRangeFinder;
-(BOOL)isMonsterInRange:(MonsterObject *)monster;

@end
