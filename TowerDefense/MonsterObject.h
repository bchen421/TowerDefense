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
    
    NSString *_assignedPath;
    CGPoint _nextDestination;
    BOOL _doneMoving;
    NSMutableArray *_pathArray;
    NSUInteger _currentPathIndex;
}

@property (nonatomic,readwrite) MonsterID monsterID;
@property (nonatomic,readwrite) MonsterState monsterState;
@property (nonatomic,readwrite) NSInteger maxHP;
@property (nonatomic,readwrite) NSInteger currentHP;
@property (nonatomic,readwrite) CGFloat movementSpeed;
@property (nonatomic,readwrite) CGPoint goalLocation;

@property (nonatomic,copy,readwrite) NSString *assignedPath;
@property (nonatomic,readwrite) CGPoint nextDestination;
@property (nonatomic,readwrite) BOOL doneMoving;
@property (nonatomic,readonly) NSMutableArray *pathArray;
@property (nonatomic,readonly) NSUInteger currentPathIndex;

-(void)changeState:(MonsterState)newState;
-(void)takeDamage:(NSInteger)amount;
-(void)hasDied;
-(void)findAssignedPath;
-(BOOL)tileCoordIsMoveable:(CGPoint)coord;
-(void)createTravelPathArray;
-(void)moveTowardsGoalWithDeltaTime:(ccTime)dt;

@end
