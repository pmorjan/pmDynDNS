//
//  AppController.h
//  pmDynDNS
//

#import <Cocoa/Cocoa.h>
#import "AppController.h"
#import "Preferences.h"

@interface AppController : NSObject {
    Preferences     *preferences;
    NSWindow        *window;
    NSString        *ipDNS;
    NSString        *ipCurrent;
    NSImage         *icon;
    NSString        *hostname;
    NSString        *urlCheckIP;
    NSTextField     *textFieldHostname;
    IBOutlet NSButton *button;
    IBOutlet NSProgressIndicator *progress;
}

@property (assign)      IBOutlet NSWindow *window;
@property (copy)        NSString *ipDNS;
@property (copy)        NSString *ipCurrent;
@property (retain)      NSImage *icon;
@property (readonly)    NSString *hostname;
@property (readonly)    NSString *urlCheckIP;
- (IBAction)checkDNS:(id)sender;
@end
