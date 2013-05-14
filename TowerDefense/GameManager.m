//
//  GameManager.m
//  Tower Defense
//
//  Created by Benjamin Chen on 4/15/13.
//
//

// Layer Headers
#import "GameManager.h"
#import "MainMenuScene.h"
#import "TiledScene.h"
#import "TitleScreenScene.h"
#import "MapScreenScene.h"

// Monster Headers
#import "OrcMonster.h"

// Tower Headers
#import "BlueTower.h"


@implementation GameManager
static GameManager * _sharedGameManager = nil;

#pragma mark - Tower Factory
-(void)spawnTower:(TowerID)towerID forScene:(GameScene *)gameScene atLocation:(CGPoint)spawnLocation
{
    TowerObject *newTower = nil;
    
    switch (towerID)
    {
        case kBlueTower:
            newTower = [BlueTower spawnTower];
            break;
            
        default:
            CCLOG(@"Unknown Tower ID");
            break;
    }
    
    if (newTower)
    {
        [newTower setPosition:spawnLocation];
        [[gameScene sceneSpriteBatchNode] addChild:newTower z:10];
    }
}

#pragma mark - Monster Factory
-(MonsterObject *)spawnMonster:(MonsterID)monsterID withGoalLocation:(CGPoint)goalLocation
{
    MonsterObject *newMonster = nil;
    
    switch (monsterID)
    {
        case kOrc:
            newMonster = [OrcMonster spawnOrc];
            break;
            
        case kBigOrc:
            newMonster = [OrcMonster spawnBigOrc];
            break;
        default:
            CCLOG(@"Unknown Monster ID");
            return nil;
            break;
    }
    
    [newMonster setGoalLocation:goalLocation];
    return newMonster;
}

#pragma mark - Scene Management
-(CGSize)dimensionsOfCurrentScene
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGSize levelSize;
    
    switch (_currentSceneID)
    {
        case kMainMenuScene:
            levelSize = screenSize;
            break;
            
        case kTiledScene:
            levelSize = screenSize;
            break;
            
        default:
            CCLOG(@"Unknown Scene, returning default size");
            levelSize = screenSize;
            break;
    }
    return levelSize;
}

-(void)runGameScene:(GameSceneID)sceneID
{
    GameSceneID oldSceneID = _currentSceneID;
    _currentSceneID = sceneID;
    
    id sceneToRun = nil;
    switch (sceneID)
    {
        case kNoScene:
            CCLOG(@"Tried to run no scene!");
            break;
            
        case kTitleScreenScene:
            sceneToRun = [CCTransitionFade transitionWithDuration:1.0f scene:[TitleScreenScene node] withColor:ccWHITE];
            break;
                    
        case kMainMenuScene:
            sceneToRun = [MainMenuScene node];
            break;
            
        case kMapScreenScene:
            sceneToRun = [CCTransitionFade transitionWithDuration:1.0f scene:[MapScreenScene node] withColor:ccWHITE];
            break;
        
        case kTiledScene:
            sceneToRun = [TiledScene node];
            break;
        
        default:
            CCLOG(@"Unknown Scene ID, cannot switch scenes");
            return;
            break;
    }
    if (sceneToRun == nil)
    {
        _currentSceneID = oldSceneID;
        return;
    }
    
    if ([[CCDirector sharedDirector] runningScene] == nil)
    {
        [[CCDirector sharedDirector] runWithScene:sceneToRun];
    }
    else
    {
        [[CCDirector sharedDirector] replaceScene:sceneToRun];
    }
}

-(GameScene *)currentRunningGameScene;
{
    switch (_currentSceneID)
    {
        case kNoScene:
            return nil;
            break;
            
        case kMainMenuScene:
            return nil;
            break;
            
        default:
            return (GameScene *)[[CCDirector sharedDirector] runningScene];
            break;
    }
}

#pragma mark - Class Methods
+(GameManager*)sharedManager
{
    @synchronized([GameManager class])
    {
        if(!_sharedGameManager)
            [[self alloc] init];
        return _sharedGameManager;
    }
    return nil;
}

#pragma mark - Inititalization
+(id)alloc
{
    @synchronized ([GameManager class])
    {
        NSAssert(_sharedGameManager == nil,
                 @"Attempted to allocated a second instance of the Game Manager singleton"); // 6
        _sharedGameManager = [super alloc];
        return _sharedGameManager;                                 // 7
    }
    return nil;
}

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        // Game Manager initialized
        CCLOG(@"Game Manager Singleton, init");
        _currentSceneID = kNoScene;
    }
    return self;
}

@end
