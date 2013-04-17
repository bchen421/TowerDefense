//
//  SandboxLayer.m
//  TowerDefense
//
//  Created by Benjamin Chen on 4/17/13.
//
//

#import "SandboxLayer.h"

@implementation SandboxLayer

@synthesize sceneSpriteBatchNode;

-(void)update:(ccTime)deltaTime
{
    
}

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
        
        [[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFramesWithFile:@"sandboxAtlas.plist"];
        sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"sandboxAtlas.png"];
        
        CCSprite *testSprite = [[CCSprite alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"monster.png"]];
        [testSprite setPosition:ccp( (screenSize.width / 2), (screenSize.height / 2) )];
        
        [self addChild:backgroundImage z:-1 tag:0];
        [self addChild:sceneSpriteBatchNode z:0];
        [sceneSpriteBatchNode addChild:testSprite z:100];
        
        [self scheduleUpdate];
    }
    return self;
}

@end
