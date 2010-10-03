//
//  AppController.h
//  pmDynDNS
//
//  Created by peter on 2010-09-30.
//  Copyright 2010 NoWhere. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppController.h"

@interface AppController : NSObject {
    NSWindow *window;
    NSString *ipDNS;
    NSString *ipCurrent;
    BOOL    animate;
    NSImage *icon;
    
}

@property (assign) IBOutlet NSWindow *window;
@property (copy)   NSString *ipDNS;
@property (copy)   NSString *ipCurrent;
@property (assign) BOOL animate;
@property (retain) NSImage *icon;

- (IBAction)doIPCheck:(id)sender;
@end
