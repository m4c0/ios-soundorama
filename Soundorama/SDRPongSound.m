//
//  SDRPongSound.m
//  Soundorama
//
//  Created by Eduardo Mauricio da Costa on 26/11/14.
//  Copyright (c) 2014 Eduardo Mauricio da Costa. All rights reserved.
//

#import "SDRPongSound.h"

#import <AudioToolbox/AudioToolbox.h>
#import "SDROptions.h"

@interface SDRPongSound ()
- (OSStatus)renderToneInto:(Float32 *)buffer frames:(UInt32)numberFrames;
@end

static OSStatus fSDRPongSoundRenderTone(void *                       refCon,
                                        AudioUnitRenderActionFlags * actionFlags,
                                        const AudioTimeStamp *       timestamp,
                                        UInt32                       busNumber,
                                        UInt32                       numberFrames,
                                        AudioBufferList *            data) {
    SDRPongSound * gs = (__bridge SDRPongSound *)refCon;
    Float32 * buffer = (Float32 *)data->mBuffers[0].mData;
    return [gs renderToneInto:buffer frames:numberFrames];
}

@implementation SDRPongSound {
    AudioComponentInstance toneUnit;
    float frequency;
    float theta;
}

- (id)init {
    if (!(self = [super init])) return nil;
    
    AudioComponentDescription acd;
    acd.componentType = kAudioUnitType_Output;
    acd.componentSubType = kAudioUnitSubType_RemoteIO;
    acd.componentManufacturer = kAudioUnitManufacturer_Apple;
    acd.componentFlags = 0;
    acd.componentFlagsMask = 0;
    
    AudioComponent ac = AudioComponentFindNext(NULL, &acd);
    if (!ac) return nil;
    
    OSErr err = AudioComponentInstanceNew(ac, &toneUnit);
    if (err) return nil;
    
    AURenderCallbackStruct rcs;
    rcs.inputProc = fSDRPongSoundRenderTone;
    rcs.inputProcRefCon = (__bridge void *)self;
    err = AudioUnitSetProperty(toneUnit, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Input, 0, &rcs, sizeof(rcs));
    if (err) return nil;
    
    AudioStreamBasicDescription sbd;
    sbd.mSampleRate = 11025;
    sbd.mFormatID = kAudioFormatLinearPCM;
    sbd.mFormatFlags = kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved;
    sbd.mBytesPerPacket = 4;
    sbd.mFramesPerPacket = 1;
    sbd.mBytesPerFrame = 4 / 1;
    sbd.mChannelsPerFrame = 1;
    sbd.mBitsPerChannel = 4 * 8;
    err = AudioUnitSetProperty (toneUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, &sbd, sizeof(sbd));
    if (err) return nil;
    
    if (AudioUnitInitialize(toneUnit)) return nil;
    
    return self;
}

- (void)dealloc {
    AudioOutputUnitStop(toneUnit);
    AudioUnitUninitialize(toneUnit);
    AudioComponentInstanceDispose(toneUnit);
    toneUnit = nil;
}

- (void)play:(float)freq {
    if ([SDROptions sharedInstance].soundDisabled) return;
    if (frequency != -1) {
        frequency = freq;
        theta = 0;
        AudioOutputUnitStart(toneUnit);
    }
}

- (void)stop {
    AudioOutputUnitStop(toneUnit);
}

- (OSStatus)renderToneInto:(Float32 *)buffer frames:(UInt32)numberFrames {
    float theta_increment = 2.0 * M_PI * frequency / 11025;
    
    for (UInt32 frame = 0; frame < numberFrames; frame++) {
        Float32 amp;
        
        if (theta < 2 * M_PI) {
            amp = 1.0 * theta / (2 * M_PI);
        } else if (theta > 32 * M_PI) {
            amp = 0;
        } else if (theta > 30 * M_PI) {
            amp = 1.0 * (32 * M_PI - theta) / (2 * M_PI);
        } else {
            amp = 1.0;
        }
        
        buffer[frame] = sin(theta) * amp;
        
        theta += theta_increment;
    }
    
    if (theta >= 32 * M_PI) {
        frequency = 0;
        theta = 0;
        [self stop];
    }
    return noErr;
}

@end
