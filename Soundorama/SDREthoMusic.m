//
//  SDRMidiMusic.m
//  Soundorama
//
//  Created by Eduardo Mauricio da Costa on 26/11/14.
//  Copyright (c) 2014 Eduardo Mauricio da Costa. All rights reserved.
//

#import "SDREthoMusic.h"

#import <MoCategories/MoCategories.h>

#import "SDRBuffer.h"
#import "SDRSource.h"

@implementation SDREthoMusic {
    NSArray * buffers;
    SDRSource * srcs[10];
}

- (void)loadPresets:(NSArray *)names {
    buffers = [names mapUsingBlock:^id(id a) {
        return [[SDRBuffer alloc] initWithFilename:a];
    }];
    
    for (int i = 0; i < 10; i++) {
        srcs[i] = [SDRSource new];
        srcs[i].relative = YES;
    }
}

- (void)playNote:(SDREthoMusicInstrument *)mmi {
    int pentatonicScale[] = {
        0, 2, 4, 7, 9, 12, 14, 16, 19, 21
    };
    for (int i = 0; i < 10; i++) {
        if (arc4random_uniform(9) != 0) continue;
        
        int n = 12 * mmi->baseScale + pentatonicScale[i] + mmi->pitch;
        
        // https://github.com/hollance/SoundBankPlayer
        float pitch = pow(2, (n - 69) / 12.0);  // A4 = MIDI key 69
        
        srcs[i].gain = mmi->volume * 0.75;
        srcs[i].pitch = pitch;
        [buffers[mmi->presetID] playUsingSource:srcs[i] at:CGPointZero];
    }
}

@end
