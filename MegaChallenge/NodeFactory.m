//
//  NodeFactory.m
//  MegaChallenge
//
//  Created by Jussi Kallio on 4.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import "Defines.h"
#import "PluginControllerHero.h"
#import "PluginAnimationHero.h"
#import "PluginContactHandlerHero.h"
#import "NodeFactory.h"

@implementation NodeFactory

+ (NSArray*) createLevelMap:(NSArray *)levelMap
{
    NSMutableArray* objects = [NSMutableArray new];
    CGFloat posY = 5 * kBlockHeight;
    NSInteger offsetX = 0;
    for (NSNumber* objType in levelMap)
    {
        NSInteger objTypeNum = [objType integerValue];
        if (objTypeNum >= 0)
        {
            JKGameNode* obj = [NodeFactory createObjectWithType:objTypeNum Position:CGPointMake((-5 * kBlockWidth) + (offsetX * kBlockWidth), posY)];
            if (obj != nil)
            {
                [objects addObject:obj];
            }
            ++offsetX;
        }
        else
        {
            posY -= kBlockHeight;
            offsetX = 0;
        }
    }
    return objects;
}

+ (JKGameNode*) createObjectWithType:(NSInteger)type Position:(CGPoint)position
{
    JKGameNode* obj = nil;
    switch (type)
    {
        case OBJ_TYPE_NONE: break;
            
        case OBJ_TYPE_HERO: obj = [NodeFactory createHeroWithPosition:position]; break;
            
        case OBJ_TYPE_QUICKMAN_BLOCK:   // no break
        case OBJ_TYPE_HEATMAN_BLOCK:    // no break
        case OBJ_TYPE_BUBBLEMAN_BLOCK:  // no break
        case OBJ_TYPE_AIRMAN_BLOCK:     obj = [NodeFactory createBlock:type Position:position]; break;
            
        case OBJ_TYPE_TELEPORT_QUICKMAN:    // no break
        case OBJ_TYPE_TELEPORT_HEATMAN:     // no break
        case OBJ_TYPE_TELEPORT_BUBBLEMAN:   // no break
        case OBJ_TYPE_TELEPORT_AIRMAN:      // no break
        case OBJ_TYPE_TELEPORT_STAGESEL:    obj = [NodeFactory createTeleport:type Position:position]; break;
            
        default: JKAssert(NO, @"TODO: Invalid type"); break;
    }
    return obj;
}

+ (JKGameNode*) createHeroWithPosition:(CGPoint)position
{
    JKGameNode* hero = [JKGameNode node];
    hero.objType = OBJ_TYPE_HERO;
    hero.name = NODE_NAME_HERO;
    hero.position = position;
    hero.zPosition = Z_POS_HERO;
    
    [hero setSpriteTexture:[__sharedTextureCache getTextureNamed:@"gigaman_stand0"]];
    hero.spriteNode.anchorPoint = CGPointMake(0.5f, 0.4f);
    
    hero.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:hero.spriteNode.size.height/3];
    hero.physicsBody.allowsRotation = NO;
    hero.physicsBody.mass = 10.0f;
    hero.physicsBody.friction = 0.7f;
    hero.physicsBody.linearDamping = 0.0f;
    hero.physicsBody.restitution = 0.0f;
    hero.physicsBody.categoryBitMask = kCatHero;
    hero.physicsBody.collisionBitMask = kCollisionMaskHero;
    hero.physicsBody.contactTestBitMask = kContactMaskHero;
    
    PluginAnimationHero* anim = [PluginAnimationHero createAndAttachToNode:hero.spriteNode];
    [anim.actions setObject:[PluginAnimationHero createAnimationWithFrames:[__sharedTextureCache getTexturesWithNameBase:@"gigaman_stand" Count:1] Freq:1.0f Revert:NO] forKey:HERO_ANIM_KEY_STOP];
    [anim.actions setObject:[PluginAnimationHero createAnimationWithFrames:[__sharedTextureCache getTexturesWithNameBase:@"gigaman_run" Count:8] Freq:0.08f Revert:NO] forKey:HERO_ANIM_KEY_MOVE];
    [anim.actions setObject:[PluginAnimationHero createAnimationWithFrames:[__sharedTextureCache getTexturesWithNameBase:@"gigaman_jump" Count:1] Freq:1.0f Revert:NO] forKey:HERO_ANIM_KEY_JUMP];
    [anim.actions setObject:[PluginAnimationHero createAnimationWithFrames:[__sharedTextureCache getTexturesWithNameBase:@"gigaman_teleport" Count:1] Freq:1.0f Revert:NO] forKey:HERO_ANIM_KEY_TELEPORT];
    anim.idleAnimID = HERO_ANIM_KEY_STOP;
    
    [PluginControllerHero createAndAttachToNode:hero];
    [PluginContactHandlerHero createAndAttachToNode:hero];
    
    JKSpriteNode* jumpSensor = [JKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(hero.spriteNode.size.width/2.5, hero.spriteNode.size.height/4)];
    jumpSensor.position = CGPointMake(0.0f, -hero.spriteNode.size.height/2 + jumpSensor.size.height/2);
    [PluginContactHandlerHero createAndAttachToNode:jumpSensor];
    [hero setSensor:jumpSensor Name:SENSOR_NAME_JUMP];
    
    JKSpriteNode* leftSensor = [JKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(hero.spriteNode.size.width/10, hero.spriteNode.size.height/2.5)];
    leftSensor.position = CGPointMake(-hero.spriteNode.size.width/2 + leftSensor.size.width, 0.0f);
    [hero setSensor:leftSensor Name:SENSOR_NAME_LEFT];
    
    JKSpriteNode* rightSensor = [JKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(hero.spriteNode.size.width/10, hero.spriteNode.size.height/2.5)];
    rightSensor.position = CGPointMake(hero.spriteNode.size.width/2 - rightSensor.size.width, 0.0f);
    [hero setSensor:rightSensor Name:SENSOR_NAME_RIGHT];

    return hero;
}

