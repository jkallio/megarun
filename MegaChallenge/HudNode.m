//
//  HudNode.m
//  MegaChallenge
//
//  Created by Jussi Kallio on 11.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import "Defines.h"
#import "StageBase.h"
#import "PluginCtrlHero.h"
#import "PluginTouchHandlerHudButton.h"
#import "HudNode.h"

#define _heroCtrl ((PluginCtrlHero*)self.world.hero.controller)

typedef enum _EJoypadState
{
    JOYPAD_CENTER,
    JOYPAD_LEFT_DOWN,
    JOYPAD_RIGHT_DOWN
} EJoypadState;

typedef enum _EBtnState
{
    BTN_UP,
    BTN_DOWN
} EBtnState;

@interface HudNode()

@property (nonatomic) EJoypadState joypadState;
@property (nonatomic) EBtnState jumpBtnState;

- (void) checkControllerButtonStates;
- (void) createBackframeForNode:(SKSpriteNode*)node;

@property (nonatomic, weak) JKShadowedLabelNode* debugLabel;
- (void) changeDebugValue:(CGFloat)value;
@end

@implementation HudNode

- (id) init
{
    if (self = [super init])
    {
        self.name = NODE_NAME_HUD;
        self.zPosition = Z_POS_HUD;
        
        _joypad = JOYPAD_CENTER;
        _jumpBtnState = BTN_UP;
    }
    return self;
}

- (void) onEnter
{
    [super onEnter];
    JKDebugLog(@"Screen size: %@", NSStringFromCGSize(self.scene.size));
    
    JKSpriteNode* joypad = [JKSpriteNode spriteNodeWithTexture:[__sharedTextureCache getTextureNamed:@"ctrl_center"]];
    joypad.name = NODE_NAME_HUD_JOYPAD;
    joypad.zPosition = Z_POS_HUD;
    joypad.position = CGPointMake(joypad.size.width/1.5f, joypad.size.height/1.5f);
    [PluginTouchHandlerHudButton createAndAttachToNode:joypad];
    [self createBackframeForNode:joypad];
    [self addChild:joypad];
    _joypad = joypad;
    
    JKSpriteNode* button = [JKSpriteNode spriteNodeWithTexture:[__sharedTextureCache getTextureNamed:@"ctrl_btn_up"]];
    button.name = NODE_NAME_HUD_BUTTON;
    button.zPosition = Z_POS_HUD;
    button.position = CGPointMake(self.scene.size.width - button.size.width/1.5f, button.size.height/1.5f);
    [PluginTouchHandlerHudButton createAndAttachToNode:button];
    [self createBackframeForNode:button];
    [self addChild:button];
    _button = button;
    
    /*
    JKShadowedLabelNode* lblScore = [JKShadowedLabelNode labelNodeWithFontNamed:@"Nintendoid-1"];
    lblScore.name = NODE_NAME_HUD_SCORE;
    lblScore.zPosition = Z_POS_HUD;
    lblScore.position = CGPointMake(self.scene.size.width - PIXELS(50), self.scene.size.height - PIXELS(30));
    lblScore.fontSize = 20;
    lblScore.fontColor = [UIColor whiteColor];
    [self addChild:lblScore];
    _lblScore = lblScore;
    
    JKShadowedLabelNode* lblHiScore = [JKShadowedLabelNode labelNodeWithFontNamed:@"Nintendoid-1"];
    lblHiScore.name = NODE_NAME_HUD_HISCORE;
    lblHiScore.zPosition = Z_POS_HUD;
    lblHiScore.position = CGPointMake(0, self.scene.size.height - PIXELS(30));
    lblHiScore.fontSize = 20;
    lblHiScore.fontColor = [UIColor whiteColor];
    [self addChild:lblHiScore];
    _lblHiScore = lblHiScore;
    
    self.lblScore.position = CGPointMake(self.scene.size.width - self.lblScore.frame.size.width/2 - PIXELS(10), self.scene.size.height - PIXELS(30));
    self.lblHiScore.position = CGPointMake(self.lblHiScore.frame.size.width/2 + PIXELS(10), self.scene.size.height - PIXELS(30));
    */
    
    static float dbSize = 20.0f;
    
    JKSpriteNode* debugDecrease = [JKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(dbSize, dbSize)];
    debugDecrease.name = @"debugDecrease";
    debugDecrease.zPosition = Z_POS_HUD;
    debugDecrease.position = CGPointMake(self.scene.size.width/2 - 120.0f, self.scene.size.height - debugDecrease.size.height/1.5f);
    [PluginTouchHandlerHudButton createAndAttachToNode:debugDecrease];
    [self createBackframeForNode:debugDecrease];
    [self addChild:debugDecrease];
    
    JKSpriteNode* debugIncrease = [JKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:CGSizeMake(dbSize, dbSize)];
    debugIncrease.name = @"debugIncrease";
    debugIncrease.zPosition = Z_POS_HUD;
    debugIncrease.position = CGPointMake(self.scene.size.width/2 + 120.0f, debugDecrease.position.y);
    [PluginTouchHandlerHudButton createAndAttachToNode:debugIncrease];
    [self createBackframeForNode:debugIncrease];
    [self addChild:debugIncrease];
    
    JKSpriteNode* debugChange = [JKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(dbSize, dbSize)];
    debugChange.name = @"debugChange";
    debugChange.zPosition = Z_POS_HUD;
    debugChange.position = CGPointMake(self.scene.size.width - 2*dbSize, debugDecrease.position.y);
    [PluginTouchHandlerHudButton createAndAttachToNode:debugChange];
    [self createBackframeForNode:debugChange];
    [self addChild:debugChange];
    
    JKShadowedLabelNode* debugLabel = [JKShadowedLabelNode labelNodeWithFontNamed:@"Nintendoid-1"];
    debugLabel.name = @"debugLabel";
    debugLabel.zPosition = Z_POS_HUD;
    debugLabel.position = CGPointMake(self.scene.size.width/2, self.scene.size.height - PIXELS(20));
    debugLabel.fontSize = 10;
    debugLabel.fontColor = [UIColor whiteColor];
    [self addChild:debugLabel];
    _debugLabel = debugLabel;
    
    [self setDebugSelectedItem:1];
}

