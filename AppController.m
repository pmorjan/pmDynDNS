//
//  AppController.m
//  pmDynDNS
//

#import "AppController.h"
#import <dispatch/dispatch.h>

@interface AppController (Private)
- (NSImage *)createIconWithColor:(NSColor *)color;
- (void) URLloockup;
- (void) DNSlookup;
- (void) allThreadsDone;
@end


@implementation AppController

@synthesize window;
@synthesize ipDNS, ipCurrent;
@synthesize icon;
@synthesize hostname;
@synthesize urlCheckIP;

- (id) init
{
    self = [super init];
    if (self != nil) {
        preferences = [[Preferences alloc]init];
        urlCheckIP  = @"http://checkip.dyndns.org";
        ipDNS       = @"0.0.0.0";
        ipCurrent   = @"0.0.0.0";
        icon        = nil;
        [NSHost setHostCacheEnabled:NO];
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
    [self setIcon:nil];
    [self setIpDNS:@"0.0.0.0"];
    [self setIpCurrent:@"0.0.0.0 "];
    [button setEnabled:NO];
    [progress startAnimation:self];    
    // create group to track blocks
    dispatch_group_t group = dispatch_group_create();
    // get global concurrent queue
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // dispatch block to queue, assign block to group
    dispatch_group_async(group, queue, ^{
        [self DNSlookup];
    });
    dispatch_group_async(group, queue, ^{    
        [self URLloockup];
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self allThreadsDone];
    });
}

- (void)DNSlookup {
    DLog();
    [NSHost flushHostCache];
    NSHost *host = [NSHost hostWithName:hostname];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setIpDNS:host ? [host address] : @"can't get IP"];
    });
}

- (void)URLloockup {
    DLog();
    NSString *str = @"unknown";
    NSError *error;
    NSURLResponse *response;
    NSURL *url = [NSURL URLWithString:urlCheckIP];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
                                                cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData 
                                            timeoutInterval:20];
        
    NSData *urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    if (!urlData) {
        NSAlert *alert = [NSAlert alertWithError:error];
        [alert runModal];
    } else {
    
        NSXMLDocument *xmlDoc = [[NSXMLDocument alloc]initWithData:urlData options:0 error:&error];
        if (!xmlDoc) {
            NSAlert *alert = [NSAlert alertWithError:error];
            [alert runModal];
        } else {    
            // <html><head><title>Current IP Check</title></head><body>Current IP Address: 21.120.121.19</body></html>
            NSArray *a = [[xmlDoc nodesForXPath:@"html/body" error:&error]retain];
            if (!a || [a count] < 1) {
                str = @"parse error";
            } else {
                // <body>Current IP Address: 21.120.121.19</body>    
                NSString * s = [NSString stringWithString:[[a objectAtIndex:0]stringValue]];
                NSRange r =  { 20 , [s length]-20 };
                str = [s substringWithRange:r];
            }
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setIpCurrent:str];
    });
}

- (void)allThreadsDone {
    DLog(@"");
    [progress stopAnimation:self];
    [button setEnabled:YES];

    if ([ipDNS isEqual:ipCurrent]) {
        [self setIcon:[self createIconWithColor:[NSColor greenColor]]];
    } else {
        [self setIcon:[self createIconWithColor:[NSColor redColor]]];
    }
}

@end
