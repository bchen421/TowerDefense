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
    kIntroScene,
    kMainMenuScene,
    kSandboxScene,
    kTiledScene
} GameSceneID;

typedef enum
{
    kGenericGameObject,
    kMonsterObject,
    kTowerObject,
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