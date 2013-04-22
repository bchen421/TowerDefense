//
//  SandboxLayer.m
//  TowerDefense
//
//  Created by Benjamin Chen on 4/17/13.
//
//

#import "SandboxLayer.h"

@implementation SandboxLayer

#pragma mark - Initialization
-(id)init
{
    self = [super init];
    if (self != nil)
    {
        CGSize screenSize = [[CCDirector sharedDirector] winSize];

        CCSprite *backgroundImage;
        backgroundImage = [CCSprite spriteWithFile:@"background.png"];
        [backgroundImage setPosition: CGPointMake(screenSize.width/2, screenSize.height/2)];
                
        [self addChild:backgroundImage z:0];
    }
    return self;
}

@end
