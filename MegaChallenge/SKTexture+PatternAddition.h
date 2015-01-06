//
//  SKSpriteNode+PatternAddition.h
//  BadPuppies
//
//  Created by Jussi Kallio on 14.11.2013.
//  Copyright (c) 2013 Jussi Kallio. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKTexture (PatternAddition)

+ (SKTexture*)textureWithPatternImage:(UIImage*)image size:(CGSize)size;

@end
