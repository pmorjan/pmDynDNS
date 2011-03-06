//
//  AppController.h
//  pmDynDNS
//

#import <Cocoa/Cocoa.h>
#import "AppController.h"

@interface AppController : NSObject <NSApplicationDelegate> {
    IBOutlet NSWindow *window;
    NSString *ipDNS;
    NSString *ipCurrent;
    NSImage  *icon;
    NSString *hostname;
    IBOutlet NSTextField *urlLabel;
    IBOutlet NSButton *button;
    IBOutlet NSProgressIndicator *progress;
}

@property (assign)  NSWindow *window;
@property (copy)    NSString *ipDNS;
@property (copy)    NSString *ipCurrent;
@property (retain)  NSImage  *icon;
@property (copy)    NSString *hostname;

- (IBAction)checkDNS:(id)sender;
@end
