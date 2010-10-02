//
//  AppController.m
//  pmDynDNS
//
//  Created by peter on 2010-09-30.
//  Copyright 2010 NoWhere. All rights reserved.
//

#import "AppController.h"

static NSString *hostname   = @"ber0tec.dyndns.org";
static NSString *urlCheckIP = @"http://checkip.dyndns.org";

// http://www.myip.ch/      <html><head><title>Current IP Check</title></head><body>Current IP Address: 85.180.119.30</body></html>



@implementation AppController

@synthesize window;
@synthesize ipDNS, ipCurrent;

- (id) init
{
    self = [super init];
    if (self != nil) {
        ipDNS       = @"0.0.0.0";
        ipCurrent   = @"0.0.0.0";
        [NSHost setHostCacheEnabled:NO];
    }
    return self;
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
	return YES;
}

- (IBAction)run:(id)sender 
{
    [self setIpDNS:[[NSHost hostWithName:hostname]address]];
    
    NSError *error;
    NSURLResponse *response;

    

    NSURL *url = [NSURL URLWithString:urlCheckIP];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData 
                                            timeoutInterval:10];
                                            
    
    NSData *urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    
    
    
    if (!urlData) {
        [[NSAlert alertWithError:error]runModal];
        return;
    }
    
    NSXMLDocument *xmlDoc = [[NSXMLDocument alloc]initWithData:urlData options:0 error:&error];
    if (!xmlDoc) {
        [[NSAlert alertWithError:error]runModal];
        return;
    }
    
    NSLog(@"%@", xmlDoc);
    // <html><head><title>Current IP Check</title></head><body>Current IP Address: 85.180.120.19</body></html>

    NSArray *a = [[xmlDoc nodesForXPath:@"html/body" error:&error]retain];
    if (!a) {
        [[NSAlert alertWithError:error]runModal];
        return;
    }

    NSString * s = [NSString stringWithString:[[a objectAtIndex:0]stringValue]];
    // <body>Current IP Address: 85.180.120.19</body>
    NSRange r =  { 20 , [s length]-20};
    NSLog(@"%@", s);
    
    [self setIpCurrent:[s substringWithRange:r]];
    
}

@end
