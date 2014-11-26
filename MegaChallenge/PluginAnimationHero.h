//
//  PluginAnimationHero.h
//  MegaChallenge
//
//  Created by Jussi Kallio on 4.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import <JKGameKit/JKGameKit.h>
@class PluginCtrlHero;

@interface PluginAnimationHero : JKPluginAnimationBase

@property (nonatomic, getter=isFacingLeft) BOOL facingLeft;
@end
