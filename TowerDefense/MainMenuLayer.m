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
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    CCLabelBMFont *titleScreenSceneLabel = [CCLabelBMFont labelWithString:@"Title Scene" fntFile:@"MainMenuFonts.fnt"];
    CCMenuItemLabel *playTitleScene = [CCMenuItemLabel itemWithLabel:titleScreenSceneLabel target:self selector:@selector(playScene:)];
    [playTitleScene setTag:kTitleScreenScene];
    CCLabelBMFont *tiledSceneLabel = [CCLabelBMFont labelWithString:@"Tiled Scene" fntFile:@"MainMenuFonts.fnt"];
    CCMenuItemLabel *playTiledScene = [CCMenuItemLabel itemWithLabel:tiledSceneLabel target:self selector:@selector(playScene:)];
    [playTiledScene setTag:kTiledScene];
    CCLabelBMFont *mapScreenSceneLabel = [CCLabelBMFont labelWithString:@"Level Select" fntFile:@"MainMenuFonts.fnt"];
    CCMenuItemLabel *playMapScreenScene = [CCMenuItemLabel itemWithLabel:mapScreenSceneLabel target:self selector:@selector(playScene:)];
    [playMapScreenScene setTag:kMapScreenScene];
    
    mainMenu = [CCMenu menuWithItems:playTitleScene, playTiledScene, playMapScreenScene, nil];
    [mainMenu alignItemsVerticallyWithPadding:screenSize.height * 0.001];
    NSLog(@"Width: %g, Height: %g", screenSize.width, screenSize.height);
    [mainMenu setPosition:ccp(screenSize.width - 100.0, 75.0)];
    
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
        CCLOG(@"MAIN MENU INIT");
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        CCSprite *background = [CCSprite spriteWithFile:@"background.png"];
        [background setPosition:ccp(screenSize.width/2, screenSize.height/2)];
        [self addChild:background];
        
        [self displayMainMenu];
    }
    
    return self;
}

@end
