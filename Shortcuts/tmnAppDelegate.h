//
//  tmnAppDelegate.h
//  Shortcuts
//
//  Created by Fabian Morón Zirfas on 29.05.13.
//  Copyright (c) 2013 the-moron.net. All rights reserved.
//
// the menue rebuild is taken from here
// thanks a lot
// https://github.com/fitztrev/shuttle
//
#import <Cocoa/Cocoa.h>

@interface tmnAppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate>{
    IBOutlet NSMenu *menu;
    IBOutlet NSArrayController *arrayController;

    NSStatusItem *statusItem;
    NSString *shortcutsConfigFile;

    // This is for the TXT File
    NSDate *txtModified;

}

- (void)menuWillOpen:(NSMenu *)menu;
@end
