//
//  tmnAppDelegate.m
//  Shortcuts
//
//  Created by Fabian Morón Zirfas on 29.05.13.
//  Copyright (c) 2013 the-moron.net. All rights reserved.
//

#import "tmnAppDelegate.h"
#import "DDFileReader.h"
#import "GlobalValues.h"
@implementation tmnAppDelegate

//@synthesize statusBar = _statusBar;


- (void) awakeFromNib {

//   [[self.statusBar menu] setDelegate:self];
    
    // this manages the FS
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSURL* appSupportDir = nil;

// ----------------------------------------------------------------------------- START OF LOOKIN INTO FOLDER
    /***
     * Looks for a file in the support folder
     * 
     * taken from here
     * http://stackoverflow.com/questions/7029316/copy-a-file-from-the-app-bundle-to-the-users-application-support-folder
     */
    
    NSBundle *thisBundle = [NSBundle mainBundle]; // the bundle
    NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]; // the .app name
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES); // Dont know
    NSString *userpath = [paths objectAtIndex:0];
    NSLog(@"userpath %@",userpath); // just to know where we are
    userpath = [userpath stringByAppendingPathComponent:executableName];    // The file will go in this directory
    NSString *shortcutsFilePath = [userpath stringByAppendingPathComponent:@"shortcuts.txt"];// the full filepath
    /**
     * Now lets check if the Application Suppot Folder already exists
     */
    if ([fileManager fileExistsAtPath:userpath] == NO){
        NSLog(@"I'm in the user path does not exist");
        [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    /**
     * Now lets check if the file in the Application Suppot Folder already exists
     */
    if ([fileManager fileExistsAtPath:shortcutsFilePath] == NO){
        NSLog(@"I'm in the user path does not exist");
        [fileManager copyItemAtPath:[thisBundle pathForResource:@"shortcuts" ofType:@"txt"] toPath:shortcutsFilePath error:NULL];
    }
    
    [GlobalValues sharedManager].FULLFILEPATH = shortcutsFilePath; // add it to our globals for later reuse
//    values.FULLFILEPATH = shortcutsFilePath;
// ----------------------------------------------------------------------------- END OF LOOKIN INTO FOLDER
    /***
     * This also looks into the users application support folder
     * Taken from:
     * https://developer.apple.com/library/mac/#documentation/General/Conceptual/MOSXAppProgrammingGuide/AppRuntime/AppRuntime.html
     */
//    NSArray *urls = [fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask];
//    if ([urls count] > 0) {
//        for (int u = 0; u < [urls count]; u++) {
//            NSLog(@"read url: %@", [urls objectAtIndex: u]);
//
//        }
//        
//        appSupportDir = [[urls objectAtIndex:0] URLByAppendingPathComponent:@"info.fabiantheblind.shortcuts"];
//        NSLog(@"support dir: %@",appSupportDir);
//    }
    
    
//    /***
//     * This is taken from the 
//     * https://github.com/fabiantheblind/StatusBarApp
//     */
//    
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];// add the statusbar
    self.statusBar.title = @"SC";// give it a title
    
//  [[self.statusBar menu] setDelegate:self];
    // you can also set an image
    //self.statusBar.image =
    
    self.statusBar.menu = self.ShortcutsMenu; // self refer? hm don't know why
    self.statusBar.highlightMode = YES;

    NSMutableArray *list; // the list of things in the menu
    list = [NSMutableArray arrayWithObjects:  nil];// init
    /**
     * Read in the lines
     */
    DDFileReader * reader = [[DDFileReader alloc] initWithFilePath:shortcutsFilePath];
    NSString * line = nil;
    while ((line = [reader readLine])) {
//        NSLog(@"read line: %@", line);
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

#pragma NSMenu delegate methods

- (void)menuNeedsUpdate:(NSMenu *)menu {
    NSLog(@"menuNeedsUpdate was called");
    //    menu
    if (menu == self.statusBar.menu) {
        NSLog(@"in update");
    }
        //
//
//    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
//    
//    self.statusBar.title = @"SC";
//    
//    // you can also set an image
//    //self.statusBar.image =
//    
//    self.statusBar.menu = self.ShortcutsMenu;
//    self.statusBar.highlightMode = YES;
//    
//    NSMutableArray *list;
//    list = [NSMutableArray arrayWithObjects:  nil];
//    
//    //    NSString * path = @"/Users/fabiantheblind/Desktop/test/shortcuts.txt";
//    DDFileReader * reader = [[DDFileReader alloc] initWithFilePath: [GlobalValues sharedManager].FULLFILEPATH];
//    NSString * line = nil;
//    
//    
//    while ((line = [reader readLine])) {
//        NSLog(@"read line: %@", line);
//        [list addObject:line];
//    }
//    
//    for (int i = 0; i < [list count]; i++){
//        NSMenuItem *newItem = [[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:[list objectAtIndex: i]
//                                                                                   action:@selector(aboutDockAction:)
//                               
//                                                                            keyEquivalent:@""];
//        
//        [newItem setTarget: self];
//        [newItem setEnabled:YES];
//        [menu addItem:newItem];
//    }
//    }
NSLog(@"end menuNeedsUpdate");
}
- (void)updateTheMenu {

    
//    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
//    self.statusBar.menu = self.ShortcutsMenu;
//    NSMenuItem *first = [_ShortcutsMenu itemAtIndex:1];
//    NSAttributedString * string1 = [[NSAttributedString alloc] initWithString:@"hello"];
//    NSAttributedString * string2 = [[NSAttributedString alloc] initWithString:@"world"];
//    
//    static BOOL flip = NO;
////    NSMenu *filemenu = [[[NSApp mainMenu] itemAtIndex:1] submenu];
//    if (flip) {
//        [first setAttributedTitle:string1];
//    } else {
//        [first setAttributedTitle:string2];
//    }
//    flip = !flip;
}

- (void)menuWillOpen:(NSMenu *)menu{

    if(menu == self.statusBar.menu){
        NSLog(@"in menu will open");
}

}



- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
    
    // Insert code here to initialize your application
//    NSTimer *timer = [NSTimer timerWithTimeInterval:0.5
//                                             target:self
//                                           selector:@selector(menuNeedsUpdate)
//                                           userInfo:nil
//                                            repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}



@end
