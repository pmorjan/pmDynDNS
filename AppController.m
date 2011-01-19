//
//  AppController.m
//  pmDynDNS
//

#import "AppController.h"

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
        preferences = [[Preferences alloc]init];
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
    //[self doIPCheck:nil];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
	return YES;
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    [preferences setHostname:hostname];
}

- (void)awakeFromNib {
    NSString *p_hostname = [preferences hostname];
    if (p_hostname == nil) {
        p_hostname = @"myname.dyndns.org";
    }
    [self setValue:p_hostname forKey:@"hostname"];
}

- (IBAction)checkDNS:(id)sender {
    DLog(@"");
    [self setAnimate:YES];
    [self setIcon:nil];
    [self setIpDNS:@"0.0.0.0"];
    [self setIpCurrent:@"0.0.0.0 "];
    [self setErrorMsg:@""];
    [button setEnabled:NO];
    [NSThread detachNewThreadSelector:@selector(startThread) toTarget:self withObject:nil];
}

- (void)startThread {
    DLog(@"");    
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    [NSHost flushHostCache];
    NSHost *host = [NSHost hostWithName:hostname];
    if (host) {
        [self setIpDNS:[host address]];
    } else {
        [self setIpDNS:@"IP not found"];
    }

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
            // <html><head><title>Current IP Check</title></head><body>Current IP Address: 21.120.121.19</body></html>
            NSArray *a = [[xmlDoc nodesForXPath:@"html/body" error:&error]retain];
            if (!a || [a count] < 1) {
                [self setErrorMsg:@"can't get current IP"];        
            } else {
                // <body>Current IP Address: 21.120.121.19</body>    
                NSString * s = [NSString stringWithString:[[a objectAtIndex:0]stringValue]];
                NSRange r =  { 20 , [s length]-20 };
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
    [button setEnabled:YES];
    if ([ipDNS isEqual:ipCurrent]) {
        [self setIcon:[self createIconWithColor:[NSColor greenColor]]];
    } else {
        [self setIcon:[self createIconWithColor:[NSColor redColor]]];
    }
}

@end
