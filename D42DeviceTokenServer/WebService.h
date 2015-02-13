//
//  WebService.h
//  D42DeviceTokenServer
//
//  Created by Rommel Rico on 2/12/15.
//  Copyright (c) 2015 Rommel Rico. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebService : NSObject

+(instancetype)webServiceWithDelegate:(id)delegate;
-(void)startServer;
-(void)stopServer;

@property (assign, nonatomic) id delegate;

@end
