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
    NSLog([GlobalValues sharedManager].FULLFILEPATH);
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
    
    
    shortcutsConfigFile = [GlobalValues sharedManager].FULLFILEPATH;//[NSHomeDirectory() stringByAppendingPathComponent:@".shuttle.json"];

//    /***
//     * This is taken from the 
//     * https://github.com/fabiantheblind/StatusBarApp
//     */
//    
//    statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];// add the statusbar
//    statusBar.title = @"SC";// give it a title
    
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:25.0];
    [statusItem setMenu:menu];
    [statusItem setHighlightMode:YES];
    [statusItem setTitle:@"SC"];

    
//  [[self.statusBar menu] setDelegate:self];
    // you can also set an image
    //self.statusBar.image =
    // This is taken from
    // https://github.com/fitztrev/shuttle
    
//    [statusBar setMenu:menu];
//    [statusBar setHighlightMode:YES];
//    statusBar.highlightMode = YES;
    NSLog(@"end of awake from nib");
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
    if ( [self needUpdateFor:shortcutsConfigFile with:txtModified]
//        [self needUpdateFor: @"/etc/ssh/ssh_conifg" with:txtConfigSystem] ||
//        [self needUpdateFor: @"~/.ssh/config" with:txtConfigUser]
        ) {
        
        txtModified = [self getMTimeFor:shortcutsConfigFile];
//        sshConfigSystem = [self getMTimeFor: @"/etc/ssh_conifg"];
//        sshConfigUser = [self getMTimeFor: @"~/.ssh/config"];
        [self loadMenu];
    }
}

// Parsing of the SSH Config File
// Courtesy of https://gist.github.com/geeksunny/3376694
//- (NSDictionary*) parseConfigFile {
//    
//    NSString *configFile = nil;
//    NSFileManager *fileMgr = [[NSFileManager alloc] init];
//    
//    // First check the system level configuration
////    if ([fileMgr fileExistsAtPath: @"/etc/ssh_config"]) {
////        configFile = @"/etc/ssh_config";
////    }
//    
//    // Fallback to check if actually someone used /etc/ssh/ssh_config
////    if ([fileMgr fileExistsAtPath: [@"~/.ssh/config" stringByExpandingTildeInPath]]) {
////        configFile = [@"~/.ssh/config" stringByExpandingTildeInPath];
////    }
//    
//    if (configFile == nil) {
//        // We did not find any config file so we gracefully die
//        return nil;
//    }
//    
//    
//    // Get file contents into fh.
//    NSString *fh = [NSString stringWithContentsOfFile:configFile encoding:NSUTF8StringEncoding error:nil];
//    // Initialize our server list as an empty dictionary variable.
//    NSMutableDictionary *servers = [NSMutableDictionary dictionaryWithObjects:nil forKeys:nil];
//    
//    // Loop through each line and parse the file.
//    for (NSString *line in [fh componentsSeparatedByString:@"\n"]) {
//        
//        // Strip line
//        NSString *cleanedLine = [line stringByTrimmingCharactersInSet:[ NSCharacterSet whitespaceCharacterSet]];
//        
//        // Empty lines and lines starting with `#' are comments.
//        if ([cleanedLine length] == 0 || [line characterAtIndex:0] == '#')
//            continue;
//        
//        // Since there might be the possibility that someone thought it might be useful to use = for separating properties
//        // we have to check that. And of course for now, we are only looking into the host
//        // section and gently ignore the rest
//        NSError* error = NULL;
//        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^Host\\b" options:0 error: &error];
//        NSUInteger num = [regex numberOfMatchesInString:cleanedLine options:0 range:NSMakeRange(0, [cleanedLine length])];
//        if (num == 1) {
//            
//            // Somebody really used =
//            NSArray* components = nil;
//            if ([cleanedLine rangeOfString:@"="].length != 0) {
//                components = [cleanedLine componentsSeparatedByString:@"="];
//                
//            } else {
//                components = [cleanedLine componentsSeparatedByCharactersInSet:
//                              [NSCharacterSet whitespaceCharacterSet]];
//            }
//            
//            NSString* host = [[components objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//            
//            [servers setObject:[NSDictionary dictionaryWithObject: host forKey:@"Host"] forKey:host] ;
//        }
//    }
//    
//    return servers;
//}
// Replaces Underscores with Spaces for better readable names
//- (NSString*) humanize: (NSString*) val{
//    return [val stringByReplacingOccurrencesOfString:@"_" withString:@" "];
//}

