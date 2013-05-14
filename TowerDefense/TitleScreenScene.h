//
//  TitleScreenScene.h
//  TowerDefense
//
//  Created by Benjamin Chen on 5/10/13.
//
//

#import "cocos2d.h"
@class TitleScreenLayer;

@interface TitleScreenScene : CCScene <CCTargetedTouchDelegate>
{
    TitleScreenLayer *_titleScreenLayer;
    CCLabelTTF *_titleLabel;
    CCLabelTTF *_continueLabel;
}

@property (nonatomic,readonly) TitleScreenLayer *titleScreenLayer;
@property (retain,nonatomic,readwrite) CCLabelTTF *titleLabel;
@property (retain,nonatomic,readwrite) CCLabelTTF *continueLabel;


@end
