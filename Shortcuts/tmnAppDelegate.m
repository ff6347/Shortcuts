//
//  tmnAppDelegate.m
//  Shortcuts
//
//  Created by Fabian Morón Zirfas on 29.05.13.
//  Copyright (c) 2013 the-moron.net. All rights reserved.
//
//
// the menue rebuild is taken from here
// thanks a lot
// https://github.com/fitztrev/shuttle
//

#import "tmnAppDelegate.h"
#import "DDFileReader.h"
#import "GlobalValues.h"
@implementation tmnAppDelegate



- (void) awakeFromNib {

//   [[self.statusBar menu] setDelegate:self];
    // this manages the FS
    NSFileManager* fileManager = [NSFileManager defaultManager];
    //    NSURL* appSupportDir = nil;
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
    NSLog(@"Got the file");
    // ----------------------------------------------------------------------------- END OF LOOKIN INTO FOLDER

    
    shortcutsConfigFile = [GlobalValues sharedManager].FULLFILEPATH;

//    /***
//     * This is taken from the 
//     * https://github.com/fabiantheblind/StatusBarApp
//     */
//    

    
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:25.0];
    [statusItem setMenu:menu];
    [statusItem setHighlightMode:YES];
    [statusItem setTitle:@"SC"];

    // This is taken from
    // https://github.com/fitztrev/shuttle

//    NSLog(@"end of awake from nib");
        [menu setDelegate:self];
    
}


/**
 * Fully taken from shuttle.app
 *
 */
- (BOOL) needUpdateFor: (NSString*) file with: (NSDate*) old {
    NSLog(@"Need for update");

    if (![[NSFileManager defaultManager] fileExistsAtPath:[file stringByExpandingTildeInPath]])
        return false;
    
    if (old == NULL)
        return true;
    
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[file stringByExpandingTildeInPath]
                                                                                error:nil];
    NSDate *date = [attributes fileModificationDate];
    return [date compare: old] == NSOrderedDescending;
}

- (NSDate*) getMTimeFor: (NSString*) file {
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[file stringByExpandingTildeInPath]
                                                                                error:nil];
    return [attributes fileModificationDate];
}

- (void)menuWillOpen:(NSMenu *)menu {
    NSLog(@"Menu will open");
    // Check when the config was last modified
    if ( [self needUpdateFor:shortcutsConfigFile with:txtModified] ) {
        txtModified = [self getMTimeFor:shortcutsConfigFile];
        [self loadMenu];
    }
}

- (void) loadMenu {
    
    
    // Clear out the menu so we can start over
    NSUInteger n = [[menu itemArray] count];
    for (int i=0;i<n-4;i++) {
        [menu removeItemAtIndex:0];
    }
    
    NSMutableArray *list; // the list of things in the menu
    list = [NSMutableArray arrayWithObjects:  nil];// init
    /**
     * Read in the lines
     */
    DDFileReader * reader = [[DDFileReader alloc] initWithFilePath:[GlobalValues sharedManager].FULLFILEPATH];
    NSString * line = nil;
    while ((line = [reader readLine])) {
        [list addObject:line];
    }
        
    // Rebuild the menu
    int i = 0;
    
    NSMutableDictionary* fullMenu = [NSMutableDictionary dictionary];
    
    for (int ln = 0; ln < [list count];ln++) {
        
        NSString* line= [list objectAtIndex: ln];

            [fullMenu setObject:[NSString stringWithFormat:@"%d %@",ln, line] forKey:line];
       }
    
    //  add everything
    NSArray* keys = [[fullMenu allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    
    for(id key in keys) {
        id object = [fullMenu valueForKey:key];
        
            NSMenuItem *menuItem = [menu insertItemWithTitle:key
                                                      action:@selector(openHost:)
                                               keyEquivalent:@""
                                                     atIndex:i
                                    ];
            // so we can call it when it's clicked
            [menuItem setEnabled:true];
            [menuItem setRepresentedObject:object];
        i++;
    }
    
    
}

@end
