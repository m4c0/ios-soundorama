//
//  SDRSource.m
//  Soundorama
//
//  Created by Eduardo Mauricio da Costa on 26/11/14.
//  Copyright (c) 2014 Eduardo Mauricio da Costa. All rights reserved.
//

#import "SDRSource.h"

#import "SDRContext.h"

@implementation SDRSource {
    ALuint sid;
    ALuint lastPlayedBid;
}

- (void)checkError {
    ALenum error = alGetError();
    if (error != AL_NO_ERROR) {
        NSLog(@"AL Error: %x", error);
        abort();
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [SDRContext configure];
        
        alGenSources(1, &sid);
        [self checkError];
    }
    return self;
}

- (void)dealloc {
    alDeleteSources(1, &sid);
    [self checkError];
}

- (BOOL)playing {
    ALint state;
    alGetSourcei(sid, AL_SOURCE_STATE, &state);
    [self checkError];
    return state == AL_PLAYING;
}

- (float)offset {
    ALfloat offset;
    alGetSourcef(sid, AL_SEC_OFFSET, &offset);
    [self checkError];
    return offset;
}

- (void)playBuffer:(ALint)bid at:(CGPoint)p {
    if (bid != lastPlayedBid) {
        alSourcei(sid, AL_BUFFER, bid);
        [self checkError];
        lastPlayedBid = bid;
    }
    alSource3f(sid, AL_POSITION, p.x, p.y, 0);
    [self checkError];
    alSourcePlay(sid);
    [self checkError];
}

#pragma mark - Properties

- (BOOL)relative {
    abort();
}
- (void)setRelative:(BOOL)relative {
    alSourcei(sid, AL_SOURCE_RELATIVE, AL_TRUE);
    [self checkError];
}

- (float)pitch {
    abort();
}
- (void)setPitch:(float)pitch {
    alSourcef(sid, AL_PITCH, pitch);
    [self checkError];
}

- (float)gain {
    abort();
}
- (void)setGain:(float)gain {
    alSourcef(sid, AL_GAIN, gain);
    [self checkError];
}

@end
