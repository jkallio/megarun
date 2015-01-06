//
//  PluginCtrlDisappearingBlock.m
//  MegaRun
//
//  Created by Jussi Kallio on 23.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import "PluginCtrlHero.h"
#import "PluginCtrlDisappearingBlock.h"

#define _heroCtrl ((PluginCtrlHero*)self.world.hero.controller)

@interface PluginCtrlDisappearingBlock()
@property (nonatomic) NSTimeInterval timeSinceStateChanged;
@property (nonatomic) NSTimeInterval stateChangeInterval;
@property (nonatomic) BOOL isHidden;
- (void) changeState;
@end

@implementation PluginCtrlDisappearingBlock

- (instancetype) initWithNode:(SKNode<JKNodeProtocol> *)node
{
    if (self = [super initWithNode:node])
    {
        _stateChangeInterval = 2.5f;
        _timeSinceStateChanged = 0.0f;
    }
    return self;
}

- (void) onUpdate:(NSTimeInterval)dt
{
    self.timeSinceStateChanged += dt;
    if (self.timeSinceStateChanged > self.stateChangeInterval)
    {
        [self changeState];
        self.timeSinceStateChanged = 0.0f;
    }
}

- (void) changeState
{
    if (self.isHidden)
    {
        self.gameNode.physicsBody.categoryBitMask = kCatStaticObj;
        self.gameNode.physicsBody.collisionBitMask = kCollisionMaskStaticObj;
        self.gameNode.alpha = 1.0f;
    }
    else
    {
        self.gameNode.physicsBody.categoryBitMask = kMaskNull;
        self.gameNode.physicsBody.collisionBitMask = kMaskNull;
        self.gameNode.alpha = 0.0f;
    }
    _isHidden = !_isHidden;
}

- (void) setPhase:(NSInteger)phase
{
    self.timeSinceStateChanged = phase > 0 ? (self.stateChangeInterval / phase) : 0.0f;
}
@end
