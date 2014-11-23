//
//  PluginContactHandlerHeroJumpSensor.m
//  MegaRun
//
//  Created by Jussi Kallio on 22.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import "Defines.h"
#import "AirManStage.h"
#import "BubbleManStage.h"
#import "HeatManStage.h"
#import "QuickManStage.h"
#import "StageSelectLevel.h"
#import "PluginControllerHero.h"
#import "PluginContactHandlerHeroJumpSensor.h"

#define _heroCtrl ((PluginControllerHero*)((JKGameNode*)self.node.parent).controller)
#define _heroNode ((JKGameNode*)self.node.parent)
static const float kSwitchDelay = 0.75f;

@implementation PluginContactHandlerHeroJumpSensor

- (void) contactBeganWith:(JKGameNode*)nodeB
{
    if (IS_TELEPORT_NODE(nodeB.objType))
    {
   
            if (!_heroCtrl.isTeleporting)
            {
                _heroCtrl.state = STATE_TELEPORTING_UP;
                
                switch (nodeB.objType)
                {
                    case OBJ_TYPE_TELEPORT_QUICKMAN:    [self.gameScene switchToLevel:[QuickManStage node] Delay:kSwitchDelay]; break;
                    case OBJ_TYPE_TELEPORT_HEATMAN:     [self.gameScene switchToLevel:[HeatManStage node] Delay:kSwitchDelay]; break;
                    case OBJ_TYPE_TELEPORT_BUBBLEMAN:   [self.gameScene switchToLevel:[BubbleManStage node] Delay:kSwitchDelay]; break;
                    case OBJ_TYPE_TELEPORT_AIRMAN:      [self.gameScene switchToLevel:[AirManStage node] Delay:kSwitchDelay]; break;
                    case OBJ_TYPE_TELEPORT_STAGESEL:    [self.gameScene switchToLevel:[StageSelectLevel node] Delay:kSwitchDelay]; break;
                    default: break;
                }
            }
    }
    else
    {
        switch (nodeB.objType)
        {
            case OBJ_TYPE_TELEPAD: _heroCtrl.state = STATE_NORMAL; break;
            default: break;
        }
    }
    
    [_heroCtrl updateContactFlags];
}

- (void) contactEndedWith:(JKGameNode*)nodeB
{
    [_heroCtrl updateContactFlags];
}

@end
