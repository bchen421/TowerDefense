//
//  TowerObject.m
//  TowerDefense
//
//  Created by Benjamin Chen on 4/25/13.
//
//

#import "TowerObject.h"
#import "MonsterObject.h"
#import "cocos2d.h"
#import "CCArray.h"

@implementation TowerObject
@synthesize towerID=_towerID, towerState=_towerState, attackRate=_attackRate, attackRange=_attackRange, currentTarget=_currentTarget;

#pragma mark - State Management Methods
-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects
{
    [super updateStateWithDeltaTime:deltaTime andListOfGameObjects:listOfGameObjects];
}

-(void)changeState:(TowerState)newState
{
    CCLOG(@"STUB METHOD, PLEASE OVERRIDE ME");
}

-(void)attackCurrentTarget
{
    CCLOG(@"STUB METHOD, PLEASE OVERRIDE ME");
}

#pragma mark - Target Management
-(void)findTargetFrom:(CCArray *)listOfGameObjects
{
    MonsterObject *monster;
    CCARRAY_FOREACH(listOfGameObjects, monster)
    {
        if ([monster gameObjectType] == kMonsterObject)
        {
            //CCLOG(@"Checking if monster is in range");
            if ([self isMonsterInRange:monster] && (monster.monsterState != kMonsterDead))
            {
                if (self.currentTarget == nil)
                {
                    self.currentTarget = monster;
                    CCLOG(@"I FOUND A MONSTER TO ATTACK");
                }
            }
        }
    }
}

-(BOOL)isMonsterInRange:(MonsterObject *)monster
{
    // Look for closest (x,y) value of bounding box of monster.  If it's within range, it's attackable
    float xValue, yValue, monsterDistance;
    
    // Grab closest x value
    if (monster.position.x <= self.position.x)
    {
        xValue = (monster.position.x + (monster.boundingBox.size.width/2.0));
    }
    else
    {
        xValue = (monster.position.x - (monster.boundingBox.size.width/2.0));
    }
    
    // Grab closest y value
    if (monster.position.y <= self.position.y)
    {
        yValue = (monster.position.y + (monster.boundingBox.size.height/2.0));
    }
    else
    {
        yValue = (monster.position.y - (monster.boundingBox.size.height/2.0));
    }
    
    CGPoint adjustedMonsterLocation = CGPointMake(xValue, yValue);
    
    monsterDistance = ccpDistance(self.position, adjustedMonsterLocation);
    
    if (monsterDistance <= _attackRange)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - Touch Management
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [parent_ convertTouchToNodeSpace:touch];
    if (CGRectContainsPoint([self boundingBox], touchLocation))
    {
        CCLOG(@"TOWER WAS TOUCHED");
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"TOWER TOUCH ENDED, I AM A STUB, OVERRIDE ME IF YOU PLEASE");
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

#pragma mark - Initialization
-(void)createRangeFinder
{
    _rangeFinder = [[CCSprite alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"rangefinder.png"]];
    float rangeFinderScale = _attackRange/25.0;
    [_rangeFinder setScale:rangeFinderScale];
    [self addChild:_rangeFinder];
    [_rangeFinder setPosition:CGPointMake(self.boundingBox.size.width/2.0, self.boundingBox.size.height/2.0)];
    [_rangeFinder setVisible:NO];
}

-(id)initWithSpriteFrame:(CCSpriteFrame*)spriteFrame
{
    if ((self = [super initWithSpriteFrame:spriteFrame]))
    {
        _gameObjectType = kTowerObject;
        _towerID = kGenericTower;
        _towerState = kMonsterIdle;
        _attackRate = 0.0;
        _attackRange = 0.0;
        _currentTarget = nil;
    }
    return self;
}

#pragma mark - Class Methods
+(TowerObject *)spawnTower
{
    CCLOG(@"STUB METHOD, PLEASE OVERRIDE ME");
    
    return nil;
}

@end
