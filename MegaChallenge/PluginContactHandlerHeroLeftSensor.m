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
#import "PluginContactHandlerHeroLeftSensor.h"

#define _heroCtrl ((PluginControllerHero*)((JKGameNode*)self.node.parent).controller)
#define _heroNode ((JKGameNode*)self.node.parent)

@implementation PluginContactHandlerHeroLeftSensor

- (void) contactBeganWith:(JKGameNode*)nodeB
{
    [_heroCtrl updateContactFlags];
}

- (void) contactEndedWith:(JKGameNode*)nodeB
{
    [_heroCtrl updateContactFlags];
}

@end
