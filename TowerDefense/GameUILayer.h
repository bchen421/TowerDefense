//
//  GameUILayer.h
//  TowerDefense
//
//  Created by Benjamin Chen on 4/25/13.
//
//

#import "cocos2d.h"

@interface GameUILayer : CCLayer <CCTargetedTouchDelegate>
{
    CGRect _touchedTowerNode;
    BOOL _touchMoved;
    BOOL _inTowerNode;
    CGPoint _startingTouchLocation;
    long unsigned int _startingTouchTime;
    BOOL _beingTouched;
}

@property (readwrite) CGRect touchedTowerNode;
@property (nonatomic, readwrite) CGPoint startingTouchLocation;

-(void)translateViewBy:(CGPoint)translation;
-(void)scrollViewBy:(CGPoint)translation;
-(void)returnInBounds;

@end
