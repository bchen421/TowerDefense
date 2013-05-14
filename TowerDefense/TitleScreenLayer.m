//
//  TitleScreenLayer.m
//  TowerDefense
//
//  Created by Benjamin Chen on 5/10/13.
//
//

#import "TitleScreenLayer.h"

@implementation TitleScreenLayer


#pragma mark Initialization
- (id)init
{
    self = [super init];
    if (self)
    {
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        CCSprite *background = [CCSprite spriteWithFile:@"background.png"];
        [background setPosition:ccp(screenSize.width/2, screenSize.height/2)];
        [self addChild:background z:0];
    }
    
    return self;
}

@end
