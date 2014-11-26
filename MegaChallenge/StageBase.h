//
//  StageBase.h
//  MegaChallenge
//
//  Created by Jussi Kallio on 8.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import <JKGameKit/JKGameKit.h>

@interface StageBase : JKWorldNode
@property (nonatomic, weak) JKGameNode* telePad;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger hiScore;
@property (nonatomic, getter=isPitOfDeathEnabled) BOOL pitOfDeathEnabled;
- (NSArray*) levelMap;
@end
