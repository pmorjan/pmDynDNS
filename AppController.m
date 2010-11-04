//
//  AppController.m
//  pmDynDNS
//
//  Created by peter on 2010-09-30.
//  Copyright 2010 NoWhere. All rights reserved.
//

#import "AppController.h"



// http://www.myip.ch/      <html><head><title>Current IP Check</title></head><body>Current IP Address: 85.180.119.30</body></html>
// http://whatismyip.org/   1.2.3.4  (no eol)

@interface AppController (Private)
- (NSImage *)createIconWithColor:(NSColor *)color;

@end


@implementation AppController


@synthesize window;
@synthesize ipDNS, ipCurrent;
@synthesize animate;
@synthesize icon;
@synthesize hostname;
@synthesize urlCheckIP;
@synthesize errorMsg;


- (id) init
{
    self = [super init];
    if (self != nil) {
        hostname    = @"ber0tec.dyndns.org";
        urlCheckIP  = @"http://checkip.dyndns.org";
        ipDNS       = @"0.0.0.0";
        ipCurrent   = @"0.0.0.0";
        errorMsg    = @"";
        animate     = NO;
        [NSHost setHostCacheEnabled:NO];
        icon        = nil;
    }
    return self;
}

- (NSImage *)createIconWithColor:(NSColor *)color
{
    NSSize imgSize = NSMakeSize(16, 16);

    NSImage *image = [[NSImage alloc] initWithSize:imgSize];
    [image lockFocus];
    [[NSColor blackColor] set];
    [NSBezierPath fillRect: NSMakeRect(0, 0, imgSize.width, imgSize.height )];
    [color set];
    [NSBezierPath fillRect: NSMakeRect(1, 1, imgSize.width -2, imgSize.height -2)];
    [image unlockFocus];
    [image autorelease];
    return image;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
    //[self doIPCheck:nil];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
	return YES;
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];    
}

- (IBAction)doIPCheck:(id)sender {
    DLog(@"");
    [self setAnimate:YES];
    [self setIcon:nil];
    [self setIpDNS:@"0.0.0.0"];
    [self setIpCurrent:@"0.0.0.0"];
    [self setErrorMsg:@""];
    [NSThread detachNewThreadSelector:@selector(startThread) toTarget:self withObject:nil];
}

- (void)startThread {
    DLog(@"");    
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    [NSHost flushHostCache];
    [self setIpDNS:[[NSHost hostWithName:hostname]address]];
    
    NSError *error;
    NSURLResponse *response;
    NSURL *url = [NSURL URLWithString:urlCheckIP];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
                                                cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData 
                                            timeoutInterval:20];
    
    NSData *urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    if (!urlData) {
        [self setErrorMsg:[error localizedDescription]];

    } else {
    
        NSXMLDocument *xmlDoc = [[NSXMLDocument alloc]initWithData:urlData options:0 error:&error];
        if (!xmlDoc) {
            [self setErrorMsg:[error localizedDescription]];
        } else {    
            // <html><head><title>Current IP Check</title></head><body>Current IP Address: 85.180.120.19</body></html>
            NSArray *a = [[xmlDoc nodesForXPath:@"html/body" error:&error]retain];
            if (!a || [a count] < 1) {
                [self setErrorMsg:@"can't get current IP"];        
            } else {
                // <body>Current IP Address: 85.180.120.19</body>    
                NSString * s = [NSString stringWithString:[[a objectAtIndex:0]stringValue]];
                NSRange r =  { 20 , [s length]-20};
                NSLog(@"%@", s);
                [self setIpCurrent:[s substringWithRange:r]];
                [self setErrorMsg:@""];
            }
        }
    }

    [self performSelectorOnMainThread:@selector(threadDone) withObject:nil waitUntilDone:NO];
	[pool release];

}

- (void)threadDone {
    DLog(@"");
    [self setAnimate:NO];
    if ([ipDNS isEqual:ipCurrent]) {
        [self setIcon:[self createIconWithColor:[NSColor greenColor]]];
    } else {
        [self setIcon:[self createIconWithColor:[NSColor redColor]]];
    }
}


@end
