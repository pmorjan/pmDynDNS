//
//  AppController.h
//  pmDynDNS
//

#import <Cocoa/Cocoa.h>
#import "AppController.h"

@interface AppController : NSObject {
    NSString        *ipDNS;
    NSString        *ipCurrent;
    NSImage         *icon;
    NSString        *hostname;
    IBOutlet NSTextField *urlLabel;
    IBOutlet NSButton *button;
    IBOutlet NSProgressIndicator *progress;
}

@property (copy)        NSString *ipDNS;
@property (copy)        NSString *ipCurrent;
@property (retain)      NSImage  *icon;
@property (copy)    NSString *hostname;
- (IBAction)checkDNS:(id)sender;
@end
