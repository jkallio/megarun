//
//  Defines.h
//  MegaChallenge
//
//  Created by Jussi Kallio on 4.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#ifndef MegaChallenge_Defines_h
#define MegaChallenge_Defines_h

#define OBJ_TYPE_NONE               0
#define OBJ_TYPE_DYNAMIC_BASE       OBJ_TYPE_NONE
#define OBJ_TYPE_HERO               OBJ_TYPE_DYNAMIC_BASE + 1
#define OBJ_TYPE_DYNAMIC_END        OBJ_TYPE_DYNAMIC_BASE + 2

#define OBJ_TYPE_STATIC_BASE        OBJ_TYPE_DYNAMIC_END
#define OBJ_TYPE_QUICKMAN_BLOCK     OBJ_TYPE_STATIC_BASE + 1
#define OBJ_TYPE_HEATMAN_BLOCK      OBJ_TYPE_STATIC_BASE + 2
#define OBJ_TYPE_BUBBLEMAN_BLOCK    OBJ_TYPE_STATIC_BASE + 3
#define OBJ_TYPE_AIRMAN_BLOCK       OBJ_TYPE_STATIC_BASE + 4
#define OBJ_TYPE_STATIC_END         OBJ_TYPE_STATIC_BASE + 5

#define OBJ_TYPE_TELEPORT_BASE      OBJ_TYPE_STATIC_END
#define OBJ_TYPE_TELEPORT_QUICKMAN  OBJ_TYPE_TELEPORT_BASE + 1
#define OBJ_TYPE_TELEPORT_HEATMAN   OBJ_TYPE_TELEPORT_BASE + 2
#define OBJ_TYPE_TELEPORT_BUBBLEMAN OBJ_TYPE_TELEPORT_BASE + 3
#define OBJ_TYPE_TELEPORT_AIRMAN    OBJ_TYPE_TELEPORT_BASE + 4
#define OBJ_TYPE_TELEPORT_STAGESEL  OBJ_TYPE_TELEPORT_BASE + 5
#define OBJ_TYPE_TELEPORT_END       OBJ_TYPE_TELEPORT_BASE + 6

#define OBJ_TYPE_SPECIAL_BASE       OBJ_TYPE_TELEPORT_END
#define OBJ_TYPE_SENSOR             OBJ_TYPE_SPECIAL_BASE + 1
#define OBJ_TYPE_TELEPAD            OBJ_TYPE_SPECIAL_BASE + 2
#define OBJ_TYPE_LASER              OBJ_TYPE_SPECIAL_BASE + 3
#define OBJ_TYPE_SPECIAL_END        OBJ_TYPE_SPEICAL_BASE + 4

#define IS_DYNAMIC_NODE(x) (x > OBJ_TYPE_DYNAMIC_BASE && x < OBJ_TYPE_DYNAMIC_END)
#define IS_STATIC_NODE(x) (x > OBJ_TYPE_STATIC_BASE && x < OBJ_TYPE_STATIC_END)
#define IS_TELEPORT_NODE(x) (x > OBJ_TYPE_TELEPORT_BASE && x < OBJ_TYPE_TELEPORT_END)

#define NODE_NAME_HUD           @"NameHud"
#define NODE_NAME_HUD_JOYPAD    @"NameJoypad"
#define NODE_NAME_HUD_BUTTON    @"NameButton"
#define NODE_NAME_HUD_SCORE     @"NameScore"
#define NODE_NAME_HUD_HISCORE   @"NameHiScore"
#define NODE_NAME_HUD_BACKFRAME @"NameHudBackframe"

#define NODE_NAME_BLOCK         @"NameBlock"
#define NODE_NAME_TELEPORT      @"NameTeleport"
#define NODE_NAME_TELEPAD       @"NameTelepad"
#define NODE_NAME_LASER         @"NameLaser"

#define SENSOR_NAME_JUMP        @"SensorJump"
#define SENSOR_NAME_LEFT        @"SensorLeft"
#define SENSOR_NAME_RIGHT       @"SensorRight"
#define SENSOR_NAME_TELEPORT    @"SensorTeleport"

#define Z_POS_HUD       100
#define Z_POS_LASER     20
#define Z_POS_HERO      10
#define Z_POS_STATIC    9

#define HERO_ANIM_KEY_STOP      [NSNumber numberWithInteger:1]
#define HERO_ANIM_KEY_MOVE      [NSNumber numberWithInteger:2]
#define HERO_ANIM_KEY_JUMP      [NSNumber numberWithInteger:3]
#define HERO_ANIM_KEY_TELEPORT  [NSNumber numberWithInteger:4]

static const float kBlockWidth = 32.0f;
static const float kBlockHeight = 32.0f;

#endif
