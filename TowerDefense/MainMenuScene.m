//
//  MainMenuScene.m
//  TowerDefense
//
//  Created by Benjamin Chen on 4/16/13.
//
//

#import "MainMenuScene.h"
#import "MainMenuLayer.h"

@implementation MainMenuScene

#pragma mark - Initialization
- (id)init
{
    self = [super init];
    if (self)
    {
        mainMenuLayer = [MainMenuLayer node];
        [self addChild:mainMenuLayer];
    }
    
    return self;
}

@end
