//
//  GameObject.m
//  TowerDefense
//
//  Created by Benjamin Chen on 4/17/13.
//
//

#import "GameObject.h"

@implementation GameObject

@synthesize objectType = _objectType;


#pragma mark - Initialization
-(id)init
{
    if ((self = [super init]))
    {
        _objectType = kGenericGameObject;
    }
    return self;
}

@end
