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

@interface TowerObject : GameObject
{
    TowerID _towerID;
    TowerState _towerState;
    CGFloat _attackSpeed;
    CGFloat _attackRange;
    
    MonsterObject *_currentTarget;
}

@property (nonatomic,readwrite) TowerID towerID;
@property (nonatomic,readwrite) TowerState towerState;
@property (nonatomic,readwrite) CGFloat attackSpeed;
@property (nonatomic,readwrite) CGFloat attackRange;
@property (nonatomic,assign,readwrite) MonsterObject *currentTarget;

-(void)changeState:(TowerState)newState;

@end
