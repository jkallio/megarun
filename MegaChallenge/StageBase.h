//
//  StageBase.h
//  MegaChallenge
//
//  Created by Jussi Kallio on 8.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import <JKGameKit/JKGameKit.h>

static const CGPoint kInitPos = {-5000.0f, 5000.0f};

@interface StageBase : JKWorldNode
{
    
}
@property (nonatomic) NSArray* blockPool;
@property (nonatomic) NSArray* keyBlockPool;
@property (nonatomic) NSInteger blockPoolIterator;
@property (nonatomic) NSInteger keyBlockPoolIterator;
@property (nonatomic, weak) JKGameNode* targetBlock;
@property (nonatomic, weak) JKGameNode* telePad;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger hiScore;
@property (nonatomic, getter=isPitOfDeathEnabled) BOOL pitOfDeathEnabled;

- (NSArray*) levelMap;

- (JKGameNode*) currentBlock;
- (JKGameNode*) lastBlock;
- (JKGameNode*) getNextBlockAndIncrement;
- (JKGameNode*) blockAtIndex:(NSInteger)index;
- (JKGameNode*) blockAtIndex:(NSInteger)index Offset:(NSInteger)offset;

- (JKGameNode*) currentKeyBlock;
- (JKGameNode*) lastKeyBlock;
- (JKGameNode*) getNextKeyBlockAndIncrement;
- (JKGameNode*) keyBlockAtIndex:(NSInteger)index;
- (JKGameNode*) keyBlockAtIndex:(NSInteger)index Offset:(NSInteger)offset;

@end
