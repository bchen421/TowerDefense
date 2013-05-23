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
@synthesize levelSelectNodes = _levelSelectNodes, levelSelectIndex = _levelSelectIndex, startingTouchLocation = _startingTouchLocation,  tileMap = _tileMap, backgroundLayer = _backgroundLayer, objectData = _objectData;

#pragma mark - Run Time Loop
-(void)update:(ccTime)deltaTime
{
    CCAction *scrollAction = [self getActionByTag:kScrollLevelActions];
    if ( (![self viewInBounds]) && !(_beingTouched) && (!scrollAction) )
    {
        //CCLOG(@"RETURNING TO BOUNDS");
        //[self returnInBounds];
    }
}

#pragma mark - Metadata Management
-(CGPoint)positionForTileCoord:(CGPoint)tileCoord
{
    CGPoint position = [[self backgroundLayer] positionAt:tileCoord];
    CGSize tileSize = [[self tileMap] tileSize];
    
    BOOL retina = [[[[self tileMap] properties] valueForKey:@"retina"] boolValue];
    
    if (retina)
    {
        return CGPointMake(position.x + tileSize.width/4.0, position.y + tileSize.height/4.0);
    }
    else
    {
        return CGPointMake(position.x + tileSize.width/2.0, position.y + tileSize.height/2.0);
    }
}

-(CGPoint)tileMapCoordForPosition:(CGPoint)position
{
    BOOL retina = [[[[self tileMap] properties] valueForKey:@"retina"] boolValue];
    if (!retina)
    {
        CGSize mapSize = [[self tileMap] mapSize];
        CGSize tileSize = [[self tileMap] tileSize];
        int x = position.x / tileSize.width;
        int y = ((mapSize.height * tileSize.height) - position.y) / tileSize.height;
        return ccp(x, y);
    }
    else
    {
        CGSize mapSize = [[self tileMap] mapSize];
        CGSize tileSize = [[self tileMap] tileSize];
        tileSize.width = tileSize.width / 2.0;
        tileSize.height = tileSize.height / 2.0;
        int x = position.x / tileSize.width;
        int y = ((mapSize.height * tileSize.height) - position.y) / tileSize.height;
        return ccp(x, y);
    }
}

-(CGPoint)locationForDataObject:(NSString *)dataObject
{
    BOOL retina = [[[[self tileMap] properties] valueForKey:@"retina"] boolValue];
    
    NSDictionary *dict = [[self objectData] objectNamed:dataObject];
    int width = [[dict valueForKey:@"width"] integerValue];
    int height = [[dict valueForKey:@"height"] integerValue];
    int x = [[dict valueForKey:@"x"] integerValue];
    int y = [[dict valueForKey:@"y"] integerValue];
    
    if (!retina)
    {
        return ccp(x + width/2,y + height/2);
    }
    else
    {
        return ccp(x/2 + width/4, y/2 + height/4);
    }
}

#pragma mark - Map View Management
-(BOOL)viewInBounds
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGSize levelSize = [[GameManager sharedManager] dimensionsOfCurrentScene];
    if (self.position.x > 0)
    {
        return NO;
    }
    else if (self.position.x < -(levelSize.width - screenSize.width))
    {
        return NO;
    }
    
    if (self.position.y > 0)
    {
        return NO;
    }
    else if (self.position.y < -(levelSize.height - screenSize.height))
    {
        return NO;
    }
    
    return YES;
}

-(void)returnInBounds
{
    CCLOG(@"I AM RETURNING IN BOUNDS");
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGSize levelSize = [[GameManager sharedManager] dimensionsOfCurrentScene];
    
    CGPoint newPosition = self.position;
    
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
    
    newPosition.x = round(newPosition.x);
    newPosition.y = round(newPosition.y);
    
    CCMoveTo *moveTo = [CCMoveTo actionWithDuration:(12.0/60.0) position:newPosition];
    [moveTo setTag:kScrollLevelActions];
    [self runAction:moveTo];
}

-(void)translateViewBy:(CGPoint)translation
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGSize levelSize = [[GameManager sharedManager] dimensionsOfCurrentScene];
    CGPoint newPosition = ccp((self.position.x - translation.x), (self.position.y - translation.y));
    
    if (newPosition.x > 0)
    {
        newPosition.x = MIN(newPosition.x / 2.0, 100.0);
    }
    else if (newPosition.x < -(levelSize.width - screenSize.width))
    {
        float diff = newPosition.x - -(levelSize.width - screenSize.width);
        newPosition.x = MAX(newPosition.x - diff/2.0, -(levelSize.width - screenSize.width + 100.0));
    }
    
    if (newPosition.y > 0)
    {
        newPosition.y = MIN(newPosition.y / 2.0, 100.0);
    }
    else if (newPosition.y < -(levelSize.height - screenSize.height))
    {
        float diff = newPosition.y - -(levelSize.height - screenSize.height);
        newPosition.y = MAX(newPosition.y - diff/2.0, -(levelSize.height - screenSize.height + 100.0));
    }
    
    CCLOG(@"NEWPOSITION X: %g Y: %g", newPosition.x, newPosition.y);
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
    
    newPosition.x = round(newPosition.x);
    newPosition.y = round(newPosition.y);
    
    CCMoveTo *moveTo = [CCMoveTo actionWithDuration:(6.0/60.0) position:newPosition];
    [moveTo setTag:kScrollLevelActions];
    [self runAction:moveTo];
}

#pragma mark - Touch Management
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self stopActionByTag:kScrollLevelActions];
    _beingTouched = YES;
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
    _beingTouched = NO;
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
                [self unscheduleUpdate];
                [[GameManager sharedManager] runGameScene:kTiledScene];
            }
            else if (level == 2)
            {
                [self unscheduleUpdate];
                [[GameManager sharedManager] runGameScene:kTitleScreenScene];
            }
        }
    }
    else
    {
        CCLOG(@"TOUCH ENDED");
        struct timeval time;
        gettimeofday(&time, NULL);
        long unsigned int currentTime = (time.tv_sec * 1000) + (time.tv_usec / 1000);
        unsigned int deltaTime = currentTime - _startingTouchTime;
        
        CGPoint velocity = ccp((self.startingTouchLocation.x - touchLocation.x)/deltaTime, (self.startingTouchLocation.y - touchLocation.y)/deltaTime);
        CCLOG(@"VELOCITY X: %g Y: %g", velocity.x, velocity.y);
        velocity = ccpMult(velocity, 1000.0);
        CCLOG(@"ADJUSTED VELOCITY X: %g Y: %g", velocity.x, velocity.y);
        [self scrollViewBy:velocity];
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
        [[_backgroundLayer texture] setAliasTexParameters];
        _objectData = [[self tileMap] objectGroupNamed:@"objectData"];
        _levelSelectNodes = [[NSMutableArray alloc] initWithCapacity:0];
        _levelSelectIndex = [[NSMutableArray alloc] initWithCapacity:0];
        [self setupLevelSelectNodes];
        _beingTouched = NO;
        [self scheduleUpdate];
    }
    return self;
}


@end
