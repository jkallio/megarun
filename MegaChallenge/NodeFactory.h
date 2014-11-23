//
//  NodeFactory.h
//  MegaChallenge
//
//  Created by Jussi Kallio on 4.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import <JKGameKit/JKGameKit.h>


@interface NodeFactory : NSObject

+ (NSArray*) createLevelMap:(NSArray*)levelMap;

+ (JKGameNode*) createObjectWithType:(NSInteger)type Position:(CGPoint)position;

+ (JKGameNode*) createHeroWithPosition:(CGPoint)position;
+ (JKGameNode*) createTelePadWithPosition:(CGPoint)position;
+ (JKGameNode*) createBlock:(NSInteger) type Position:(CGPoint)position;
+ (JKGameNode*) createTeleport:(NSInteger) type Position:(CGPoint)position;

@end
