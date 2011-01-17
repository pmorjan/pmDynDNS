// Preferences.m
//  pmEvent
//

#import "Preferences.h"

@implementation Preferences


- (NSString *)hostname
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:@"hostname"];
}

- (void)setHostname:(NSString *)value 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:@"hostname"];
    [defaults synchronize];
}

@end
