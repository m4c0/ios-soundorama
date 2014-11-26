//
//  SDRBuffer.h
//  Soundorama
//
//  Created by Eduardo Mauricio da Costa on 26/11/14.
//  Copyright (c) 2014 Eduardo Mauricio da Costa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class SDRSource;

@interface SDRBuffer : NSObject
- (instancetype)initWithFilename:(NSString *)name;
- (void)playUsingSource:(SDRSource *)src at:(CGPoint)p;
@end
