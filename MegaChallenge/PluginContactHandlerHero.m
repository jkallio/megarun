//
//  PluginContactHandlerHero.m
//  MegaRun
//
//  Created by Jussi Kallio on 16.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import "Defines.h"
#import "AirManStage.h"
#import "BubbleManStage.h"
#import "HeatManStage.h"
#import "QuickManStage.h"
#import "StageSelectLevel.h"
#import "PluginContactHandlerHero.h"

@implementation PluginContactHandlerHero

- (void) contactBeganWith:(JKGameNode*)nodeB
{
    if ([self.node.name isEqualToString:SENSOR_NAME_JUMP])
    {
        
    }
    
    if (IS_TELEPORT_NODE(nodeB.objType) && [self.node.name isEqualToString:SENSOR_NAME_JUMP])
    {
        switch (nodeB.objType)
        {
            case OBJ_TYPE_TELEPORT_QUICKMAN: [self.gameScene switchToLevel:[QuickManStage node] Delay:0.5f]; break;
            case OBJ_TYPE_TELEPORT_HEATMAN: [self.gameScene switchToLevel:[HeatManStage node] Delay:0.5f]; break;
            case OBJ_TYPE_TELEPORT_BUBBLEMAN: [self.gameScene switchToLevel:[BubbleManStage node] Delay:0.5f]; break;
            case OBJ_TYPE_TELEPORT_AIRMAN: [self.gameScene switchToLevel:[AirManStage node] Delay:0.5f]; break;
            case OBJ_TYPE_TELEPORT_STAGESEL: [self.gameScene switchToLevel:[StageSelectLevel node] Delay:0.5f]; break;
        }
    }
    else if (nodeB.objType == OBJ_TYPE_TELEPAD)
    {
        
    }
}

- (void) contactEndedWith:(JKGameNode*)nodeB
{
}

@end
