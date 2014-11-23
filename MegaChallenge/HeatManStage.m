//
//  HeatManStage.m
//  MegaRun
//
//  Created by Jussi Kallio on 20.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import "Defines.h"
#import "HeatManStage.h"

@implementation HeatManStage

- (NSArray*) levelMap
{
    NSNumber* _ = [NSNumber numberWithInt:0];
    NSNumber* X = [NSNumber numberWithInt:OBJ_TYPE_HEATMAN_BLOCK];
    NSNumber* Q = [NSNumber numberWithInt:OBJ_TYPE_TELEPORT_QUICKMAN];
    //NSNumber* H = [NSNumber numberWithInt:OBJ_TYPE_TELEPORT_HEATMAN];
    NSNumber* B = [NSNumber numberWithInt:OBJ_TYPE_TELEPORT_BUBBLEMAN];
    NSNumber* A = [NSNumber numberWithInt:OBJ_TYPE_TELEPORT_AIRMAN];
    NSNumber* P = [NSNumber numberWithInt:OBJ_TYPE_TELEPAD];
    return @[X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, @(-1),
             X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X, @(-1),
             X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X, @(-1),
             X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X, @(-1),
             X, _, _, _, _, _, _, _, _, _, Q, _, _, _, _, _, _, _, _, _, X, @(-1),
             X, _, _, _, _, _, _, _, _, X, X, X, _, _, _, _, _, _, _, _, X, @(-1),
             X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X, @(-1),
             X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X, @(-1),
             X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, A, _, X, @(-1),
             X, X, X, X, _, _, _, _, _, _, _, _, _, _, _, _, _, X, X, X, X, @(-1),
             X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X, @(-1),
             X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X, @(-1),
             X, _, _, _, _, _, X, _, _, _, _, _, _, _, X, _, _, _, _, _, X, @(-1),
             X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, X, @(-1),
             X, _, B, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, Q, _, X, @(-1),
             X, X, X, X, _, _, _, _, _, _, P, _, _, _, _, _, _, X, X, X, X, @(-1),
             X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X, X];
}

- (void) LoadLevel
{
    [super LoadLevel];
}

@end
