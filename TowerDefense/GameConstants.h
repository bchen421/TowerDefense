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
} GameObjectType;

typedef enum
{
    kGenericMonster,
    kOrc,
    kBigOrc,
} MonsterID;

typedef enum
{
    kStateIdle,
    kStateMoving,
} MonsterState;

typedef enum
{
    kNorth,
    kSouth,
    kEast,
    kWest,
    kNeutral,
    kNorthEast,
    kNorthWest,
    kSouthEast,
    kSouthWest
} Direction;

typedef enum
{
    kMovementAction,
    kMovementAnim,
    kWalkingAction,
    kRecoveryAction,
    kPursueAction
} actionTags;