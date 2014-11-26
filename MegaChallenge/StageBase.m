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
#import "PluginCtrlHero.h"
#import "StageBase.h"

#define _heroCtrl ((PluginCtrlHero*)self.hero.controller)

@implementation StageBase

- (NSArray*) levelMap
{
    JKAssert(NO, @"Child must implement");
    return nil;
}

- (void) LoadLevel
{
    [super LoadLevel];
        
    NSArray* levelObjects = [NodeFactory createLevelMap:[self levelMap]];
    for (JKGameNode* node in levelObjects)
    {
        [self addChild:node];
        if (node.objType == OBJ_TYPE_TELEPAD)
        {
            self.camera.position = node.position;
        }
    }
}

- (JKHudNode*) loadHUD
{
    HudNode* hud = [HudNode node];
    return hud;
}


- (void) onGameBegin
{
    JKDebugLog(@"Game start");
}

- (void) onGameOver
{
    JKDebugLog(@"Game over");
    [self.gameScene startGame];
}

- (void) onUpdate:(NSTimeInterval)dt
{
    switch (_heroCtrl.state)
    {
        case STATE_NORMAL: self.camera.targetPosition = self.hero.position; break;
        case STATE_TELEPORTING_DOWN: self.camera.targetPosition = self.telePad.position; break;
        case STATE_TELEPORTING_UP: break; // no update;
        default: break;
    }
    
    if (self.pitOfDeathEnabled && self.hero.position.y < -1000.0f)
    {
        [self.gameScene endGame];
    }
}

- (JKGameNode*) telePad
{
    if (!_telePad)
    {
        _telePad = [JKGameNode cast:[self childNodeWithName:NODE_NAME_TELEPAD]];
    }
    return _telePad;
}

@end
