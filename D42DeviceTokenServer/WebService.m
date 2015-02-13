//
//  WebService.m
//  D42DeviceTokenServer
//
//  Created by Rommel Rico on 2/12/15.
//  Copyright (c) 2015 Rommel Rico. All rights reserved.
//

#import "WebService.h"
#import <arpa/inet.h>

@interface WebService ()

@property int serviceFileDescriptor;
@property BOOL running;

@end

@implementation WebService

+(instancetype)webServiceWithDelegate:(id)delegate {
    WebService *service = [WebService new];
    service.delegate = delegate;
    return service;
}

-(void)startServer {
    self.running = YES;
    
    // 1. Create socket.
    self.serviceFileDescriptor = socket(AF_INET, SOCK_STREAM, 0);
    if (self.serviceFileDescriptor < 0) {
        NSLog(@"socket error: %i", errno);
        return;
    }
    
    // 2. Bind to socket (assign an address to a socket).
    struct sockaddr_in service_address;
    service_address.sin_family = AF_INET;
    service_address.sin_addr.s_addr = htonl(INADDR_ANY);
    service_address.sin_port = htons(50388); //Hard coded for testing.
    int result = bind(self.serviceFileDescriptor, (struct sockaddr *)&service_address, sizeof(service_address));
    if (result < 0 ) {
        NSLog(@"bind error: %i", errno);
        return;
    }
    
    // 3. Set socket to listen mode.
    listen(self.serviceFileDescriptor, 16); //Backlog of 16 connections.
    
    // while true
    // 4. Accept connections to socket.
    // 5. Read from the socket.
    // 6. Close the socket.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        while (self.running) {
            struct sockaddr_in client_address;
            socklen_t client_address_length = sizeof(client_address);
            NSLog(@"Waiting for connection...");
            int clientFileDescriptor = accept(self.serviceFileDescriptor, (struct sockaddr *)&client_address, &client_address_length);
            if (clientFileDescriptor < 0) {
                NSLog(@"accept error: %i", errno);
            } else {
                NSLog(@"Got a connection!");
                char buffer[1024];
                ssize_t size = read(clientFileDescriptor, buffer, sizeof(buffer));
                NSLog(@"Size: %lu", size);
                NSData *data = [NSData dataWithBytes:buffer length:size];
                NSLog(@"deviceToken: %@", data);
                close(clientFileDescriptor);
            }
            
        }
    });
    
}

-(void)stopServer {
    //TODO
}

@end
