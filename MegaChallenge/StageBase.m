//
//  StageBase.m
//  MegaChallenge
//
//  Created by Jussi Kallio on 8.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import "Defines.h"
#import "HudNode.h"
#import "NodeFactory.h"
#import "StageBase.h"

@implementation StageBase

- (NSArray*) levelMap
{
    JKAssert(NO, @"Child must implement");
    return nil;
}

- (void) LoadLevel
{
    [super LoadLevel];
    
    JKGameNode* hero = [NodeFactory createHeroWithPosition:CGPointZero];
    [self addChild:hero];
    self.hero = hero;
    
    NSArray* levelObjects = [NodeFactory createLevelMap:[self levelMap]];
    for (JKGameNode* node in levelObjects)
    {
        [self addChild:node];
    }
}

- (JKHudNode*) loadHUD
{
    HudNode* hud = [HudNode node];
    return hud;
}

- (void) onUpdate:(NSTimeInterval)dt
{
    self.camera.targetPosition = self.hero.position;
}

@end
