//
//  StageBase.m
//  MegaChallenge
//
//  Created by Jussi Kallio on 8.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import <JKGameKit/JKUtils.h>
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

- (void) loadLevel
{
    [super loadLevel];
        
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
    
    if ((self.hero.position.y < self.camera.position.y - 300.0f) || (self.pitOfDeathEnabled && self.hero.position.y < -1000.0f))
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

- (JKGameNode*) currentBlock
{
    return [self blockAtIndex:self.blockPoolIterator];
}

- (JKGameNode*) lastBlock
{
    return [self blockAtIndex:self.blockPoolIterator Offset:(self.blockPool.count/2 - 1)];
}

- (JKGameNode*) getNextBlockAndIncrement
{
    JKGameNode* block = [self blockAtIndex:self.blockPoolIterator Offset:self.blockPool.count/2];
    ++self.blockPoolIterator;
    return block;
}

- (JKGameNode*) blockAtIndex:(NSInteger)index
{
    return [self blockAtIndex:index Offset:0];
}

- (JKGameNode*) blockAtIndex:(NSInteger)index Offset:(NSInteger)offset
{
    JKGameNode* block = nil;
    
    if (self.blockPool != nil)
    {
        index = moduloPositive((index+offset), self.blockPool.count);
        if (index >= 0 && index < self.blockPool.count)
        {
            block = [self.blockPool objectAtIndex:index];
        }
    }
    return block;
}

- (JKGameNode*) currentKeyBlock
{
    return [self keyBlockAtIndex:self.keyBlockPoolIterator];
}

- (JKGameNode*) lastKeyBlock
{
    return [self keyBlockAtIndex:self.keyBlockPoolIterator Offset:(self.keyBlockPool.count/2 - 1)];
}

- (JKGameNode*) getNextKeyBlockAndIncrement
{
    JKGameNode* keyBlock = [self keyBlockAtIndex:self.keyBlockPoolIterator Offset:self.keyBlockPool.count/2];
    ++self.keyBlockPoolIterator;
    return keyBlock;
}

- (JKGameNode*) keyBlockAtIndex:(NSInteger)index
{
    return [self keyBlockAtIndex:index Offset:0];
}

- (JKGameNode*) keyBlockAtIndex:(NSInteger)index Offset:(NSInteger)offset
{
    JKGameNode* keyBlock = nil;
    
    if (self.keyBlockPool != nil)
    {
        index = moduloPositive((index+offset), self.keyBlockPool.count);
        if (index >= 0 && index < self.keyBlockPool.count)
        {
            keyBlock = [self.keyBlockPool objectAtIndex:index];
        }
    }
    return keyBlock;
}

- (void) setBlockPoolIterator:(NSInteger)blockPoolIterator
{
    if (self.blockPool != nil)
    {
        _blockPoolIterator = moduloPositive(blockPoolIterator, self.blockPool.count);
    }
    else
    {
        _blockPoolIterator = blockPoolIterator;
    }
}

- (void) setKeyBlockPoolIterator:(NSInteger)keyBlockPoolIterator
{
    if (self.keyBlockPool != nil)
    {
        _keyBlockPoolIterator = moduloPositive(keyBlockPoolIterator, self.keyBlockPool.count);
    }
    else
    {
        _keyBlockPoolIterator = keyBlockPoolIterator;
    }
}

@end
