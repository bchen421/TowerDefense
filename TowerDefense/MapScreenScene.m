//
//  MapScreenScene.m
//  TowerDefense
//
//  Created by Benjamin Chen on 5/14/13.
//
//

#import "MapScreenScene.h"

@implementation MapScreenScene
@synthesize tileMap = _tileMap, backgroundLayer = _backgroundLayer, objectData = _objectData;

#pragma mark - Initialization
-(id)init
{
    self = [super init];
    if (self)
    {
        // Setup Default Start and End Locations
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        CCLOG(@"Screen Width: %g Height: %g", screenSize.width, screenSize.height);
        
        // Setup background and metadata
        _tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"mapscreen.tmx"];
        [self addChild:_tileMap z:0];
        _backgroundLayer = [[self tileMap] layerNamed:@"background"];
        _objectData = [[self tileMap] objectGroupNamed:@"objectData"];
        
    }
    
    return self;
}


@end
