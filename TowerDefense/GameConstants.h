//
//  GameConstants.h
//  Tower Defense
//
//  Created by Benjamin Chen on 4/15/13.
//
//

typedef enum
{
    kNoScene,
    kTitleScreenScene,
    kMainMenuScene,
    kTiledScene
} GameSceneID;

typedef enum
{
    kGenericGameObject,
    kMonsterObject,
    kTowerObject,
    kTowerProjectileObject,
} GameObjectType;

typedef enum
{
    kGenericMonster,
    kOrc,
    kBigOrc,
} MonsterID;

typedef enum
{
    kMonsterIdle,
    kMonsterMoving,
    kMonsterDead,
} MonsterState;

typedef enum
{
    kGenericTower,
    kBlueTower,
} TowerID;

typedef enum
{
    kTowerIdle,
    kTowerAttacking,
} TowerState;

typedef enum
{
    kProjectileIdle,
    kProjectileAttacking,
    kProjectileDead
} ProjectileState;