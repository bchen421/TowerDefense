//
//  MonsterObject.m
//  TowerDefense
//
//  Created by Benjamin Chen on 4/18/13.
//
//

#import "MonsterObject.h"

@implementation MonsterObject
@synthesize monsterID = _monsterID;

#pragma  mark - Update Methods
-(void)update:(ccTime)deltaTime
{
    
}

#pragma mark - Initialization
-(id)init
{
    if ((self = [super init]))
    {
        _objectType = kMonsterObject;
        _monsterID = kGenericMonster;
    }
    return self;
}

@end
