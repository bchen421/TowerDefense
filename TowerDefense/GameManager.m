//
//  GameManager.m
//  Tower Defense
//
//  Created by Benjamin Chen on 4/15/13.
//
//

#import "GameManager.h"
#import "IntroLayer.h"

@implementation GameManager
static GameManager * _sharedGameManager = nil;

#pragma mark - Scene Management
-(CGSize)getDimensionsOfCurrentScene
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGSize levelSize;
    
    switch (currentScene)
    {
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
    GameSceneID oldScene = currentScene;
    currentScene = sceneID;
    
    id sceneToRun = nil;
    switch (sceneID)
    {
        case kNoScene:
            CCLOG(@"Tried to run no scene!");
            break;
            
        case kIntroScene:
            sceneToRun = [IntroLayer node];
            break;
        /*
        case kMainMenuScene:
            sceneToRun = [MainMenuScene node];
            break;
        
        case kSandboxScene:
            sceneToRun = [SandboxScene node];
            break;
             
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
        currentScene = oldScene;
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
        currentScene = kNoScene;
    }
    return self;
}

@end
