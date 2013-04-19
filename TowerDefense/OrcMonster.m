//
//  OrcMonster.m
//  TowerDefense
//
//  Created by Benjamin Chen on 4/19/13.
//
//

#import "OrcMonster.h"

@implementation OrcMonster

#pragma  mark - Update Methods

-(void)update:(ccTime)deltaTime
{
    
}

#pragma mark - Orc Factory
+(MonsterObject *)spawnOrc
{
    MonsterObject *newOrc = [[OrcMonster alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"orc.png"]];
    [newOrc setScale:0.75];
    
    [newOrc scheduleUpdate];
    return newOrc;
}

+(MonsterObject *)spawnBigOrc
{
    MonsterObject *newOrc = [[OrcMonster alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"orc.png"]];
    [newOrc setScale:1.0];
    
    [newOrc scheduleUpdate];
    return newOrc;
}

#pragma mark - Initialization
-(id)init
{
    if ((self = [super init]))
    {
        _monsterID = kOrc;
    }
    return self;
}

@end
