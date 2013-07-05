//
//  tmnAppDelegate.h
//  Shortcuts
//
//  Created by Fabian Morón Zirfas on 29.05.13.
//  Copyright (c) 2013 the-moron.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface tmnAppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSWindow *window;

@property  (weak) IBOutlet NSMenu *ShortcutsMenu;

@property (nonatomic) NSStatusItem *statusBar;

- (void)menuNeedsUpdate:(NSMenu*)menu;

- (void)menuWillOpen:(NSMenu *)menu;
@end
