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
@synthesize levelSelectNodes = _levelSelectNodes, levelSelectIndex = _levelSelectIndex, startingTouchLocation = _startingTouchLocation;

#pragma mark - Map View Management
-(void)translateViewBy:(CGPoint)translation
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGSize levelSize = [[GameManager sharedManager] dimensionsOfCurrentScene];
    CGPoint newPosition = ccp((self.position.x - translation.x), (self.position.y - translation.y));
    if (newPosition.x > 0)
    {
        newPosition.x = 0;
    }
    else if (newPosition.x < -(levelSize.width - screenSize.width))
    {
        newPosition.x = -(levelSize.width - screenSize.width);
    }

    if (newPosition.y > 0)
    {
        newPosition.y = 0;
    }
    else if (newPosition.y < -(levelSize.height - screenSize.height))
    {
        newPosition.y = -(levelSize.height - screenSize.height);
    }
    [self setPosition:newPosition];
}

-(void)scrollViewBy:(CGPoint)translation
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGSize levelSize = [[GameManager sharedManager] dimensionsOfCurrentScene];
    CGPoint newPosition = ccp((self.position.x - translation.x), (self.position.y - translation.y));
    if (newPosition.x > 0)
    {
        newPosition.x = 0;
    }
    else if (newPosition.x < -(levelSize.width - screenSize.width))
    {
        newPosition.x = -(levelSize.width - screenSize.width);
    }
    
    if (newPosition.y > 0)
    {
        newPosition.y = 0;
    }
    else if (newPosition.y < -(levelSize.height - screenSize.height))
    {
        newPosition.y = -(levelSize.height - screenSize.height);
    }
    
    
    [self runAction:[CCMoveTo actionWithDuration:(6.0/60.0) position:newPosition]];
}

#pragma mark - Touch Management
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self stopAllActions];
    _touchMoved = NO;
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    self.startingTouchLocation = touchLocation;
    struct timeval time;
    gettimeofday(&time, NULL);
    _startingTouchTime = (time.tv_sec * 1000) + (time.tv_usec / 1000);
    CCLOG(@"TIME: %lu", _startingTouchTime);
    
    return YES;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    _touchMoved = YES;
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    CGPoint translation = ccp(self.startingTouchLocation.x - touchLocation.x, self.startingTouchLocation.y - touchLocation.y);
    [self translateViewBy:translation];
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    if (!_touchMoved)
    {
        BOOL inLevelSelectNode = NO;
        NSUInteger level;
        for (NSValue *levelSelectNode in [self levelSelectNodes])
        {
            if (CGRectContainsPoint([levelSelectNode CGRectValue], touchLocation))
            {
                inLevelSelectNode = YES;
                level = [[[self levelSelectIndex] objectAtIndex:[[self levelSelectNodes] indexOfObject:levelSelectNode]] integerValue];
            }
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
    else
    {
        struct timeval time;
        gettimeofday(&time, NULL);
        long unsigned int currentTime = (time.tv_sec * 1000) + (time.tv_usec / 1000);
        float distance = ABS(ccpDistance(self.startingTouchLocation, touchLocation));
        unsigned int deltaTime = currentTime - _startingTouchTime;
        CCLOG(@"TIME: %lu", currentTime);
        
        float touchVelocity = (distance / deltaTime) * 1000;
        
        CCLOG(@"VELOCITY: %g", touchVelocity);
        
        if (touchVelocity > 100.0)
        {
            CCLOG(@"PAN DETECTED");
            CGPoint translation = ccp(self.startingTouchLocation.x - touchLocation.x, self.startingTouchLocation.y - touchLocation.y);
            translation.x = translation.x * 25.0;
            translation.y = translation.y * 25.0;
            self.startingTouchLocation = touchLocation;
            [self scrollViewBy:translation];
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
