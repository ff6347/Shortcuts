//
//  AppController.m
//  Shortcuts
//
//  Created by Fabian Morón Zirfas on 05.07.13.
//  Copyright (c) 2013 the-moron.net. All rights reserved.
// 

#import "AppController.h"
#import "GlobalValues.h"
@implementation AppController

-(id)init{
    self = [super init];
    if(self){
        // init code here
    }
    
    return self;
}

- (IBAction)openList:(id)sender{
    
//    GlobalValues *values = [GlobalValues sharedManager];
    
    // this will be the action
    NSLog(@"clicked button %@", [GlobalValues sharedManager].FULLFILEPATH);
    NSURL    * fileURL = [NSURL fileURLWithPath:  [GlobalValues sharedManager].FULLFILEPATH];
    
    NSWorkspace * ws = [NSWorkspace sharedWorkspace];
    [ws openURL: fileURL];
//    NSArray *fileURLs = [NSArray arrayWithObjects: [GlobalValues sharedManager].FULLFILEPATH, /* ... */ nil];
//    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:fileURLs];
}


- (void)dealloc{
//    [super dealloc];
}
@end
