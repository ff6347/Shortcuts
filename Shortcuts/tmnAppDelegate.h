//
//  tmnAppDelegate.h
//  Shortcuts
//
//  Created by Fabian Morón Zirfas on 29.05.13.
//  Copyright (c) 2013 the-moron.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface tmnAppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate>{
    IBOutlet NSMenu *menu;
    IBOutlet NSArrayController *arrayController;

    NSStatusItem *statusItem;
    NSString *shortcutsConfigFile;

    // This is for the TXT File
    NSDate *txtModified;
    NSDate *txtConfigUser;
    NSDate *txtConfigSystem;
    
    
}

//@property (nonatomic, strong) IBOutlet NSWindow *window;
//
//@property  (nonatomic, strong) IBOutlet NSMenu *ShortcutsMenu;
//
//@property (nonatomic, strong) NSStatusItem *statusBar;

//- (void)menuNeedsUpdate:(NSMenu*)menu;

- (void)menuWillOpen:(NSMenu *)menu;
@end
