//
//  ComAcktieMobileIosQrViewProxy.m
//  acktie mobile qr ios
//
//  Created by Tony Nuzzi on 3/3/13.
//
//

#import "ComAcktieMobileIosQrQRCodeViewProxy.h"
#import "AcktieZbar.h"

@class AcktieZbar;
@implementation ComAcktieMobileIosQrQRCodeViewProxy

@synthesize successCallback;

-(void)_initWithProperties:(NSDictionary *)args
{
    NSLog(@"Inside _initWithProperties");
    
	[super _initWithProperties:args];
    AcktieZbar* localAZbar = [[[AcktieZbar alloc] init:args] autorelease];
    [localAZbar setProxy:self];
    
    [self setAZbar:localAZbar];
    
}

#pragma Public APIs (available in javascript)
- (void) scanQR:(id)args
{
    NSLog(@"scanQR in proxy");
    [[self view] performSelectorOnMainThread:@selector(scanQR:)
                                  withObject:args waitUntilDone:NO];
}

- (void) turnLightOff:(id)args
{
    NSLog(@"turnLightOff in proxy");
    [[self view] performSelectorOnMainThread:@selector(turnLightOff:)
                                  withObject:args waitUntilDone:YES];
}

- (void) toggleLight:(id)args
{
    NSLog(@"toggleLight in proxy");
    [[self view] performSelectorOnMainThread:@selector(toggleLight:)
                                  withObject:args waitUntilDone:YES];
}

- (void) turnLightOn:(id)args
{
    NSLog(@"turnLightOn in proxy");
    [[self view] performSelectorOnMainThread:@selector(turnLightOn:)
                                  withObject:args waitUntilDone:YES];
}

- (void) stop:(id)args
{
    NSLog(@"stop in proxy");
    [[self view] performSelectorOnMainThread:@selector(stop:)
                                  withObject:args waitUntilDone:NO];
}
@end
