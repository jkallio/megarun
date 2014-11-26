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
static const CGPoint kInitPos = {1000, -1000};

@interface HeatManStage()
@property (nonatomic) NSMutableArray* blockPool;
@property (nonatomic) NSInteger nextBlockIndex;
@property (nonatomic, weak) JKGameNode* nextBlock;
@property (nonatomic) BOOL shouldReset;
- (void) resetLevel;
- (void) recycleBlocks;
- (NSInteger) Index:(NSInteger)index Increment:(NSInteger)value;
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

- (void) LoadLevel
{
    [super LoadLevel];
    self.pitOfDeathEnabled = YES;
    
    _blockPool = [NSMutableArray new];
    for (int i=0; i < kBlockPoolSize; ++i)
    {
        JKGameNode* block = [NodeFactory createDisappearingBlock:OBJ_TYPE_HEATMAN_BLOCK Position:kInitPos];
        [_disapBlockCtrl(block) setPhase:i%3];
        [self.blockPool addObject:block];
        [self addChild:block];
    }
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
    
    if (self.hero.position.x > (self.nextBlock.position.x - kBlockWidth/2))
    {
        [self recycleBlocks];
        ++self.score;
    }
    
    if (self.shouldReset)
    {
        [self resetLevel];
        self.shouldReset = NO;
    }
}

- (void) resetLevel
{
    CGFloat lastX = 7 * kBlockWidth;
    CGFloat lastY = -7 * kBlockHeight;
    for (int i=0; i < self.blockPool.count; ++i)
    {
        JKGameNode* block = [self.blockPool objectAtIndex:i];
        if (i < 15)
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
    
    self.nextBlockIndex = 0;
    self.nextBlock = [self.blockPool objectAtIndex:self.nextBlockIndex];
}

- (void) recycleBlocks
{
    // Set position for new block
    JKGameNode* lastBlock = [self.blockPool objectAtIndex:[self Index:self.nextBlockIndex Increment:14]];
    JKGameNode* newBlock = [self.blockPool objectAtIndex:[self Index:self.nextBlockIndex Increment:15]];
    
    NSInteger kCoeff = randomInteger(1, 4) * (randomBool() ? -1 : 1);
    newBlock.position = CGPointMake(lastBlock.position.x + 3 * kBlockWidth, lastBlock.position.y + kCoeff * kBlockHeight);
    
    // Set next target block
    JKGameNode* nextBlock = [self.blockPool objectAtIndex:[self Index:self.nextBlockIndex Increment:1]];
    self.nextBlock = nextBlock;
    ++self.nextBlockIndex;
}

- (NSInteger) Index:(NSInteger)index Increment:(NSInteger)value
{
    index = (index + value) % self.blockPool.count;
    return index;
}

@end
