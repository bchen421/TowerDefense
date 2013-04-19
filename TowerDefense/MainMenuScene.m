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

@synthesize mainMenulayer = _mainMenuLayer;

#pragma mark - Initialization
- (id)init
{
    self = [super init];
    if (self)
    {
        _mainMenuLayer = [MainMenuLayer node];
        [self addChild:_mainMenuLayer];
    }
    
    return self;
}

@end
