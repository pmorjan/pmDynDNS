//
//  AppController.h
//  pmDynDNS
//

#import <Cocoa/Cocoa.h>
#import "AppController.h"
#import "Preferences.h"

@interface AppController : NSObject {
    Preferences     *preferences;
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
@property (readonly)    NSString *hostname;
- (IBAction)checkDNS:(id)sender;
@end
