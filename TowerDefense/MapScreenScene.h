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
    CGPoint _tileTouched;
}

@property (nonatomic,readonly) NSMutableArray *levelSelectNodes;
@property (nonatomic,readonly) NSMutableArray *levelSelectIndex;
@property (nonatomic,readwrite) CGPoint tileTouched;

-(void)setupLevelSelectNodes;

@end
