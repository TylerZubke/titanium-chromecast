//
//  ComAtticoosTitaniumChromecastDeviceManagerProxy.m
//  titanium-chromecast
//
//  Created by Atticus White on 12/20/14.
//
//

#import "ComAtticoosTitaniumChromecastDeviceManagerProxy.h"
#import "Device.h"

@implementation ComAtticoosTitaniumChromecastDeviceManagerProxy

-(instancetype)init
{
    if (self = [super init]) {
        self.deviceScanner = [[GCKDeviceScanner alloc] init];
        //self.deviceManager = [[GCKDeviceManager alloc] init];
    }
    return self;
}

-(void)startScanning:(id)args
{
    ENSURE_UI_THREAD_0_ARGS
    [self.deviceScanner addListener: self];
    [self.deviceScanner startScan];
}

-(void)stopScanning:(id)args
{
    [self.deviceScanner removeListener: self];
    [self.deviceScanner stopScan];
}

-(NSArray*)getDiscoveredDevices:(id)args
{
    NSArray *devices = self.deviceScanner.devices;
    NSMutableArray *seralizedDevices = [[NSMutableArray alloc] initWithCapacity: [devices count]];
    
    for (int i = 0; i < [devices count]; i++) {
        [seralizedDevices addObject: [[Device alloc] initWithDevice:[devices objectAtIndex: i]]];
    }
    
    NSArray *finalArray = [NSArray arrayWithArray:seralizedDevices];
    return finalArray;
}

-(void)deviceDidComeOnline:(GCKDevice *)device
{
    NSLog(@"Device came online %@", device.friendlyName);
    NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:[[Device alloc] initWithDevice:device], @"device", nil];
    [self fireEvent:@"deviceOnline" withObject: event];
}

-(void)deviceDidGoOffline:(GCKDevice *)device
{
    NSLog(@"Device went offline %@", device.friendlyName);
    NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:[[Device alloc] initWithDevice:device], @"device", nil];
    [self fireEvent:@"deviceOffline" withObject: event];
}

@end