- (void) createBackframeForNode:(SKSpriteNode*)node
{
    JKSpriteNode* backframe = [JKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMultiply(node.size, 2)];
    backframe.name = NODE_NAME_HUD_BACKFRAME;
    backframe.zPosition = -1;
    [node addChild:backframe];
}

- (void) onUpdate:(NSTimeInterval)dt
{
    [self checkControllerButtonStates];
    
    //[self.lblScore setText:[NSString stringWithFormat:@"%04d", (int)((StageBase*)self.world).score]];
    //[self.lblHiScore setText:[NSString stringWithFormat:@"%04d", (int)((StageBase*)self.world).hiScore]];
}

- (void) checkControllerButtonStates
{
    EJoypadState state = JOYPAD_CENTER;
    if (_heroCtrl.joypadLeftDown) state = JOYPAD_LEFT_DOWN;
    else if (_heroCtrl.joypadRightDown) state = JOYPAD_RIGHT_DOWN;
    
    if (state != self.joypadState)
    {
        self.joypadState = state;
        
        switch (self.joypadState)
        {
            case JOYPAD_CENTER: [self.joypad setTexture:[__sharedTextureCache getTextureNamed:@"ctrl_center"]]; break;
            case JOYPAD_LEFT_DOWN: [self.joypad setTexture:[__sharedTextureCache getTextureNamed:@"ctrl_left"]]; break;
            case JOYPAD_RIGHT_DOWN: [self.joypad setTexture:[__sharedTextureCache getTextureNamed:@"ctrl_right"]]; break;
        }
    }
    
    EBtnState btnState = _heroCtrl.jumpButtonDown ? BTN_DOWN : BTN_UP;
    if (btnState != self.jumpBtnState)
    {
        _jumpBtnState = btnState;
        [self.button setTexture:[__sharedTextureCache getTextureNamed:[NSString stringWithFormat:@"%@", _heroCtrl.jumpButtonDown ? @"ctrl_btn_down" : @"ctrl_btn_up"]] ];
    }
}

- (void) setDebugSelectedItem:(NSInteger)debugSelectedItem
{
    debugSelectedItem = debugSelectedItem > 2 ? 0 : debugSelectedItem;
    _debugSelectedItem = debugSelectedItem;
    [self changeDebugValue:0.0f];
}

- (void) decreaseDebug
{
    [self changeDebugValue:-1.0f];
}

- (void) increaseDebug
{
    [self changeDebugValue:1.0f];
}

- (void) changeDebugValue:(CGFloat)value
{
    switch (self.debugSelectedItem)
    {
        case 1:
        {
            _heroCtrl.jumpForce += value;
            [self.debugLabel setText:[NSString stringWithFormat:@"Jump Force: %.2f", _heroCtrl.jumpForce]];
        } break;
            
        case 2:
        {
            _heroCtrl.runSpeed += value * 10.0f;
            [self.debugLabel setText:[NSString stringWithFormat:@"Run Speed: %d", (int)_heroCtrl.runSpeed]];
        } break;
            
        default: break;
    }
}

@end
