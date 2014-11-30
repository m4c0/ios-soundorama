//
//  SDROptions.m
//  Soundorama
//
//  Created by Eduardo Mauricio da Costa on 30/11/14.
//  Copyright (c) 2014 Eduardo Mauricio da Costa. All rights reserved.
//

#import "SDROptions.h"

@implementation SDROptions

+ (instancetype)sharedInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self allocWithZone:nil] init];
    });
    return instance;
}
+ (id)alloc {
    return [self sharedInstance];
}

- (BOOL)musicDisabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"soundorama.musicDisable"];
}

- (void)setMusicDisabled:(BOOL)musicDisabled {
    [[NSUserDefaults standardUserDefaults] setBool:musicDisabled forKey:@"soundorama.musicDisable"];
}

- (BOOL)soundDisabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"soundorama.soundDisable"];
}

- (void)setSoundDisabled:(BOOL)soundDisabled {
    [[NSUserDefaults standardUserDefaults] setBool:soundDisabled forKey:@"soundorama.soundDisable"];
}

@end
