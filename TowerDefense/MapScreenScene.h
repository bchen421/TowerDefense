//
//  MapScreenScene.h
//  TowerDefense
//
//  Created by Benjamin Chen on 5/14/13.
//
//

#import "cocos2d.h"
#import "GameConstants.h"

@interface MapScreenScene : CCScene <CCTargetedTouchDelegate>
{
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_backgroundLayer;
    CCTMXObjectGroup *_objectData;
    
    NSMutableArray *_levelSelectNodes;
    NSMutableArray *_levelSelectIndex;
    CGPoint _startingTouchLocation;
    long unsigned int _startingTouchTime;
    BOOL _beingTouched;
    BOOL _touchMoved;
}

@property (readonly) CCTMXTiledMap *tileMap;
@property (readonly) CCTMXLayer *backgroundLayer;
@property (readonly) CCTMXObjectGroup *objectData;
@property (nonatomic,readonly) NSMutableArray *levelSelectNodes;
@property (nonatomic,readonly) NSMutableArray *levelSelectIndex;
@property (nonatomic, readwrite) CGPoint startingTouchLocation;

-(CGPoint)positionForTileCoord:(CGPoint)tileCoord;
-(CGPoint)tileMapCoordForPosition:(CGPoint)position;
-(CGPoint)locationForDataObject:(NSString *)dataObject;
-(void)setupLevelSelectNodes;
-(void)translateViewBy:(CGPoint)translation;
-(void)scrollViewBy:(CGPoint)translation;
-(BOOL)viewInBounds;

@end