//
//  SDRBuffer.m
//  Soundorama
//
//  Created by Eduardo Mauricio da Costa on 26/11/14.
//  Copyright (c) 2014 Eduardo Mauricio da Costa. All rights reserved.
//

#import "SDRBuffer.h"

#import <AudioToolbox/AudioToolbox.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>
#import <OpenAL/oalStaticBufferExtension.h>
#import <UIKit/UIKit.h>

#import "SDRContext.h"
#import "SDRSource.h"

static alBufferDataStaticProcPtr alBufferDataStatic;

@implementation SDRBuffer {
    ALenum bufferFormat;
    ALenum bufferSize;
    ALenum bufferFrequency;
    void * bufferData;
    
    ALuint bid;
    
    NSString * filename;
}

+ (void)load {
    alBufferDataStatic = alcGetProcAddress(NULL, "alBufferDataStatic");
}

- (void)checkError {
    ALenum error = alGetError();
    if (error != AL_NO_ERROR) {
        NSLog(@"AL Error: %x", error);
        abort();
    }
}

- (instancetype)initWithFilename:(NSString *)name {
    self = [super init];
    if (self) {
        filename = name;
        [self prepare];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dispose)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [self dispose];
}

- (void)prepare {
    if (bufferData) return;
    
    [SDRContext configure];
    
    alGenBuffers(1, &bid);
    [self checkError];
    
    [self loadFile];
    alBufferDataStatic(bid, bufferFormat, bufferData, bufferSize, bufferFrequency);
    [self checkError];
}
- (void)dispose {
    alDeleteBuffers(1, &bid);
    [self checkError];
    if (bufferData) free(bufferData);
    bufferData = nil;
}

- (void)playUsingSource:(SDRSource *)src at:(CGPoint)p {
    [self prepare];
    [src playBuffer:bid at:p];
}

#pragma mark - File handling

- (void)loadFile {
    NSURL * url = [[NSBundle bundleForClass:[self class]] URLForResource:filename withExtension:@"caf"];
    
    ExtAudioFileRef file;
    OSStatus err = ExtAudioFileOpenURL((__bridge CFURLRef)(url), &file);
    if (err) abort();
    
    AudioStreamBasicDescription fileFormat;
    UInt32 size = sizeof(fileFormat);
    err = ExtAudioFileGetProperty(file, kExtAudioFileProperty_FileDataFormat, &size, &fileFormat);
    if (err) abort();
    
    NSAssert(fileFormat.mChannelsPerFrame <= 2, @"Too many channels");
    
    AudioStreamBasicDescription outFormat;
    outFormat.mSampleRate = fileFormat.mSampleRate;
    outFormat.mChannelsPerFrame = fileFormat.mChannelsPerFrame;
    
    outFormat.mFormatID = kAudioFormatLinearPCM;
    outFormat.mBytesPerPacket = 2 * outFormat.mChannelsPerFrame;
    outFormat.mFramesPerPacket = 1;
    outFormat.mBytesPerFrame = 2 * outFormat.mChannelsPerFrame;
    outFormat.mBitsPerChannel = 16;
    outFormat.mFormatFlags = kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger;
    err = ExtAudioFileSetProperty(file, kExtAudioFileProperty_ClientDataFormat, sizeof(outFormat), &outFormat);
    if (err) abort();
    
    SInt64 frameCount;
    size = sizeof(frameCount);
    err = ExtAudioFileGetProperty(file, kExtAudioFileProperty_FileLengthFrames, &size, &frameCount);
    if (err) abort();
    
    UInt32 frameCount32 = (int)frameCount;
    bufferSize = frameCount32 * outFormat.mBytesPerFrame;
    bufferData = calloc(1, bufferSize);
    if (!bufferData) abort();
    
    AudioBufferList list;
    list.mNumberBuffers = 1;
    list.mBuffers[0].mNumberChannels = outFormat.mChannelsPerFrame;
    list.mBuffers[0].mDataByteSize = bufferSize;
    list.mBuffers[0].mData = bufferData;
    err = ExtAudioFileRead(file, &frameCount32, &list);
    if (err) abort();
    
    bufferFormat = outFormat.mChannelsPerFrame == 2 ? AL_FORMAT_STEREO16 : AL_FORMAT_MONO16;
    bufferFrequency = outFormat.mSampleRate;
}

@end
