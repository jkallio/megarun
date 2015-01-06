//
//  QuickManStage.m
//  MegaRun
//
//  Created by Jussi Kallio on 20.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import <JKGameKit/JKUtils.h>
#import "Defines.h"
#import "NodeFactory.h"
#import "PluginCtrlLaser.h"
#import "QuickManStage.h"

#define PROP_IS_LEFT    @"PropIsLeft"
#define PROP_ROW_LEN    @"PropRowLen"
#define PROP_LASER      @"PropLaser"

#define _laserCtrl(node) ((PluginCtrlLaser*)((JKGameNode*)node).controller)

static const int kBlockPoolSize = 200;
static const int kKeyBlockPoolSize = 10;

@interface QuickManStage()
@property (nonatomic) BOOL shouldReset;
- (void) resetLevel;
- (void) recycleBlocks;
- (void) createRowForKeyBlock:(JKGameNode*)keyBlock PrevKeyBlock:(JKGameNode*)prevKeyBlock;
@end

@implementation QuickManStage

- (NSArray*) levelMap
{
    NSNumber* _ = [NSNumber numberWithInt:0];
    NSNumber* X = [NSNumber numberWithInt:OBJ_TYPE_QUICKMAN_BLOCK];
    NSNumber* S = [NSNumber numberWithInt:OBJ_TYPE_TELEPORT_STAGESEL];
    NSNumber* P = [NSNumber numberWithInt:OBJ_TYPE_TELEPAD];
    return @[X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, @(-1),
             X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X, @(-1),
             X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X, @(-1),
             X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X, @(-1),
             X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X, @(-1),
             X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X, @(-1),
             X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X, @(-1),
             X, _, _, _, _, _, _, _, _, _, S, _, _, _, _, _, _, _, _, _, X, @(-1),
             X, _, _, _, _, _, _, _, _, X, X, X, _, _, _, _, _, _, _, _, X, @(-1),
             X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X, @(-1),
             X, _, _, _, _, _, _, _, _, _, P, _, _, _, _, _, _, _, _, _, X, @(-1),
             X, X, _, _, _, _, _, X, X, X, X, X, X, X, _, _, _, _, _, X, X];
}

- (void) loadLevel
{
    [super loadLevel];
    self.pitOfDeathEnabled = NO;
    
    NSMutableArray* tmpPool = [NSMutableArray new];
    for (int i=0; i < kBlockPoolSize; ++i)
    {
        JKGameNode* block = [NodeFactory createBlock:OBJ_TYPE_QUICKMAN_BLOCK Position:kInitPos];
        [tmpPool addObject:block];
        [self addChild:block];
    }
    self.blockPool = [NSArray arrayWithArray:tmpPool];
    
    [tmpPool removeAllObjects];
    for (int i=0; i < kKeyBlockPoolSize; ++i)
    {
        JKGameNode* keyBlock = [NodeFactory createBlock:OBJ_TYPE_AIRMAN_BLOCK Position:kInitPos];
        [tmpPool addObject:keyBlock];
        [self addChild:keyBlock];
        
        JKGameNode* laser = [NodeFactory createLaserWithPosition:kInitPos];
        [keyBlock setProperty:PROP_LASER Object:laser];
        [self addChild:laser];
    }
    self.keyBlockPool = [NSArray arrayWithArray:tmpPool];
    
    self.shouldReset = YES;
}

- (void) resetLevel
{
    self.blockPoolIterator = 0;
    self.keyBlockPoolIterator = 0;
    
    for (JKGameNode* block in self.blockPool)
    {
        block.position = kInitPos;
    }
    
    JKGameNode* prevBlock = nil;
    for (int i=0; i < self.keyBlockPool.count; ++i)
    {
        JKGameNode* keyBlock = [self.keyBlockPool objectAtIndex:i];
        _laserCtrl(keyBlock).activated = NO;
        
        if (i < self.keyBlockPool.count/2)
        {
            [self createRowForKeyBlock:keyBlock PrevKeyBlock:prevBlock];
            prevBlock = keyBlock;
        }
        else
        {
            keyBlock.position = kInitPos;
        }
    }
    
    self.targetBlock = [self currentKeyBlock];
    self.shouldReset = NO;
}


