//
//  MonsterObject.h
//  TowerDefense
//
//  Created by Benjamin Chen on 4/18/13.
//
//

#import "GameObject.h"
#import "GameConstants.h"

@interface MonsterObject : GameObject
{
    MonsterID _monsterID;
}

@property (nonatomic,readwrite) MonsterID monsterID;

@end
