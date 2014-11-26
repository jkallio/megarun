//
//  PluginTouchHandlerHudButton.m
//  MegaChallenge
//
//  Created by Jussi Kallio on 11.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import "Defines.h"
#import "HudNode.h"
#import "StageBase.h"
#import "PluginCtrlHero.h"
#import "PluginTouchHandlerHudButton.h"

#define _heroCtrl ((PluginCtrlHero*)self.world.hero.controller)

@implementation PluginTouchHandlerHudButton

- (void)handleTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.node.name isEqualToString:NODE_NAME_HUD_JOYPAD])
    {
        CGPoint touchLocation = [[touches anyObject] locationInNode:self.node];
        if (touchLocation.x < 0)
        {
            _heroCtrl.joypadLeftDown = YES;
        }
        else if (touchLocation.x > 0)
        {
            _heroCtrl.joypadRightDown = YES;
        }
    }
    else if ([self.node.name isEqualToString:NODE_NAME_HUD_BUTTON])
    {
        _heroCtrl.jumpButtonDown = YES;
    }
    
    else if ([self.node.name isEqualToString:@"debugDecrease"])
    {
        [((HudNode*)self.hud) decreaseDebug];
    }
    else if ([self.node.name isEqualToString:@"debugIncrease"])
    {
        [((HudNode*)self.hud) increaseDebug];
    }
    else if ([self.node.name isEqualToString:@"debugLabel"])
    {
        ((HudNode*)self.hud).debugSelectedItem++;
    }
}

- (void)handleTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.node.name isEqualToString:NODE_NAME_HUD_JOYPAD])
    {
        CGPoint touchLocation = [[touches anyObject] locationInNode:self.node];
        if (touchLocation.x < 0)
        {
            _heroCtrl.joypadLeftDown = YES;
        }
        else if (touchLocation.x > 0)
        {
            _heroCtrl.joypadRightDown = YES;
        }
    }
}

- (void)handleTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.node.name isEqualToString:NODE_NAME_HUD_JOYPAD])
    {
        _heroCtrl.joypadLeftDown = NO;
        _heroCtrl.joypadRightDown = NO;
        if (touches.count > 1)
        {
            _heroCtrl.jumpButtonDown = NO;
        }
    }
    else if ([self.node.name isEqualToString:NODE_NAME_HUD_BUTTON])
    {
        _heroCtrl.jumpButtonDown = NO;
        if (touches.count > 1)
        {
            _heroCtrl.joypadLeftDown = NO;
            _heroCtrl.joypadRightDown = NO;
        }
    }
}

- (void)handleTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self handleTouchesEnded:touches withEvent:event];
}


@end
