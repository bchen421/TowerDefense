//
//  MapScreenScene.h
//  TowerDefense
//
//  Created by Benjamin Chen on 5/14/13.
//
//

#import "GameScene.h"

@interface MapScreenScene : GameScene <CCTargetedTouchDelegate>
{    
    NSMutableArray *_levelSelectNodes;
    NSMutableArray *_levelSelectIndex;
    CGPoint _startingTouchLocation;
    long unsigned int _startingTouchTime;
    BOOL _beingTouched;
    BOOL _touchMoved;
}

@property (nonatomic,readonly) NSMutableArray *levelSelectNodes;
@property (nonatomic,readonly) NSMutableArray *levelSelectIndex;
@property (nonatomic, readwrite) CGPoint startingTouchLocation;

-(void)setupLevelSelectNodes;
-(void)translateViewBy:(CGPoint)translation;
-(void)scrollViewBy:(CGPoint)translation;
-(BOOL)viewInBounds;

@end
