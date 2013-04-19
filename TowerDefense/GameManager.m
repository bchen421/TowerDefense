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
#import "SandboxScene.h"
#import "IntroLayer.h"

// Monster Headers
#import "OrcMonster.h"


@implementation GameManager
static GameManager * _sharedGameManager = nil;

#pragma mark - Monster Spawning
-(MonsterObject *)spawnMonster:(MonsterID)monsterID
{
    MonsterObject *newMonster = nil;
    
    switch (monsterID)
    {
        case kOrc:
            newMonster = [OrcMonster spawnOrc];
            break;
            
        default:
            CCLOG(@"Unknown Monster ID");
            return nil;
            break;
    }
    
    return newMonster;
}


#pragma mark - Scene Management
-(CGSize)getDimensionsOfCurrentScene
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGSize levelSize;
    
    switch (_currentScene)
    {
        case kMainMenuScene:
            levelSize = screenSize;
            break;
            
        case kIntroScene:
            levelSize = screenSize;
            break;

        case kSandboxScene:
            levelSize = screenSize;
            break;
            
        case kTiledScene:
            levelSize = CGSizeMake(screenSize.width * 4.0f, screenSize.height * 0.8f);
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
    GameSceneID oldScene = _currentScene;
    _currentScene = sceneID;
    
    id sceneToRun = nil;
    switch (sceneID)
    {
        case kNoScene:
            CCLOG(@"Tried to run no scene!");
            break;
            
        case kIntroScene:
            sceneToRun = [IntroLayer node];
            break;
        
        case kMainMenuScene:
            sceneToRun = [MainMenuScene node];
            break;
        
        case kSandboxScene:
            sceneToRun = [SandboxScene node];
            break;
        /*
        case kTiledScene:
            sceneToRun = [TiledScene node];
            break;
        */
        default:
            CCLOG(@"Unknown Scene ID, cannot switch scenes");
            return;
            break;
    }
    if (sceneToRun == nil)
    {
        _currentScene = oldScene;
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
        _currentScene = kNoScene;
    }
    return self;
}

@end
