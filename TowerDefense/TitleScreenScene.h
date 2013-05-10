//
//  TitleScreenScene.h
//  TowerDefense
//
//  Created by Benjamin Chen on 5/10/13.
//
//

#import "cocos2d.h"
@class TitleScreenLayer;

@interface TitleScreenScene : CCScene
{
    TitleScreenLayer *_titleScreenLayer;
}

@property (nonatomic,readonly) TitleScreenLayer *titleScreenLayer;

@end
