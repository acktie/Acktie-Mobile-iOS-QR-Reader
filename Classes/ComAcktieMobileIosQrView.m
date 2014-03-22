//
//  ComAcktieMobileIosQrView.m
//  acktie mobile qr ios
//
//  Created by Tony Nuzzi on 3/3/13.
//
//

#import "ComAcktieMobileIosQrView.h"
#import "ComAcktieMobileIosQrQRCodeViewProxy.h"

@class ComAcktieMobileIosQrModule;

@implementation ComAcktieMobileIosQrQRCodeView


-(void)dealloc
{
    NSLog(@"Inside dealloc");
    
    if(reader != nil)
    {
        [reader dismissModalViewControllerAnimated:NO];
        [reader viewWillDisappear:NO];
        [reader viewDidDisappear:NO];
        RELEASE_TO_NIL(reader);
    }
    
    [super dealloc];
}

-(id) init
{
    NSLog(@"Inside init");
    
    self = [super init];
    
    return self;
}

-(void)reader
{
    NSLog(@"Inside Reader");
    if (reader == nil)
    {
        AcktieZbar* aZbar = [self getAZbar];
        
        NSString* readerController = @"ZBarReaderViewController";
        ZBarReaderControllerCameraMode cameraMode = ZBarReaderControllerCameraModeSampling;
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        BOOL useOverlay = true;
        
        [aZbar initScanner:readerController cameraMode:cameraMode sourceType:sourceType useOverlay:useOverlay cameraDeviceToUse:[aZbar cameraDevice]];
        
        reader = [aZbar reader];
        
        // Use custom controls
        reader.showsZBarControls = NO;
        reader.showsCameraControls = NO;
        [aZbar initControls:reader showScanButton:NO scanButtonName:nil];
        
        [self addSubview:reader.view];
    }
}

-(void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
    NSLog(@"Inside frameSizeChanged");
    if (reader == nil)
    {
        [self reader];
    }
    
    [TiUtils setView:reader.view positionRect:bounds];
    
    AcktieZbar* aZbar = [self getAZbar];
    
    [[aZbar reader] viewDidLoad];
    [[aZbar reader] viewWillAppear:NO];
    UIApplication *app = [UIApplication sharedApplication];
    [app setStatusBarHidden: NO withAnimation: nil];
}

-(AcktieZbar*) getAZbar
{
    NSLog(@"Inside getAZbar");
    
    ComAcktieMobileIosQrQRCodeViewProxy* viewProxy = (ComAcktieMobileIosQrQRCodeViewProxy*)[self proxy];
    return [viewProxy aZbar];
}

#pragma Public APIs (available in javascript)
- (void) scanQR:(id)args
{
    AcktieZbar* aZbar = [self getAZbar];
    [aZbar scan];
    
    NSLog(@"scanQR in View");
}

- (void) turnLightOff:(id)args
{
    NSLog(@"turnLightOff in view");
    AcktieZbar* aZbar = [self getAZbar];
    [aZbar turnLightOff];
}

- (void) turnLightOn:(id)args
{
    NSLog(@"turnLightOn in view");
    AcktieZbar* aZbar = [self getAZbar];
    [aZbar turnLightOn];
}

- (void) toggleLight:(id)args
{
    NSLog(@"toggleLight in view");
    AcktieZbar* aZbar = [self getAZbar];
    [aZbar toggleLight];
}

- (void) stop:(id)args
{
    AcktieZbar* aZbar = [self getAZbar];
    [aZbar cancel];
    
    NSLog(@"stop in View");
}

@end


