//
//  TowerProjectile.h
//  TowerDefense
//
//  Created by Benjamin Chen on 4/29/13.
//
//

#import "GameObject.h"
#import "GameConstants.h"
#import "GameManager.h"

@interface TowerProjectile : GameObject
{
    NSUInteger _damage;
    CGFloat _speed;
    ProjectileState _projectileState;
    
    MonsterObject *_target;
}

@property (nonatomic,readwrite) NSUInteger damage;
@property (nonatomic,readwrite) CGFloat speed;
@property (nonatomic,readwrite) ProjectileState projectileState;
@property (nonatomic,readwrite,assign) MonsterObject *target;

+(TowerProjectile *)shootProjectile:(NSString *)image WithDamage:(CGFloat)myDamage andSpeed:(CGFloat)mySpeed atMonster:(MonsterObject *)myTarget;
-(void)changeState:(ProjectileState)newState;
-(void)attackCurrentTarget;
-(void)damageCurrentTarget;

@end
