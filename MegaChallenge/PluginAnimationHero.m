//
//  PluginAnimationHero.m
//  MegaChallenge
//
//  Created by Jussi Kallio on 4.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import "Defines.h"
#import "PluginCtrlHero.h"
#import "PluginAnimationHero.h"

#define _heroCtrl ((PluginCtrlHero*)((JKGameNode*)self.node.parent).controller)
#define _heroBody ((JKGameNode*)self.node.parent).physicsBody

static const float kFlipLimit = 50.0f;

@implementation PluginAnimationHero

- (instancetype) initWithNode:(SKNode<JKNodeProtocol> *)node
{
    if (self = [super initWithNode:node])
    {
        _facingLeft = NO;
    }
    return self;
}

- (void) onUpdate:(NSTimeInterval)dt
{
    if ((self.isFacingLeft && ((_heroBody.velocity.dx > kFlipLimit && self.spriteNode.xScale > 0) || (_heroBody.velocity.dx < -kFlipLimit && self.spriteNode.xScale < 0)))
        || (!self.isFacingLeft && ((_heroBody.velocity.dx > kFlipLimit && self.spriteNode.xScale < 0) || (_heroBody.velocity.dx < -kFlipLimit && self.spriteNode.xScale > 0))))
    {
        self.spriteNode.xScale *= -1;
    }
    
    if (_heroCtrl.isTeleporting)
    {
        [self changeAnimation:HERO_ANIM_KEY_TELEPORT];
    }
    else if (!_heroCtrl.isOnGround)
    {
        [self changeAnimation:HERO_ANIM_KEY_JUMP];
    }
    else if (_heroCtrl.joypadLeftDown || _heroCtrl.joypadRightDown)
    {
        [self changeAnimation:HERO_ANIM_KEY_MOVE];
    }
    else
    {
        [self changeAnimation:HERO_ANIM_KEY_STOP];
    }
}

@end
