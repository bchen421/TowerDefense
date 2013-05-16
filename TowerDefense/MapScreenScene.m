//
//  MapScreenScene.m
//  TowerDefense
//
//  Created by Benjamin Chen on 5/14/13.
//
//

#import "MapScreenScene.h"

@implementation MapScreenScene
@synthesize tileMap = _tileMap, backgroundLayer = _backgroundLayer, objectData = _objectData, levelSelectNodes = _levelSelectNodes;

#pragma mark - Touch Management
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    /*
    GameScene *currentScene = [[GameManager sharedManager] currentRunningGameScene];
    BOOL inTowerNode = NO;
    CGPoint touchLocation = [parent_ convertTouchToNodeSpace:touch];
    CGPoint tileCoord = [currentScene tileMapCoordForPosition:touchLocation];
    BOOL retina = [[[[currentScene objectData] properties] valueForKey:@"retina"] boolValue];
    if (retina)
    {
        CGSize tileSize = [[currentScene tileMap] tileSize];
        CGPoint originPoint = [[currentScene metadataLayer] positionAt:tileCoord];
        self.touchedTowerNode = CGRectMake(originPoint.x, originPoint.y, tileSize.width/2.0, tileSize.height/2.0);
    }
    else
    {
        CGSize tileSize = [[currentScene tileMap] tileSize];
        CGPoint originPoint = [[currentScene metadataLayer] positionAt:tileCoord];
        self.touchedTowerNode = CGRectMake(originPoint.x, originPoint.y, tileSize.width, tileSize.height);
    }
    
    NSUInteger tileGID = [[currentScene metadataLayer] tileGIDAt:tileCoord];
    if (tileGID)
    {
        NSDictionary *properties = [[currentScene tileMap] propertiesForGID:tileGID];
        if (properties)
        {
            inTowerNode = [[properties valueForKey:@"towerNode"] boolValue];
        }
        else
        {
            inTowerNode = NO;
        }
    }
    else
    {
        inTowerNode = NO;
    }
    */
    return YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    /*
     GameScene *currentScene = [[GameManager sharedManager] currentRunningGameScene];
     BOOL inTowerNode = NO;
     CGPoint touchLocation = [parent_ convertTouchToNodeSpace:touch];
     CGPoint tileCoord = [currentScene tileMapCoordForPosition:touchLocation];
     BOOL retina = [[[[currentScene objectData] properties] valueForKey:@"retina"] boolValue];
     if (retina)
     {
     CGSize tileSize = [[currentScene tileMap] tileSize];
     CGPoint originPoint = [[currentScene metadataLayer] positionAt:tileCoord];
     self.touchedTowerNode = CGRectMake(originPoint.x, originPoint.y, tileSize.width/2.0, tileSize.height/2.0);
     }
     else
     {
     CGSize tileSize = [[currentScene tileMap] tileSize];
     CGPoint originPoint = [[currentScene metadataLayer] positionAt:tileCoord];
     self.touchedTowerNode = CGRectMake(originPoint.x, originPoint.y, tileSize.width, tileSize.height);
     }
     
     NSUInteger tileGID = [[currentScene metadataLayer] tileGIDAt:tileCoord];
     if (tileGID)
     {
     NSDictionary *properties = [[currentScene tileMap] propertiesForGID:tileGID];
     if (properties)
     {
     inTowerNode = [[properties valueForKey:@"towerNode"] boolValue];
     }
     else
     {
     inTowerNode = NO;
     }
     }
     else
     {
     inTowerNode = NO;
     }
     */
    /*
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    GameScene *currentScene = [[GameManager sharedManager] currentRunningGameScene];
    
    if (CGRectContainsPoint(self.touchedTowerNode, touchLocation))
    {
        CGPoint towerLocation = CGPointMake(self.touchedTowerNode.origin.x + self.touchedTowerNode.size.width/2.0, self.touchedTowerNode.origin.y + self.touchedTowerNode.size.height/2.0);
        [[GameManager sharedManager] spawnTower:kBlueTower forScene:currentScene atLocation:towerLocation];
    }
     */
}

#pragma mark - Touch Delegate Management
- (void) onEnterTransitionDidFinish
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
}

- (void) onExit
{
	[[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
}

#pragma mark - Metadata Management
-(void)setupLevelSelectNodes
{
    BOOL retinaEnabled = [[[[self objectData] properties] valueForKey:@"retina"] boolValue];
        
    for (NSDictionary *dict in [_objectData objects])
    {
        if ([[dict valueForKey:@"type"] isEqualToString:@"levelSelect"])
        {
            CGRect levelSelectNode = CGRectMake([[dict valueForKey:@"x"] floatValue], [[dict valueForKey:@"y"] floatValue], [[dict valueForKey:@"width"] floatValue], [[dict valueForKey:@"height"] floatValue]);
            if (retinaEnabled)
            {
                levelSelectNode.size.width = levelSelectNode.size.width/2.0;
                levelSelectNode.size.height = levelSelectNode.size.height/2.0;
                levelSelectNode.origin.x = levelSelectNode.origin.x / 2.0;
                levelSelectNode.origin.y = levelSelectNode.origin.y / 2.0;
            }
            [_levelSelectNodes addObject:[NSValue valueWithCGRect:levelSelectNode]];
        }
    }
}


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
        _levelSelectNodes = [[NSMutableArray alloc] initWithCapacity:0];
        
        [self setupLevelSelectNodes];
    }
    
    return self;
}


@end