+ (JKGameNode*) createBlock:(NSInteger)type Position:(CGPoint)position
{
    JKGameNode* block = [JKGameNode node];
    block.objType = type;
    block.name = NODE_NAME_BLOCK;
    block.position = position;
    block.zPosition = Z_POS_STATIC;
    
    switch (type)
    {
        case OBJ_TYPE_QUICKMAN_BLOCK:   [block setSpriteTexture:[__sharedTextureCache getTextureNamed:@"block_1"]]; break;
        case OBJ_TYPE_HEATMAN_BLOCK:    [block setSpriteTexture:[__sharedTextureCache getTextureNamed:@"block_2"]]; break;
        case OBJ_TYPE_BUBBLEMAN_BLOCK:  [block setSpriteTexture:[__sharedTextureCache getTextureNamed:@"block_3"]]; break;
        case OBJ_TYPE_AIRMAN_BLOCK:     [block setSpriteTexture:[__sharedTextureCache getTextureNamed:@"block_4"]]; break;
        default: JKAssert(NO, @"TODO: invalid block type");
    }
    
    block.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:block.spriteNode.size];
    block.physicsBody.dynamic = NO;
    block.physicsBody.friction = 0.7f;
    block.physicsBody.restitution = 0.1f;
    block.physicsBody.categoryBitMask = kCatStaticObj;
    block.physicsBody.collisionBitMask = kCollisionMaskStaticObj;
    block.physicsBody.contactTestBitMask = kContactMaskStaticObj;
    
    return block;
}

+ (JKGameNode*) createTeleport:(NSInteger)type Position:(CGPoint)position
{
    JKGameNode* teleport = [JKGameNode node];
    teleport.objType = type;
    teleport.position = CGPointMake(position.x, position.y - PIXELS(4));
    teleport.zPosition = Z_POS_STATIC;
    teleport.name = NODE_NAME_TELEPORT;
    
    [teleport setSpriteTexture:[__sharedTextureCache getTextureNamed:@"teleport"]];
    
    teleport.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:teleport.spriteNode.size];
    teleport.physicsBody.dynamic = NO;
    teleport.physicsBody.friction = 0.7f;
    teleport.physicsBody.restitution = 0.1f;
    teleport.physicsBody.categoryBitMask = kCatStaticObj;
    teleport.physicsBody.collisionBitMask = kCollisionMaskStaticObj;
    teleport.physicsBody.contactTestBitMask = kContactMaskStaticObj;
    
    
    JKSpriteNode* sensor = [JKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(teleport.spriteNode.size.width/10, teleport.spriteNode.size.height/3)];
    sensor.position = CGPointMake(0, teleport.spriteNode.size.height/2);
    [teleport setSensor:sensor Name:SENSOR_NAME_TELEPORT];
    
    return teleport;
}

@end
