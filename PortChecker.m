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
@synthesize status;
/*
 int
 connect(int socket, const struct sockaddr *address, socklen_t address_len);
*/

- (id) init
{
    self = [super init];
    if (self != nil) {
        hostname = @"";
        port     = [NSNumber numberWithInt:0];
        status   = [NSNumber numberWithInt:0];
    }
    return self;
}


- (void)checkStatus;
{
    DLog();
    const char *hostName = [hostname UTF8String];
    struct sockaddr_in  addr;
    struct hostent      *ent;
    struct in_addr      host;
    int                 sock = 0;
    int flags;
    int rc;
    int err;
    socklen_t len;
    fd_set socks_read, socks_write;
    
    [self setStatus:0];

    struct timeval timeout;
    timeout.tv_sec = 5;
    timeout.tv_usec = 500000;
    
    /* 
     * create address
     */
    if (hostName[0] >= '0' && hostName[0] <= '9') {
        host.s_addr = inet_addr(hostName);
    } else {   ent = gethostbyname(hostName);
        if (!ent)
        {   NSLog(@"gethostbyname failed\n");
            return;
        }
        memcpy(&host, ent->h_addr, sizeof(struct in_addr));
    }
    addr.sin_addr = host;
    addr.sin_port = htons((u_short)[port intValue]);
    addr.sin_family = AF_INET;

    
    /*
     * - make a socket descriptor with socket(), set it to non-blocking, 
     * - call connect(), and if all goes well connect() will return -1 immediately and errno will be set to EINPROGRESS. 
     * - Then you call select() with whatever timeout you want, passing the socket descriptor in both the read and write sets. 
     *   If it doesn't timeout, it means the connect() call completed. At this point, you'll have to 
     * - use getsockopt() with the SO_ERROR option to get the return value from the connect() call, 
     *   which should be zero if there was no error.
     */
    if ((sock = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
        perror("Socket");
        exit(1);
    }
    
    flags = fcntl(sock, F_GETFL, 0);
    fcntl(sock, F_SETFL, flags | O_NONBLOCK);
    
    FD_SET(sock,&socks_read);
    FD_SET(sock,&socks_write);
    
    /*
    int
        select( int nfds, 
                fd_set *restrict readfds, 
                fd_set *restrict writefds, 
                fd_set *restrict errorfds, 
                struct timeval *restrict timeout);   
     
        If the time limit expires, select() returns 0.
    */
    rc = connect(sock, (struct sockaddr *) &addr, sizeof(struct sockaddr));    
    DLog(@"connect  %s:%@ rc = %d",hostName, port, rc);

    
    
    
    int max_sock = sock;
    rc = select(max_sock +1, &socks_read, &socks_write, (fd_set *) 0, &timeout);    
    DLog(@"select  %s:%@ rc = %d",hostName, port, rc);
    getsockopt(sock, SOL_SOCKET, SO_ERROR, &err, &len);
    DLog(@"sockopt %s:%@ err = %d",hostName, port, err);

    if (rc == 0) {
        // timeout
        [self setStatus:[NSNumber numberWithInt:-1]];
        DLog(@"time out");
    } else {
        // get real rc of connect()
        getsockopt(sock, SOL_SOCKET, SO_ERROR, &err, &len);
//        DLog(@"sockopt %s:%@ rc = %d",hostName, port, err);
        if (err == 0) {
            [self setStatus:[NSNumber numberWithInt:1]];
        } else {
            [self setStatus:[NSNumber numberWithInt:-1]];
        }
    }
    close(sock);
    sock = NULL;
}

@end
