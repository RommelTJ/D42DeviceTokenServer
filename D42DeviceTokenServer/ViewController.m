//
//  ViewController.m
//  D42DeviceTokenServer
//
//  Created by Rommel Rico on 2/12/15.
//  Copyright (c) 2015 Rommel Rico. All rights reserved.
//

#import "ViewController.h"

#define DEVICE_SERVICE_TYPE @"_http._tcp"
#define DEVICE_SERVICE_NAME @"com.rommelrico.DeviceToken"
#define DEVICE_SERVICE_PORT 50388

@interface ViewController () <NSNetServiceDelegate>

@property (weak) IBOutlet NSTextField *myServerStatusLabel;
@property NSNetService *myService;

@end

@implementation ViewController

- (IBAction)doStartHTTPServerButton:(NSButton *)button {
    //NSButton *button = sender;
    static BOOL advertising = YES;
    if (advertising) {
        //Start Advertising
        self.myService = [[NSNetService alloc] initWithDomain:@"" type:DEVICE_SERVICE_TYPE name:DEVICE_SERVICE_NAME port:DEVICE_SERVICE_PORT];
        self.myService.delegate = self;
        [self.myService publish];
        //Change button text
        [button setTitle:@"Stop HTTP Server"];
    } else {
        //Stop Advertising
        [self.myService stop];
        [button setTitle:@"Start HTTP Server"];
    }
    advertising = !advertising;
    
}

-(void)netServiceDidPublish:(NSNetService *)sender {
    self.myServerStatusLabel.stringValue = @"Server did publish!";
}

-(void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict {
    self.myServerStatusLabel.stringValue = @"Server did not publish!";
}

-(void)netServiceDidStop:(NSNetService *)sender {
    self.myServerStatusLabel.stringValue = @"Server did stop!";
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
