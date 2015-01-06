//
//  SKSpriteNode+PatternAddition.m
//  BadPuppies
//
//  Created by Jussi Kallio on 14.11.2013.
//  Copyright (c) 2013 Jussi Kallio. All rights reserved.
//

#import "SKTexture+PatternAddition.h"

@implementation SKTexture (PatternAddition)

+ (SKTexture*)textureWithPatternImage:(UIImage*)image size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawTiledImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
    UIImage *tiledBackground = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [SKTexture textureWithCGImage:tiledBackground.CGImage];
}

@end
