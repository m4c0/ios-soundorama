//
//  SDRContext.m
//  Soundorama
//
//  Created by Eduardo Mauricio da Costa on 26/11/14.
//  Copyright (c) 2014 Eduardo Mauricio da Costa. All rights reserved.
//

#import "SDRContext.h"

@import AVFoundation;
@import OpenAL.alc;

@implementation SDRContext

+ (void)configure {
    static ALCdevice * device;
    static ALCcontext * context;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AVAudioSession * ass = [AVAudioSession sharedInstance];
        [ass setCategory:AVAudioSessionCategoryAmbient error:nil];
        [ass setActive:YES error:nil];
        
        device = alcOpenDevice(0);
        if (!device) abort();
        
        context = alcCreateContext(device, 0);
        if (!context) abort();
        
        if (!alcMakeContextCurrent(context)) abort();
    });
}

@end
