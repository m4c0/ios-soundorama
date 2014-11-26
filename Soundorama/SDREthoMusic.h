//
//  SDRMidiMusic.h
//  Soundorama
//
//  Created by Eduardo Mauricio da Costa on 26/11/14.
//  Copyright (c) 2014 Eduardo Mauricio da Costa. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct SDREthoMusicInstrument {
    UInt8 presetID;
    int baseScale;
    int pitch;
    float volume;
} SDREthoMusicInstrument;

@interface SDREthoMusic : NSObject

- (void)loadPresets:(NSArray *)names;
- (void)playNote:(SDREthoMusicInstrument *)mmi;

@end
