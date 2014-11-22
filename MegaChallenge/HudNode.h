//
//  HudNode.h
//  MegaChallenge
//
//  Created by Jussi Kallio on 11.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import <JKGameKit/JKGameKit.h>
@class StageBase;
@class PluginControllerHero;

@interface HudNode : JKHudNode

@property (nonatomic, weak) JKSpriteNode* joypad;
@property (nonatomic, weak) JKSpriteNode* button;
@property (nonatomic, weak) JKShadowedLabelNode* lblScore;
@property (nonatomic, weak) JKShadowedLabelNode* lblHiScore;

@property (nonatomic) NSInteger debugSelectedItem;
- (void) decreaseDebug;
- (void) increaseDebug;

@end
