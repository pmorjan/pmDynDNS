//
//  AppController.h
//  pmDynDNS
//
//  Created by peter on 2010-09-30.
//  Copyright 2010 NoWhere. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppController : NSObject {
    NSWindow *window;
    NSString *ipDNS;
    NSString *ipCurrent;
    
}

@property (assign) IBOutlet NSWindow *window;
@property (copy)   NSString *ipDNS;
@property (copy)   NSString *ipCurrent;

- (IBAction)run:(id)sender;
@end
