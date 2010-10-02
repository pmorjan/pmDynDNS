//
//  PortChecker.m
//  pmDynDNS
//
//  Created by peter on 2010-10-02.
//  Copyright 2010 NoWhere. All rights reserved.
//

#import "PortChecker.h"
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netdb.h>



@implementation PortChecker

@synthesize port;
@synthesize hostname;
@synthesize result;
/*
 int
 connect(int socket, const struct sockaddr *address, socklen_t address_len);
*/

- (id) init
{
    self = [super init];
    if (self != nil) {
        hostname = @"ber0tec.dyndns.org";
        port     = @"51967";
        result   = @"unknown";
    }
    return self;
}


- (IBAction)checkPort:(id)sender
{
    const char *hostName = [hostname cString];
    struct sockaddr_in  addr;
    struct hostent      *ent;
    struct in_addr      host;
    int                 sock = 0;
    int rc = 0;
    
    [self setResult:@"unknown"];
    
    if (hostName[0] >= '0' && hostName[0] <= '9') {
        host.s_addr = inet_addr(hostName);
    } else {   ent = gethostbyname(hostName);
        if (!ent)
        {   NSLog(@"gethostbyname failed\n");
            return;
        }
        memcpy(&host, ent->h_addr, sizeof(struct in_addr));
    }
    
    
    sock = socket(AF_INET, SOCK_STREAM, 0);
    addr.sin_addr = host;
    addr.sin_port = htons((u_short)[port intValue]);
    addr.sin_family = AF_INET;
    
    rc = connect(sock, (struct sockaddr *) &addr, sizeof(struct sockaddr_in));
    if (rc != 0) {   
        NSLog(@"connect failed, rc = %d", rc);
        [self setResult:@"closed"];
    } else {
        NSLog(@"connect succeeded, rc = %d", rc);
        [self setResult:@"open"];
    }
}

@end