- (void) loadMenu {
    NSLog(@"in load menu");
    // Initialize our server list as an empty dictionary variable.
//    NSMutableDictionary *servers = [NSMutableDictionary dictionaryWithObjects:nil forKeys:nil];
    
//    // System configuration
//    NSDictionary* servers = [self parseConfigFile];
    
    // Clear out the hosts so we can start over
    NSUInteger n = [[menu itemArray] count];
    for (int i=0;i<n-4;i++) {
        [menu removeItemAtIndex:0];
    }
    
//    // if the config file does not exist, create a default one
//    if ( ![[NSFileManager defaultManager] fileExistsAtPath:shuttleConfigFile] ) {
//        NSString *cgFileInResource = [[NSBundle mainBundle] pathForResource:@"shuttle.default" ofType:@"json"];
//        [[NSFileManager defaultManager] copyItemAtPath:cgFileInResource toPath:shuttleConfigFile error:nil];
//    }

    // Parse the config file
//    NSData *data = [NSData dataWithContentsOfFile:shuttleConfigFile];
//    id json = [NSJSONSerialization JSONObjectWithData:data
//                                              options:kNilOptions
//                                                error:nil];
    // Check valid JSON syntax
//    if ( !json ) {
//        NSMenuItem *menuItem = [menu insertItemWithTitle:@"Error parsing config"
//                                                  action:false
//                                           keyEquivalent:@""
//                                                 atIndex:0
//                                ];
//        [menuItem setEnabled:false];
//        return;
//    }
    
//    terminalPref = [json[@"terminal"] lowercaseString];
//    shuttleHosts = json[@"hosts"];
    
//    launchAtLoginController.launchAtLogin = [json[@"launch_at_login"] boolValue];
    
    
    NSMutableArray *list; // the list of things in the menu
    list = [NSMutableArray arrayWithObjects:  nil];// init
    /**
     * Read in the lines
     */
    DDFileReader * reader = [[DDFileReader alloc] initWithFilePath:[GlobalValues sharedManager].FULLFILEPATH];
    NSString * line = nil;
    while ((line = [reader readLine])) {
        //        NSLog(@"read line: %@", line);
        [list addObject:line];
    }
    
    for (int i = 0; i < [list count]; i++){
//        NSMenuItem *newItem = [[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:[list objectAtIndex: i]
//                                                                                   action:@selector(aboutDockAction:)
//                                                                            keyEquivalent:@""];
//        
//        [newItem setTarget: self];
//        [newItem setEnabled:YES];
//        [_ShortcutsMenu addItem:newItem];
    }
    
    
    
    // Rebuild the menu
    int i = 0;
    
    NSMutableDictionary* fullMenu = [NSMutableDictionary dictionary];
    
    // First add all the system serves we know
    for (int ln = 0; ln < [list count];ln++) {
//        NSDictionary* data = [servers objectForKey:key];
        
        // Ignore entrys that contain wildcard characters
        NSString* line= [list objectAtIndex: ln];
//        if ([host rangeOfString:@"*"].length != 0)
//            continue;
        
        // Parse hosts...
//        NSRange ns = [host rangeOfString:@"/"];
//        if (ns.length == 0) {
            [fullMenu setObject:[NSString stringWithFormat:@"%d %@",ln, line] forKey:line];
            
//        }
//        else {
//            NSString *part = [host substringToIndex: ns.location];
//            host = [host substringFromIndex:ns.location + 1];
//            
//            if ([fullMenu objectForKey:part] == nil) {
//                NSMutableDictionary *tmp = [NSMutableDictionary dictionary];
//                [fullMenu setObject:tmp forKey:part];
//            }
//            
//            [[fullMenu objectForKey:part] setObject:[NSString stringWithFormat:@"ssh %@", [data valueForKey:@"Host"]] forKey:host];
//        }
    }
    
    
    // Now add the JSON Configured Hosts
//    for (id key in shuttleHosts) {
//        // If it has a `cmd`, it's a top-level item
//        // otherwise, create a submenu for it
//        if ( [key valueForKey:@"cmd"] ) {
//            [fullMenu setObject:[key valueForKey:@"cmd"] forKey: [key valueForKey:@"name"]];
//        } else {
//            for ( id group in key ) {
//                if ([fullMenu valueForKey:group] == nil)
//                    [fullMenu setObject:[NSMutableDictionary dictionary] forKey:group];
//                
//                // Get the subpart
//                NSMutableDictionary* submenu = [fullMenu objectForKey:group];
//                for ( id subKey in [key valueForKey:group]) {
//                    [submenu setObject:[subKey valueForKey:@"cmd"] forKey:[subKey valueForKey:@"name"]];
//                }
//            }
//            
//        }
//        
//    }
    
    // Finally add everything
    NSArray* keys = [[fullMenu allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    
    for(id key in keys) {
        id object = [fullMenu valueForKey:key];
        
        // We have a submenu
//        if ([object isKindOfClass: [NSDictionary class]]) {
//            NSMenuItem *mainItem = [[NSMenuItem alloc] init];
//            [mainItem setTitle:key];
//            
//            NSMenu *submenu = [[NSMenu alloc] init];
//            NSArray* subkeys = [[object allKeys]  sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
//            for (id sub in subkeys) {
//                NSMenuItem *menuItem = [submenu addItemWithTitle:sub
//                                                          action:@selector   (openHost:)
//                                                   keyEquivalent:@""];
//                [menuItem setRepresentedObject:[object valueForKey:sub]];
//            }
//            [mainItem setSubmenu:submenu];
//            [menu insertItem:mainItem atIndex:i];
//            
//        } else {
            NSMenuItem *menuItem = [menu insertItemWithTitle:key
                                                      action:@selector(openHost:)
                                               keyEquivalent:@""
                                                     atIndex:i
                                    ];
            // Save that item's SSH command as its represented object
            // so we can call it when it's clicked
            [menuItem setEnabled:true];
            [menuItem setRepresentedObject:object];
//        }
        i++;
    }
    
    
}



//- (void)menuNeedsUpdate:(NSMenu *)menu {
//    NSLog(@"menuNeedsUpdate was called");
//    //    menu
//    if (menu == self.statusBar.menu) {
//        NSLog(@"in update");
//    }
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
//NSLog(@"end menuNeedsUpdate");
//}
//- (void)updateTheMenu {

    
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
//}
//
//- (void)menuWillOpen:(NSMenu *)menu{
//
//    if(menu == self.statusBar.menu){
//        NSLog(@"in menu will open");
//}
//
//}



//- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
//    
//    // Insert code here to initialize your application
////    NSTimer *timer = [NSTimer timerWithTimeInterval:0.5
////                                             target:self
////                                           selector:@selector(menuNeedsUpdate)
////                                           userInfo:nil
////                                            repeats:YES];
////    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//}



@end
