//
//  MonsterObject.h
//  TowerDefense
//
//  Created by Benjamin Chen on 4/18/13.
//
//

#import "GameObject.h"
#import "GameConstants.h"

@interface MonsterObject : GameObject
{
    MonsterID _monsterID;
    MonsterState _monsterState;
    NSInteger _maxHP;
    NSInteger _currentHP;
    CGFloat _movementSpeed;
    CGPoint _goalLocation;
}

@property (nonatomic,readwrite) MonsterID monsterID;
@property (nonatomic,readwrite) MonsterState monsterState;
@property (nonatomic,readwrite) NSInteger maxHP;
@property (nonatomic,readwrite) NSInteger currentHP;
@property (nonatomic,readwrite) CGFloat movementSpeed;
@property (nonatomic,readwrite) CGPoint goalLocation;

-(void)changeState:(MonsterState)newState;
-(void)takeDamage:(NSInteger)amount;
-(void)hasDied;

@end
