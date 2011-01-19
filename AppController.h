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
    BOOL            animate;
    NSImage         *icon;
    NSString        *hostname;
    NSString        *urlCheckIP;
    NSString        *errorMsg;
    NSTextField     *textFieldHostname;
    IBOutlet NSButton *button;
}

@property (assign)      IBOutlet NSWindow *window;
@property (copy)        NSString *ipDNS;
@property (copy)        NSString *ipCurrent;
@property (assign)      BOOL animate;
@property (retain)      NSImage *icon;
@property (readonly)    NSString *hostname;
@property (readonly)    NSString *urlCheckIP;
@property (copy)        NSString *errorMsg;
- (IBAction)checkDNS:(id)sender;
@end
