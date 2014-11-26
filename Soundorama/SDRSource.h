//
//  SDRSource.h
//  Soundorama
//
//  Created by Eduardo Mauricio da Costa on 26/11/14.
//  Copyright (c) 2014 Eduardo Mauricio da Costa. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import <OpenAL/al.h>

@interface SDRSource : NSObject
@property (nonatomic, readonly) BOOL playing;
@property (nonatomic, readonly) float offset;

@property (nonatomic) BOOL relative;
@property (nonatomic) float pitch;
@property (nonatomic) float gain;

- (void)playBuffer:(ALint)bid at:(CGPoint)p;

@end
