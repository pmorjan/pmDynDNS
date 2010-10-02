//
//  PortChecker.h
//  pmDynDNS
//
//  Created by peter on 2010-10-02.
//  Copyright 2010 NoWhere. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PortChecker : NSObject {
    NSNumber *port;
    NSString *hostname;
    NSString *result;
}

@property (copy) NSString *result;
@property (copy) NSString *hostname;
@property (retain) NSNumber *port;

- (IBAction)checkPort:(id)sender;
@end
