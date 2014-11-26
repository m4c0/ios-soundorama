//
//  SDRSound.h
//  Soundorama
//
//  Created by Eduardo Mauricio da Costa on 26/11/14.
//  Copyright (c) 2014 Eduardo Mauricio da Costa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface SDRSound : NSObject

+ (void)setReferencePosition:(CGPoint)p;
+ (instancetype)soundForName:(NSString *)str;

- (void)playAt:(CGPoint)p;

@end
