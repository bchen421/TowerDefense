//
//  MainMenuLayer.m
//  TowerDefense
//
//  Created by Benjamin Chen on 4/16/13.
//
//

#import "MainMenuLayer.h"
//#import "GameConstants.h"
#import "GameManager.h"

@implementation MainMenuLayer

-(void)displayMainMenu
{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    CCLabelBMFont *introSceneLabel = [CCLabelBMFont labelWithString:@"Intro Scene" fntFile:@"MainMenuFonts.fnt"];
    CCMenuItemLabel *playIntroScene = [CCMenuItemLabel itemWithLabel:introSceneLabel target:self selector:@selector(playScene:)];
    [playIntroScene setTag:kIntroScene];
    
    CCLabelBMFont *tiledSceneLabel = [CCLabelBMFont labelWithString:@"Tiled Scene" fntFile:@"MainMenuFonts.fnt"];
    CCMenuItemLabel *playTiledScene = [CCMenuItemLabel itemWithLabel:tiledSceneLabel target:self selector:@selector(playScene:)];
    [playTiledScene setTag:kTiledScene];
    
    mainMenu = [CCMenu menuWithItems:playTiledScene, playIntroScene, nil];
    [mainMenu alignItemsVerticallyWithPadding:screenSize.height * 0.001];
    NSLog(@"Width: %g, Height: %g", screenSize.width, screenSize.height);
    [mainMenu setPosition:ccp(screenSize.height - 100.0, 75.0)];
    
    [self addChild:mainMenu z:1];
}

-(void)playScene:(CCMenuItemFont*)itemPassedIn
{
    [[GameManager sharedManager] runGameScene:[itemPassedIn tag]];
}

#pragma mark Initialization
- (id)init
{
    self = [super init];
    if (self)
    {
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        CCSprite *background = [CCSprite spriteWithFile:@"background.png"];
        [background setPosition:ccp(screenSize.width/2, screenSize.height/2)];
        [self addChild:background];
        
        [self displayMainMenu];
    }
    
    return self;
}

@end
