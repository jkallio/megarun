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

#define _heroCtrl ((PluginCtrlHero*)((JKGameNode*)self.node).controller)

@implementation PluginContactHandlerHero

- (void) contactBeganWith:(JKGameNode*)nodeB
{
    switch (nodeB.objType)
    {
        case OBJ_TYPE_LASER:
        {
            [self.gameScene endGame];
        } break;
            
        default: break;
    }
}

- (void) contactEndedWith:(JKGameNode*)nodeB
{
}

@end
