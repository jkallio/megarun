//
//  PluginControllerHero.m
//  MegaChallenge
//
//  Created by Jussi Kallio on 4.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import "Defines.h"
#import "StageBase.h"
#import "PluginControllerHero.h"

@interface PluginControllerHero()
@property (nonatomic) NSTimeInterval timeSincePrevJump;
@property (nonatomic) NSTimeInterval timeInAir;
@property (nonatomic) NSTimeInterval jumpTimeout;
@property (nonatomic) BOOL canJump;
@property (nonatomic, weak) JKSpriteNode* jumpSensor;
@property (nonatomic, weak) JKSpriteNode* leftSensor;
@property (nonatomic, weak) JKSpriteNode* rightSensor;
- (CGVector) applyForces:(CGVector)curVelocity Timestep:(NSTimeInterval)dt;
@end

@implementation PluginControllerHero
@synthesize joypadLeftDown = _joypadLeftDown;
@synthesize joypadRightDown = _joypadRightDown;
@synthesize jumpButtonDown = _jumpButtonDown;

- (instancetype) initWithNode:(SKNode<JKNodeProtocol> *)node
{
    if (self = [super initWithNode:node])
    {
        _runSpeed = 200.0f;
        _jumpForce = 70.0f;
        _timeInAir = 0.0f;
        _maxVelocity = CGVectorMake(250.0f, 400.0f);
        
        _canJump = NO;
    }
    return self;
}

- (void) onUpdate:(NSTimeInterval)dt
{
    self.onGround = self.jumpSensor.physicsBody.allContactedBodies.count > 0;

    if (self.isTeleporting)
    {
        switch (self.state)
        {
            default:
            case STATE_TELEPORTING_DOWN: self.node.physicsBody.velocity = CGVectorMake(0.0f, -750.0f);
            case STATE_TELEPORTING_UP: self.node.physicsBody.velocity = CGVectorMake(0.0f, 750.0f);
        }
    }
    else
    {
        self.node.physicsBody.velocity = [self applyForces:self.node.physicsBody.velocity Timestep:dt];
    }
    
    self.world.camera.targetPosition = self.node.position;
    
    self.timeSincePrevJump += dt;
    if (!self.onGround)
    {
        self.timeInAir += dt;
    }
}

#pragma mark --
- (CGVector) applyForces:(CGVector)curVelocity Timestep:(NSTimeInterval)dt
{
    if (self.joypadLeftDown)
    {
        if (self.leftSensor.physicsBody.allContactedBodies.count == 0)
        {
            if (!self.onGround && curVelocity.dx > 0.0f)
            {
                curVelocity.dx = 0.0f;
            }
            curVelocity.dx = curVelocity.dx <= self.runSpeed ? -self.runSpeed : curVelocity.dx - self.runSpeed/5.0f;
        }
    }
    else if (self.joypadRightDown)
    {
        if (self.rightSensor.physicsBody.allContactedBodies.count == 0)
        {
            if (!self.onGround && curVelocity.dx < 0.0f)
            {
                curVelocity.dx = 0.0f;
            }
            curVelocity.dx = curVelocity.dx >= self.runSpeed ? self.runSpeed : curVelocity.dx + self.runSpeed/5.0f;
        }
    }
    else
    {
        if (ABS(curVelocity.dx) > 0)
        {
            CGVector inertiaStep = CGVectorScalarMultiply(CGVectorMake(-20*curVelocity.dx, 0.0f), dt);
            curVelocity = CGVectorAdd(curVelocity, inertiaStep);
        }
    }
    
    if (self.jumpButtonDown)
    {
        if (self.jumpTimeout > 0.1f || self.timeInAir > 0.25)
        {
            self.jumpButtonDown = NO;
            self.canJump = NO;
        }
        
        if (self.canJump)
        {
            curVelocity = CGVectorAdd(curVelocity, CGVectorMake(0.0f, self.jumpForce));
            
            if (curVelocity.dy >= self.maxVelocity.dy)
            {
                self.jumpTimeout += dt;
                curVelocity.dy = self.maxVelocity.dy;
            }
        }
    }
    return curVelocity;
}

#pragma mark -- Getters/Setters
- (void) setJoypadLeftDown:(BOOL)joypadLeftDown
{
    if (joypadLeftDown)
    {
        _joypadRightDown = NO;
    }
    _joypadLeftDown = joypadLeftDown;
}

- (void) setJoypadRightDown:(BOOL)joypadRightDown
{
    if (joypadRightDown)
    {
        _joypadLeftDown = NO;
    }
    _joypadRightDown = joypadRightDown;
}

- (void) setJumpButtonDown:(BOOL)jumpButtonDown
{
    if (jumpButtonDown)
    {
        if (self.timeSincePrevJump > 0.3f)
        {
            _jumpButtonDown = jumpButtonDown;
            self.timeSincePrevJump  = 0.0f;
        }
        self.canJump = self.onGround;
    }
    else
    {
        _jumpButtonDown = NO;
    }
}

- (BOOL) isTeleporting
{
    return _state == STATE_TELEPORTING_DOWN || _state == STATE_TELEPORTING_UP;
}

- (JKSpriteNode*) jumpSensor
{
    if (!_jumpSensor)
    {
        _jumpSensor = [self.gameNode sensorNamed:SENSOR_NAME_JUMP];
    }
    return _jumpSensor;
}

- (JKSpriteNode*) leftSensor
{
    if (!_leftSensor)
    {
        _leftSensor = [self.gameNode sensorNamed:SENSOR_NAME_LEFT];
    }
    return _leftSensor;
}

- (JKSpriteNode*) rightSensor
{
    if (!_rightSensor)
    {
        _rightSensor = [self.gameNode sensorNamed:SENSOR_NAME_RIGHT];
    }
    return _rightSensor;
}

- (void) setOnGround:(BOOL)onGround
{
    if (onGround && _onGround)
    {
        self.jumpTimeout = 0.0f;
        self.timeInAir = 0.0f;
        self.canJump = YES;
    }
    _onGround = onGround;
}

@end
