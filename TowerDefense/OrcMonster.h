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
    CCAnimation *_walkingAnim;
}

@property (nonatomic,readwrite,retain) CCAnimation *walkingAnim;

+(MonsterObject *)spawnOrc;
+(MonsterObject *)spawnBigOrc;
-(void)runWalkingAnimation;

@end
