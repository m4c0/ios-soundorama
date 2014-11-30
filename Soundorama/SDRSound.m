//
//  SDRSound.m
//  Soundorama
//
//  Created by Eduardo Mauricio da Costa on 26/11/14.
//  Copyright (c) 2014 Eduardo Mauricio da Costa. All rights reserved.
//

#import "SDRSound.h"

#import <OpenAL/al.h>

#import "SDRContext.h"
#import "SDRBuffer.h"
#import "SDROptions.h"
#import "SDRSource.h"

#warning Usar apenas um source (ou pool de sources)

@implementation SDRSound {
    NSString * name;
    
    SDRBuffer * buf;
    SDRSource * src;
}

+ (void)setReferencePosition:(CGPoint)p {
    [SDRContext configure];
    alListener3f(AL_POSITION, p.x, p.y, 0);
    
    ALenum error = alGetError();
    if (error != AL_NO_ERROR) {
        NSLog(@"AL Error: %x", error);
        abort();
    }
}

+ (id)instanceForString:(NSString *)str {
    return [self soundForName:str];
}
+ (instancetype)soundForName:(NSString *)str {
    static NSMutableDictionary * cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [NSMutableDictionary new];
    });
    SDRSound * snd = cache[str];
    if (snd) return snd;
    
    snd = [[self alloc] initWithName:str];
    cache[str] = snd;
    
    return snd;
}

- (instancetype)initWithName:(NSString *)str {
    self = [super init];
    if (self) {
        name = str;
        [self prepare];
    }
    return self;
}
- (void)dealloc {
    [self dispose];
}

#pragma mark - Prepare/Dispose

- (void)prepare {
    buf = [[SDRBuffer alloc] initWithFilename:name];
    src = [SDRSource new];
}
- (void)dispose {
    buf = nil;
    src = nil;
}

#pragma mark - Play

- (void)playAt:(CGPoint)p {
    if ([SDROptions sharedInstance].soundDisabled) return;
    if (src.playing && (src.offset < 0.2)) return;
    
    [buf playUsingSource:src at:p];
}

@end
