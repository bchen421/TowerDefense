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
    
    CGPoint _previousLocationTile;
    NSString *_assignedPath;
    CGPoint _nextDestination;
}

@property (nonatomic,readwrite) MonsterID monsterID;
@property (nonatomic,readwrite) MonsterState monsterState;
@property (nonatomic,readwrite) NSInteger maxHP;
@property (nonatomic,readwrite) NSInteger currentHP;
@property (nonatomic,readwrite) CGFloat movementSpeed;
@property (nonatomic,readwrite) CGPoint goalLocation;

@property (nonatomic,readwrite) CGPoint previousLocationTile;
@property (nonatomic,copy,readwrite) NSString *assignedPath;
@property (nonatomic,readwrite) CGPoint nextDestination;

-(void)changeState:(MonsterState)newState;
-(void)takeDamage:(NSInteger)amount;
-(void)hasDied;
-(BOOL)tileCoordIsMoveable:(CGPoint)coord;
-(CGPoint)findNextMovableTile;
-(CGPoint)positionForTileCoord:(CGPoint)tileCoord;
-(void)moveTowardsGoal;

@end
