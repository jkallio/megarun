//
//  PluginControllerHero.h
//  MegaChallenge
//
//  Created by Jussi Kallio on 4.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import <JKGameKit/JKGameKit.h>

typedef enum _EState
{
    STATE_NORMAL,
    STATE_TELEPORTING_DOWN,
    STATE_TELEPORTING_UP,
} EState;

@interface PluginCtrlHero : JKPluginCtrlBase

#pragma mark -- State
@property (nonatomic) EState state;
@property (nonatomic, readonly, getter=isTeleporting) BOOL teleporting;
@property (nonatomic, getter=isOnGround) BOOL onGround;

#pragma mark -- Controller
@property (nonatomic, getter=isJoypadLeftDown) BOOL joypadLeftDown;
@property (nonatomic, getter=isJoypadRightDown) BOOL joypadRightDown;
@property (nonatomic, getter=isJumpButtonDown) BOOL jumpButtonDown;

#pragma mark -- Physical limits
@property (nonatomic) CGFloat runSpeed;
@property (nonatomic) CGFloat jumpForce;
@property (nonatomic) CGVector maxVelocity;

#pragma mark -- Contacting Nodes
@property (nonatomic, weak) JKGameNode* jumpSensor;
@property (nonatomic, weak) JKGameNode* leftSensor;
@property (nonatomic, weak) JKGameNode* rightSensor;
@property (nonatomic) BOOL leftSensorContact;
@property (nonatomic) BOOL rightSensorContact;
@property (nonatomic) BOOL jumpSensorContact;

- (void) updateContactFlags;
@end
