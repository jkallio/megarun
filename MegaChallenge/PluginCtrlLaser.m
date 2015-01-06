//
//  PluginCtrlLaser.m
//  MegaRun
//
//  Created by Jussi Kallio on 6.1.2015.
//  Copyright (c) 2015 Kallio. All rights reserved.
//

#import "PluginCtrlLaser.h"

@interface PluginCtrlLaser()
@property (nonatomic) CGFloat velocityX;
@end

@implementation PluginCtrlLaser

- (instancetype) initWithNode:(SKNode<JKNodeProtocol> *)node
{
    if (self = [super initWithNode:node])
    {
        _activated = NO;
    }
    return self;
}

- (void) setActivated:(BOOL)activated
{
    _activated = activated;
    if (activated)
    {
        self.velocityX = self.node.position.x < 320.0f ? 300.0f : -300.0f;
    }
    else
    {
        self.velocityX = 0.0f;
    }
    self.node.physicsBody.velocity = CGVectorMake(self.velocityX, 0.0f);
}

- (void) onUpdate:(NSTimeInterval)dt
{
}

@end
