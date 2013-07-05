//
//  GlobalValues.m
//  Shortcuts
//
//  Created by Fabian Morón Zirfas on 05.07.13.
//  Copyright (c) 2013 the-moron.net. All rights reserved.
//  taken from here http://www.galloway.me.uk/tutorials/singleton-classes/

#import "GlobalValues.h"

@implementation GlobalValues

@synthesize LIBPATH;
@synthesize FILENAME;
@synthesize FULLFILEPATH;
@synthesize FILEEXT;

#pragma mark Singleton Methods

+ (instancetype)sharedManager {
    static GlobalValues *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[GlobalValues alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        LIBPATH = @"";
        FILENAME = @"shortcuts";
        FILEEXT = @"txt";
        FULLFILEPATH = @"";
    }
    return self;
}

//- (void)dealloc {
//    // Should never be called, but just here for clarity really.
//}

@end
