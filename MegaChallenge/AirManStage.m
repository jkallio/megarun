//
//  AirManStage.m
//  MegaRun
//
//  Created by Jussi Kallio on 20.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import "Defines.h"
#import "AirManStage.h"

@implementation AirManStage

- (NSArray*) levelMap
{
    NSNumber* _ = [NSNumber numberWithInt:0];
    NSNumber* X = [NSNumber numberWithInt:OBJ_TYPE_AIRMAN_BLOCK];
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
}

@end
