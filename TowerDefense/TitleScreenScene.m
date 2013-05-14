//
//  TitleScreenScene.m
//  TowerDefense
//
//  Created by Benjamin Chen on 5/10/13.
//
//

#import "TitleScreenScene.h"
#import "TitleScreenLayer.h"
#import "GameManager.h"

@implementation TitleScreenScene
@synthesize titleScreenLayer = _titleScreenLayer, titleLabel = _titleLabel, continueLabel = _continueLabel;

#pragma mark - Touch Management
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [[GameManager sharedManager] runGameScene:kMainMenuScene];
}

#pragma mark - Scene Management
- (void) onEnterTransitionDidFinish
{
    [super onEnter];
    
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    _titleLabel = [CCLabelTTF labelWithString:@"TOWER DEFENSE" fontName:@"Marker Felt" fontSize:64.0];
    [[self titleLabel] setColor:ccBLUE];
    [[self titleLabel] setPosition:ccp(screenSize.width/2, screenSize.height/2 + 50)];
    CCSequence *titleScaling = [CCSequence actions:[CCDelayTime actionWithDuration:2.0f], [CCScaleTo actionWithDuration:0.3f scale:0.75],[CCDelayTime actionWithDuration:0.1f],[CCScaleTo actionWithDuration:0.3f scale:1.0],[CCDelayTime actionWithDuration:3.0f], nil];
    CCActionInterval *titleLooping = [CCRepeatForever actionWithAction:titleScaling];
    [[self titleLabel] runAction:titleLooping];
    [self addChild:_titleLabel z:1];
    
    _continueLabel = [CCLabelTTF labelWithString:@"Tap to Continue" fontName:@"Marker Felt" fontSize:16.0];
    [[self continueLabel] setColor:ccBLACK];
    [[self continueLabel] setPosition:ccp(screenSize.width/2, screenSize.height/2 - 25)];
    CCSequence *continueBlinking = [CCSequence actions:[CCBlink actionWithDuration:3.0f blinks:2], [CCShow action], nil];
    CCActionInterval *continueLooping = [CCRepeatForever actionWithAction:continueBlinking];
    [[self continueLabel] runAction:continueLooping];
    [self addChild:_continueLabel z:1];

    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
}

- (void) onExit
{
	[[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
}


#pragma mark Initialization
- (id)init
{
    self = [super init];
    if (self)
    {
        _titleScreenLayer = [TitleScreenLayer node];
        [self addChild:_titleScreenLayer z:0];
        
    }
    return self;
}

@end
