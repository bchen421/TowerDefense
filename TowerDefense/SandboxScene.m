//
//  SandboxScene.m
//  TowerDefense
//
//  Created by Benjamin Chen on 4/17/13.
//
//

#import "SandboxScene.h"
#import "SandboxLayer.h"

@implementation SandboxScene


#pragma mark - Initialization
- (id)init
{
    self = [super init];
    if (self)
    {
        sandboxLayer = [SandboxLayer node];
        [self addChild:sandboxLayer];
    }
    
    return self;
}

@end
