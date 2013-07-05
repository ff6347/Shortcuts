//
//  GlobalValues.h
//  Shortcuts
//
//  Created by Fabian Morón Zirfas on 05.07.13.
//  Copyright (c) 2013 the-moron.net. All rights reserved.
//



#import <foundation/Foundation.h>

@interface GlobalValues : NSObject {
    NSString *LIBPATH;
    NSString *FILENAME;
    NSString *FILEEXT;
    NSString *FULLFILEPATH;


}

@property (nonatomic, copy) NSString *LIBPATH;
@property (nonatomic, copy) NSString *FILENAME;
@property (nonatomic, copy) NSString *FILEEXT;
@property (nonatomic, copy) NSString *FULLFILEPATH;

+ (GlobalValues *)sharedManager;

@end