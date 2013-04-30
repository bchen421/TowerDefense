//
//  TowerProjectile.m
//  TowerDefense
//
//  Created by Benjamin Chen on 4/29/13.
//
//

#import "TowerProjectile.h"

@implementation TowerProjectile
@synthesize damage=_damage, speed=_speed, projectileState=_projectileState, target=_target;

#pragma mark - State Management Methods
-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects
{
    if (self.projectileState == kProjectileIdle && self.target)
    {
        [self changeState:kProjectileAttacking];
    }
    else if (self.projectileState == kProjectileDead)
    {
        [self removeFromParentAndCleanup:YES];
    }
}

-(void)changeState:(ProjectileState)newState
{
    self.projectileState = newState;
    
    switch (newState)
    {
        case kProjectileIdle:
            CCLOG(@"Projectile is idle!");
            break;
            
        case kProjectileAttacking:
            CCLOG(@"Projectile is starting to attack!");
            [self attackCurrentTarget];
            break;
            
        case kProjectileDead:
            CCLOG(@"I AM DEAD");
            break;
            
        default:
            break;
    }
}

-(void)attackCurrentTarget
{
    CCAction *attackAction = [CCSequence actions:[CCMoveTo actionWithDuration:0.25f position:self.target.position], [CCCallFunc actionWithTarget:self selector:@selector(damageCurrentTarget)], nil];
        
    [self runAction:attackAction];
}

-(void)damageCurrentTarget
{
    [self.target takeDamage:[self damage]];
    [self changeState:kProjectileDead];
}


#pragma mark - Factory
+(TowerProjectile *)shootProjectile:(NSString *)image WithDamage:(CGFloat)myDamage andSpeed:(CGFloat)mySpeed atMonster:(MonsterObject *)myTarget
{
    TowerProjectile *newProjectile = [[TowerProjectile alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:image]];
    [newProjectile setDamage:myDamage];
    [newProjectile setSpeed:mySpeed];
    [newProjectile setTarget:myTarget];
        
    return newProjectile;
}

#pragma mark - Initialization
-(id)initWithSpriteFrame:(CCSpriteFrame*)spriteFrame
{
    if ((self = [super initWithSpriteFrame:spriteFrame]))
    {
        _gameObjectType = kTowerProjectileObject;
        _projectileState = kProjectileIdle;
    }
    return self;
}


@end
