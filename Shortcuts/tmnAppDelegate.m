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
    if ([fileManager fileExistsAtPath:userpath] == NO){
        NSLog(@"I'm in the user path does not exist");
        [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if ([fileManager fileExistsAtPath:shortcutsFilePath] == NO){
        NSLog(@"I'm in the user path does not exist");
        [fileManager copyItemAtPath:[thisBundle pathForResource:@"shortcuts" ofType:@"txt"] toPath:shortcutsFilePath error:NULL];
    }
    
    [GlobalValues sharedManager].FULLFILEPATH = shortcutsFilePath;
//    values.FULLFILEPATH = shortcutsFilePath;
    
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
    
    
//    /***
//     * This is taken from the 
//     * https://github.com/fabiantheblind/StatusBarApp
//     */
//    
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    self.statusBar.title = @"SC";
//    [[self.statusBar menu] setDelegate:self];
    
    // you can also set an image
    //self.statusBar.image =
    
    self.statusBar.menu = self.ShortcutsMenu;
    self.statusBar.highlightMode = YES;

    NSMutableArray *list;
    list = [NSMutableArray arrayWithObjects:  nil];
    
//    NSString * path = @"/Users/fabiantheblind/Desktop/test/shortcuts.txt";
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
