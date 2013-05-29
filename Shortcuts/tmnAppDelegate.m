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
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSURL* appSupportDir = nil;
    
    /***
     * Looks for a file in the support folder
     * 
     * taken from here
     * http://stackoverflow.com/questions/7029316/copy-a-file-from-the-app-bundle-to-the-users-application-support-folder
     */
    
    NSBundle *thisBundle = [NSBundle mainBundle];

    
    NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *userpath = [paths objectAtIndex:0];
    NSLog(@"userpath %@",userpath);
    userpath = [userpath stringByAppendingPathComponent:executableName];    // The file will go in this directory
    NSString *shortcutsFilePath = [userpath stringByAppendingPathComponent:@"shortcuts.txt"];
//    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:userpath] == NO){
        NSLog(@"I'm in the user path does not exist");
        [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if ([fileManager fileExistsAtPath:shortcutsFilePath] == NO){
        NSLog(@"I'm in the user path does not exist");
        [fileManager copyItemAtPath:[thisBundle pathForResource:@"shortcuts" ofType:@"txt"] toPath:shortcutsFilePath error:NULL];
    }
    
    
    /***
     * This looks into the users application supprt folder
     * Taken from:
     * https://developer.apple.com/library/mac/#documentation/General/Conceptual/MOSXAppProgrammingGuide/AppRuntime/AppRuntime.html
     */
    NSArray *urls = [fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask];
    if ([urls count] > 0) {
        for (int u = 0; u < [urls count]; u++) {
            NSLog(@"read url: %@", [urls objectAtIndex: u]);

        }
        
        appSupportDir = [[urls objectAtIndex:0] URLByAppendingPathComponent:@"com.example.MyApp"];
        NSLog(@"support dir: %@",appSupportDir);
    }
    
    
    /***
     * This is taken from the 
     * https://github.com/fabiantheblind/StatusBarApp
     */
    
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    self.statusBar.title = @"G";
    
    // you can also set an image
    //self.statusBar.image =
    
    self.statusBar.menu = self.ShortcutsMenu;
    self.statusBar.highlightMode = YES;
    
    NSMutableArray *list;
    list = [NSMutableArray arrayWithObjects: @"Red", @"Green", @"Blue", @"Yellow", nil];
    
    NSString * path = @"/Users/fabiantheblind/Desktop/test/shortcuts.txt";
    DDFileReader * reader = [[DDFileReader alloc] initWithFilePath:shortcutsFilePath];
    NSString * line = nil;


    while ((line = [reader readLine])) {
        NSLog(@"read line: %@", line);
        [list addObject:line];
    }
    
    for (int i = 0; i < [list count]; i++){
        NSMenuItem *newItem = [[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:[list objectAtIndex: i]
                                                                                   action:@selector(aboutDockAction:)
                               
                                                                            keyEquivalent:@""];
        
        [newItem setTarget: self];
        [newItem setEnabled:YES];
        [_ShortcutsMenu addItem:newItem];
    }

    
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
    // Insert code here to initialize your application
}

@end
