//
//  GameConstants.h
//  Tower Defense
//
//  Created by Benjamin Chen on 4/15/13.
//
//

#ifndef Tower_Defense_GameConstants_h
#define Tower_Defense_GameConstants_h

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
    kMonsterObject
} GameObjectType;

typedef enum
{
    kAwesomeBlossom,
    kGenericMonster,
    kOrc,
} MonsterID;

typedef enum
{
    kStateIdle,
    kStateWalking,
    kStateRoll,
    kStateRunning,
    kStateDefending,
    kStateAttacking,
    kStateTakingDamage,
    kStateDead,
    kStatePursuing,
    kStateInRange,
    kStateBlockingAttack,
    kStatePause,
    kStateUpStartup,
    kStateUpAttack,
    kStateUpRecovery,
    kStateRightAttack
} GameObjectState;

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

#endif
