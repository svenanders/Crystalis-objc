//
//  ParticleFunctions.m
//  Bombtris
//
//  Created by Sven Anders Robbestad on 19.04.12.
//  Copyright (c) 2012 SOL. All rights reserved.
//



#import "ParticleFunctions.h"
#import "cocos2d.h"

@implementation ParticleFunctions

+(void) createExplosionX: (float) x y: (float) y inParent: (CCNode*) parentNode
{
	CCParticleSystem *emitter;
	emitter = [[CCParticleFireworks alloc] init];
	emitter.texture = [[CCTextureCache sharedTextureCache] addImage:@"dot.png"];
    emitter.position = ccp(x+32,y);
	emitter.duration = 0.3;
    emitter.totalParticles=1;
 	emitter.autoRemoveOnFinish = YES; // this removes/deallocs the emitter after its animation
	[parentNode addChild:emitter z:500];
}

@end