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
#import "PluginCtrlHero.h"
#import "PluginContactHandlerHeroRightSensor.h"

#define _heroCtrl ((PluginCtrlHero*)((JKGameNode*)self.node.parent).controller)
#define _heroNode ((JKGameNode*)self.node.parent)

@implementation PluginContactHandlerHeroRightSensor

- (void) contactBeganWith:(JKGameNode*)nodeB
{
    [_heroCtrl updateContactFlags];
}

- (void) contactEndedWith:(JKGameNode*)nodeB
{
    [_heroCtrl updateContactFlags];
}

@end
