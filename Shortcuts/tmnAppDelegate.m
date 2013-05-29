//
//  tmnAppDelegate.m
//  Shortcuts
//
//  Created by Fabian Morón Zirfas on 29.05.13.
//  Copyright (c) 2013 the-moron.net. All rights reserved.
//

#import "tmnAppDelegate.h"
#import "DDFileReader.h"

@implementation tmnAppDelegate
@synthesize statusBar = _statusBar;
- (void) awakeFromNib {
    
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    self.statusBar.title = @"G";
    
    // you can also set an image
    //self.statusBar.image =
    
    self.statusBar.menu = self.ShortcutsMenu;
    self.statusBar.highlightMode = YES;
    
    NSMutableArray *list;
    list = [NSMutableArray arrayWithObjects: @"Red", @"Green", @"Blue", @"Yellow", nil];
    
    NSString * path = @"/Users/fabiantheblind/Desktop/test/shortcuts.txt";
    DDFileReader * reader = [[DDFileReader alloc] initWithFilePath:path];
    NSString * line = nil;


    while ((line = [reader readLine])) {
        NSLog(@"read line: %@", line);
        [list addObject:line];
    }
//    [reader release];
    
    
    for (int i = 0; i < [list count]; i++){
        NSMenuItem *newItem = [[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:[list objectAtIndex: i]
                                                                                   action:@selector(aboutDockAction:)
                               
                                                                            keyEquivalent:@""];
        
        [newItem setTarget: self];
        [newItem setEnabled:YES];
        [_ShortcutsMenu addItem:newItem];
    }


//	[newItem release];
    
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
    // Insert code here to initialize your application
}

@end