- (void) recycleBlocks
{
    JKGameNode* lastBlock = [self lastKeyBlock];
    JKGameNode* newBlock = [self getNextKeyBlockAndIncrement];
    
    [self createRowForKeyBlock:newBlock PrevKeyBlock:lastBlock];
    
     self.targetBlock = [self currentKeyBlock];
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
    
    if (self.hero.position.y < (self.targetBlock.position.y - kBlockHeight/2))
    {
        ++self.score;
        
        JKGameNode* nextBlock = [self keyBlockAtIndex:self.keyBlockPoolIterator Offset:1];
        _laserCtrl([nextBlock getObjectProperty:PROP_LASER]).activated = YES;
        
        [self recycleBlocks];
    }
    
    if (self.shouldReset)
    {
        [self resetLevel];
    }
}

- (void) createRowForKeyBlock:(JKGameNode*)keyBlock PrevKeyBlock:(JKGameNode*)prevKeyBlock
{
    NSInteger rowLen = randomInteger(3, 16);
    BOOL isLeft = randomBool();
    
    if (prevKeyBlock != nil)
    {
        BOOL isPrevLeft = [prevKeyBlock getBoolProperty:PROP_IS_LEFT];
        NSInteger prevRowLen = [prevKeyBlock getIntProperty:PROP_ROW_LEN];
        if (isPrevLeft == isLeft)
        {
            if (prevRowLen > 12)
            {
                isLeft = !isLeft;
            }
            else
            {
                rowLen = prevRowLen + 3;
            }
        }
    }
    
    CGFloat xPos = (isLeft ? 0 : 20) * kBlockWidth;
    CGFloat yPos = prevKeyBlock != nil ? (prevKeyBlock.position.y - 3 * kBlockHeight) : (-14 * kBlockHeight);
    
    [keyBlock setProperty:PROP_IS_LEFT Bool:isLeft];
    [keyBlock setProperty:PROP_ROW_LEN Integer:rowLen];
    [keyBlock setPosition:CGPointMake(xPos, yPos)];
    if (isLeft)
    {
        for (int i=0; i < rowLen; ++i)
        {
            JKGameNode* block = [self getNextBlockAndIncrement];
            block.position = CGPointMake((i+1)*kBlockWidth, keyBlock.position.y);
        }
    }
    else
    {
        for (int i=20; i >= (20 - rowLen); --i)
        {
            JKGameNode* block = [self getNextBlockAndIncrement];
            block.position = CGPointMake((i-1)*kBlockWidth, keyBlock.position.y);
        }
    }
    
    // Set walls
    [self getNextBlockAndIncrement].position = CGPointMake((isLeft ? 20 : 0) * kBlockWidth, keyBlock.position.y);
    [self getNextBlockAndIncrement].position = CGPointMake(0, keyBlock.position.y + kBlockHeight);
    [self getNextBlockAndIncrement].position = CGPointMake(0, keyBlock.position.y + 2 * kBlockHeight);
    [self getNextBlockAndIncrement].position = CGPointMake(20 * kBlockWidth, keyBlock.position.y + kBlockHeight);
    [self getNextBlockAndIncrement].position = CGPointMake(20 * kBlockWidth, keyBlock.position.y + 2 * kBlockHeight);
    
    // Set Laser position
    JKGameNode* laser = [keyBlock getObjectProperty:PROP_LASER];
    _laserCtrl(laser).activated = NO;
    laser.position = CGPointMake((isLeft ? -0.5 * kBlockWidth - laser.spriteNode.size.width/2 : 20.5 *kBlockWidth + laser.spriteNode.size.width/2), keyBlock.position.y + 1.5*kBlockHeight);
}
@end
