//
//  OrcMonster.h
//  TowerDefense
//
//  Created by Benjamin Chen on 4/19/13.
//
//

#import "MonsterObject.h"
#import "GameConstants.h"
#import "cocos2d.h"

@interface OrcMonster : MonsterObject
{
    NSUInteger *_previousTildGID;
    NSString *_assignedPath;
    CGPoint *_nextDestination;
}

+(MonsterObject *)spawnOrc;
+(MonsterObject *)spawnBigOrc;

@end
