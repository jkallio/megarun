//
//  HeatManStage.m
//  MegaRun
//
//  Created by Jussi Kallio on 20.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import "Defines.h"
#import "PluginCtrlDisappearingBlock.h"
#import "NodeFactory.h"
#import "HeatManStage.h"

#define _disapBlockCtrl(block) ((PluginCtrlDisappearingBlock*)block.controller)

static const int kBlockPoolSize = 30;

@interface HeatManStage()
@property (nonatomic) BOOL shouldReset;
- (void) resetLevel;
- (void) recycleBlocks;
@end

@implementation HeatManStage

- (NSArray*) levelMap
{
    NSNumber* _ = [NSNumber numberWithInt:0];
    NSNumber* X = [NSNumber numberWithInt:OBJ_TYPE_HEATMAN_BLOCK];
    NSNumber* S = [NSNumber numberWithInt:OBJ_TYPE_TELEPORT_STAGESEL];
    NSNumber* P = [NSNumber numberWithInt:OBJ_TYPE_TELEPAD];
    return @[X, X, X, X, X, X, X, X, @(-1),
             X, _, _, _, _, _, _, _, @(-1),
             X, _, _, _, _, _, _, _, @(-1),
             X, _, _, _, _, _, _, _, @(-1),
             X, _, _, _, _, _, _, _, @(-1),
             X, _, _, _, _, _, _, _, @(-1),
             X, _, S, _, P, _, _, _, @(-1),
             X, X, X, X, X, X, X, X];
}

- (void) loadLevel
{
    [super loadLevel];
    self.pitOfDeathEnabled = YES;
    
    NSMutableArray* tmpPool = [NSMutableArray new];
    for (int i=0; i < kBlockPoolSize; ++i)
    {
        JKGameNode* block = [NodeFactory createDisappearingBlock:OBJ_TYPE_HEATMAN_BLOCK Position:kInitPos];
        [_disapBlockCtrl(block) setPhase:i%3];
        [tmpPool addObject:block];
        [self addChild:block];
    }
    self.blockPool = [NSArray arrayWithArray:tmpPool];
}

- (void) resetLevel
{
    CGFloat lastX = 7 * kBlockWidth;
    CGFloat lastY = -7 * kBlockHeight;
    
    for (int i=0; i < self.blockPool.count; ++i)
    {
        JKGameNode* block = [self.blockPool objectAtIndex:i];
        if (i < kBlockPoolSize/2)
        {
            lastX += 3*kBlockWidth;
            lastY += (randomInteger(1, 4) * (randomBool() ? -1 : 1)) * kBlockHeight;
            block.position = CGPointMake(lastX, lastY);
        }
        else
        {
            block.position = kInitPos;
        }
    }
    
    self.blockPoolIterator = 0;
    self.targetBlock = [self currentBlock];
    self.shouldReset = NO;
}

- (void) onGameBegin
{
    [super onGameBegin];
    self.shouldReset = YES;
}

- (void) onGameOver
{
    [super onGameOver];
}

- (void) onUpdate:(NSTimeInterval)dt
{
    [super onUpdate:dt];
    
    if (self.hero.position.x > (self.targetBlock.position.x - kBlockWidth/2))
    {
        [self recycleBlocks];
        ++self.score;
    }
    
    if (self.shouldReset)
    {
        [self resetLevel];
    }
}

- (void) recycleBlocks
{
    // Set position for new block
    JKGameNode* lastBlock = [self lastBlock];
    JKGameNode* newBlock = [self getNextBlockAndIncrement];
    
    NSInteger kCoeff = randomInteger(1, 4) * (randomBool() ? -1 : 1);
    newBlock.position = CGPointMake(lastBlock.position.x + 3 * kBlockWidth, lastBlock.position.y + kCoeff * kBlockHeight);
    
    // Set next target block
    self.targetBlock = [self currentBlock];
}

@end
