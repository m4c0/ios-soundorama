//
//  SDROptions.h
//  Soundorama
//
//  Created by Eduardo Mauricio da Costa on 30/11/14.
//  Copyright (c) 2014 Eduardo Mauricio da Costa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDROptions : NSObject
@property (nonatomic) BOOL musicDisabled;
@property (nonatomic) BOOL soundDisabled;

+ (instancetype)sharedInstance;
@end
