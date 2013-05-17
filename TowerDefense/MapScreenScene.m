//
//  MapScreenScene.m
//  TowerDefense
//
//  Created by Benjamin Chen on 5/14/13.
//
//

#import "MapScreenScene.h"
#import "GameManager.h"

@implementation MapScreenScene
@synthesize levelSelectNodes = _levelSelectNodes, levelSelectIndex = _levelSelectIndex, tileTouched = _tileTouched;

#pragma mark - Touch Management
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    self.tileTouched = [self tileMapCoordForPosition:touchLocation];
    
    return YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    CGPoint tileCoord = [self tileMapCoordForPosition:touchLocation];
    BOOL inLevelSelectNode = NO;
    NSUInteger level;
    if (CGPointEqualToPoint(self.tileTouched, tileCoord))
    {
        for (NSValue *levelSelectNode in [self levelSelectNodes])
        {
            if (CGRectContainsPoint([levelSelectNode CGRectValue], touchLocation))
            {
                inLevelSelectNode = YES;
                level = [[[self levelSelectIndex] objectAtIndex:[[self levelSelectNodes] indexOfObject:levelSelectNode]] integerValue];
            }
        }
    }
    else
    {
        CCLOG(@"SLIDE THE MAP");
    }
    
    if (inLevelSelectNode)
    {
        CCLOG(@"LOAD LEVEL %i", level);
        if (level == 1)
        {
            [[GameManager sharedManager] runGameScene:kTiledScene];
        }
        else if (level == 2)
        {
            [[GameManager sharedManager] runGameScene:kTitleScreenScene];
        }
    }
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
    BOOL retina = [[[[self tileMap] properties] valueForKey:@"retina"] boolValue];
    for (NSDictionary *dict in [_objectData objects])
    {
        if ([[dict valueForKey:@"type"] isEqualToString:@"levelSelect"])
        {
            CGRect levelSelectNode = CGRectMake([[dict valueForKey:@"x"] floatValue], [[dict valueForKey:@"y"] floatValue], [[dict valueForKey:@"width"] floatValue], [[dict valueForKey:@"height"] floatValue]);
            if (retina)
            {
                levelSelectNode.size.width = levelSelectNode.size.width/2.0;
                levelSelectNode.size.height = levelSelectNode.size.height/2.0;
                levelSelectNode.origin.x = levelSelectNode.origin.x / 2.0;
                levelSelectNode.origin.y = levelSelectNode.origin.y / 2.0;
            }
            [_levelSelectNodes addObject:[NSValue valueWithCGRect:levelSelectNode]];
            [_levelSelectIndex addObject:[dict valueForKey:@"name"]];
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
        _levelSelectIndex = [[NSMutableArray alloc] initWithCapacity:0];
        [self setupLevelSelectNodes];
    }
    
    return self;
}


@end
