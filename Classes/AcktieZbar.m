//
//  Zbar.m
//  acktie mobile qr ios
//
//  Created by Tony Nuzzi on 3/3/13.
//
//

#import "AcktieZbar.h"
#import <AVFoundation/AVFoundation.h>
#import "TiUIViewProxy.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiApp.h"
#import "TiUIButtonProxy.h"

@implementation AcktieZbar
@synthesize reader;
@synthesize successCallback;
@synthesize cancelCallback;
@synthesize errorCallback;
@synthesize continuous;
@synthesize userControlLight;
@synthesize allowZoom;
@synthesize useJISEncoding;
@synthesize proxy;
@synthesize navBarButton;
@synthesize popover;
@synthesize cameraDevice;
@synthesize overlay;
@synthesize alpha;
@synthesize color;
@synthesize layout;
@synthesize imageName;

static const enum zbar_symbol_type_e symbolValues[] =
{
    ZBAR_NONE,
    ZBAR_PARTIAL,
    ZBAR_EAN2,
    ZBAR_EAN5,
    ZBAR_EAN8,
    ZBAR_UPCE,
    ZBAR_ISBN10,
    ZBAR_UPCA,
    ZBAR_EAN13,
    ZBAR_ISBN13,
    ZBAR_COMPOSITE,
    ZBAR_I25,
    ZBAR_DATABAR,
    ZBAR_DATABAR_EXP,
    ZBAR_CODE39,
    ZBAR_PDF417,
    ZBAR_QRCODE,
    ZBAR_CODE93,
    ZBAR_CODE128,
};

static const NSString* symbolKeys[] =
{
    @"NONE",
    @"PARTIAL",
    @"EAN2",
    @"EAN5",
    @"EAN8",
    @"UPCE",
    @"ISBN10",
    @"UPCA",
    @"EAN13",
    @"ISBN13",
    @"COMPOSITE",
    @"I25",
    @"DATABAR",
    @"DATABAR_EXP",
    @"CODE39",
    @"PDF417",
    @"QRCODE",
    @"CODE93",
    @"CODE128",
};

-(id)init
{
    NSLog(@"Inside -(id)init");
    self = [super init];
    if(self)
    {
        [self setContinuous:true];
        [self setUserControlLight:false];
        [self setAllowZoom:false];
    }
    
    return self;
}

-(id)init: (NSDictionary*) withDictionary
{
    NSLog(@"Inside -(id)init: (NSDictionary*) withDictionary");
    self = [self init];
    
    if(self)
    {
        [self continuous:withDictionary];
        // [self allowZoom:withDictionary];
        // [self userControlLight:withDictionary];
        [self useFrontCamera:withDictionary];
        [self useJISEncoding:withDictionary];
        [self setCallbacks:withDictionary];
        
        if([withDictionary objectForKey:@"overlay"] != nil)
        {
            [self setOverlay:YES];
            NSDictionary* _overlay = [withDictionary objectForKey:@"overlay"];
            
            [self overlayColor:_overlay];
            [self overlayLayout:_overlay];
            [self overlayAlpha:_overlay];
            [self overlayImageName:_overlay];
        }
        else
        {
            [self setOverlay:NO];
        }
    }

    NSLog(@"AcktieZBar init: %@", self);
    return self;
}

-(NSString*)moduleId
{
	return @"com.acktie.mobile.ios.qr";
}

- (void) initReader: (NSString*) clsName
{
    [reader release];
    reader = [NSClassFromString(clsName) new];
    reader.readerDelegate = self;
}

- (UIImage *)imageNamed:(NSString *)name
{
    NSLog(@"- (UIImage *)imageNamed:(NSString *)name");
    NSLog(@"name: %@",name);
    NSLog(@"moduleId: %@",[self moduleId]);
    
    
    NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
    NSString *modulePathWithFile = [NSString stringWithFormat:@"/modules/%@/%@", [self moduleId], name];
    NSString *fullPathWithFile = [NSString stringWithFormat:@"%@%@", bundlePath, modulePathWithFile];
    NSLog(fullPathWithFile);
    
    return [UIImage imageWithContentsOfFile:fullPathWithFile];
}

-(void) overlayColor: (NSDictionary*) _overlay
{
    NSString* _color = [TiUtils stringValue:[_overlay objectForKey:@"color"]];
    
    NSString* overLayColor = nil;
    if ([_color caseInsensitiveCompare:@"blue"] == NSOrderedSame) {
        overLayColor = @"Blue";
    }
    else if ([_color caseInsensitiveCompare:@"purple"] == NSOrderedSame) {
        overLayColor = @"Purple";
    }
    else if ([_color caseInsensitiveCompare:@"red"] == NSOrderedSame) {
        overLayColor = @"Red";
    }
    else if ([_color caseInsensitiveCompare:@"yellow"] == NSOrderedSame) {
        overLayColor = @"Yellow";
    }
    
    [self setColor:overLayColor];
    
    NSLog([NSString stringWithFormat:@"%@ %@", @"color:", color]);
}

-(void) overlayLayout: (NSDictionary*) _overlay
{
    NSString* _layout = [TiUtils stringValue:[_overlay objectForKey:@"layout"]];
    
    NSString* overlayLayout = nil;
    if ([layout caseInsensitiveCompare:@"center"] == NSOrderedSame) {
        overlayLayout = @"Center";
    }
    else if ([layout caseInsensitiveCompare:@"full"] == NSOrderedSame) {
        overlayLayout = @"FullScreen";
    }
    
    NSLog([NSString stringWithFormat:@"%@ %@", @"layout:", overlayLayout]);
    [self setLayout:overlayLayout];
}

-(void) overlayImageName: (NSDictionary*) _overlay
{
    NSString* _overlayImageName = nil;
    
    if([self color] != nil && [self layout] != nil)
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            _overlayImageName = [NSString stringWithFormat:@"Center-%@-ipad.png", [self color]];
        }
        else
        {
            _overlayImageName = [NSString stringWithFormat:@"%@-%@.png", [self layout], [self color]];
        }
    }
    else
    {
        NSString* _imageName = [TiUtils stringValue:[_overlay objectForKey:@"imageName"]];
        
        if(_imageName != nil)
        {
            _overlayImageName = [NSString stringWithString:_imageName];
        }
    }
    
    NSLog([NSString stringWithFormat:@"%@ %@", @"imageName:", _overlayImageName]);
    [self setImageName:[NSString stringWithString:_overlayImageName]];
}

-(void) overlayAlpha: (NSDictionary*) _overlay
{
    float _alpha = [TiUtils floatValue:[_overlay objectForKey:@"alpha"] def:1.0f];
    
    NSLog([NSString stringWithFormat:@"%@ %f", @"alpha:", _alpha]);
    [self setAlpha:_alpha];
}

- (void) setCallbacks: (NSDictionary*)args
{
    // callbacks
    if ([args objectForKey:@"success"] != nil)
    {
        NSLog(@"Received success callback");
        
        successCallback = [args objectForKey:@"success"];
        [successCallback retain];
    }
    
    if ([args objectForKey:@"error"] != nil)
    {
        NSLog(@"Received error callback");
        
        errorCallback = [args objectForKey:@"error"];
        [errorCallback retain];
    }
    
    if ([args objectForKey:@"cancel"] != nil)
    {
        NSLog(@"Received cancel callback");
        
        cancelCallback = [args objectForKey:@"cancel"];
        [cancelCallback retain];
    }
}

- (UIBarButtonItem*) flexSpace
{
    return [[[UIBarButtonItem alloc]
             initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
             target: nil
             action: nil]
            autorelease];
}

- (void) initControls: (ZBarReaderViewController*)readerView showScanButton:(BOOL)showScanButton scanButtonName:(NSString *)scanButtonName
{
//    readerView.showsZBarControls = NO;
//    
//    UIView *view = readerView.view;
//    
//    CGRect r = view.bounds;
//    r.origin.y = r.size.height - 54;
//    r.size.height = 54;
//    controls = [[UIView alloc] initWithFrame: r];
//    controls.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
//    
//    [controls setAlpha:0.75f];
//    controls.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleTopMargin;
//    controls.backgroundColor = [UIColor blackColor];
//    
//    UIToolbar *toolbar = [UIToolbar new];
//    toolbar.translucent = true;
//    r.origin.y = 0;
//    toolbar.frame = r;
//    toolbar.barStyle = UIBarStyleBlackTranslucent;
//    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    
//    UIBarButtonSystemItem button = 0;
//    
//    if(continuous)
//    {
//        button = UIBarButtonSystemItemDone;
//    }
//    else
//    {
//        button = UIBarButtonSystemItemCancel;
//    }
//    
//    NSMutableArray *toolBarItems = [[NSMutableArray alloc] init];
//    [toolBarItems addObject:[[[UIBarButtonItem alloc]
//                              initWithBarButtonSystemItem: button
//                              target: self
//                              action: @selector(cancel)]
//                             autorelease]];
//    [toolBarItems addObject:[self flexSpace]];
//    if(showScanButton)
//    {
//        [toolBarItems addObject:[[[UIBarButtonItem alloc]
//                                  initWithTitle: scanButtonName
//                                  style: UIBarButtonItemStyleDone
//                                  target: self
//                                  action: @selector(scan)]
//                                 autorelease]];
//        
//        [toolBarItems addObject:[self flexSpace]];
//    }
//    
//    if (userControlLight)
//    {
//        lightSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
//        [lightSwitch addTarget:self action:@selector(toggleLight) forControlEvents:UIControlEventValueChanged];
//        
//        [toolBarItems addObject:[[[UIBarButtonItem alloc]
//                                  initWithCustomView:lightSwitch]
//                                 autorelease]];
//    }
//    
//    toolbar.items = toolBarItems;
//    [controls addSubview: toolbar];
//    [toolbar release];
//    
//    [view addSubview: controls];
}

- (void) turnLightOff
{
    if([reader isKindOfClass:[ZBarReaderController class]])
    {
        reader.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    }
    else
    {
        reader.readerView.torchMode = AVCaptureTorchModeOff;
    }
}

- (void) turnLightOn
{
    if([reader isKindOfClass:[ZBarReaderController class]])
    {
        reader.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
    }
    else
    {
        reader.readerView.torchMode = AVCaptureTorchModeOn;
    }
}

- (void) toggleLight
{
    if(lightSwitch == nil)
        return;
    
    if(lightSwitch.on)
    {
        [self turnLightOn];
    }
    else
    {
        [self turnLightOff];
    }
}

- (void) scan
{
    reader.view.userInteractionEnabled = NO;
    [reader takePicture];
}

- (void) cancel
{
    SEL cb = @selector(imagePickerControllerDidCancel:);
    if([self respondsToSelector: cb])
        [self imagePickerControllerDidCancel: (UIImagePickerController*)reader];
    }

-(void)initScanner: (NSString*)readerController cameraMode:(ZBarReaderControllerCameraMode)cameraMode sourceType:(UIImagePickerControllerSourceType)sourceType useOverlay:(BOOL)useOverlay cameraDeviceToUse:(UIImagePickerControllerCameraDevice)cameraDeviceToUse
{
    
    NSLog(@"initScanner (new)");
    
    // init reader
    [self initReader: readerController];
    
    // Only enable Scanning of QRCodes
    for (int k = 0, l = (sizeof symbolKeys); l > k; k++) {
        [reader.scanner setSymbology: symbolValues[k]
                              config: ZBAR_CFG_ENABLE
                                  to: false];
    }
    
    [reader.scanner setSymbology:ZBAR_QRCODE config:ZBAR_CFG_ENABLE to:true];
    
    //sourceType
    reader.sourceType = sourceType;
    
    //cameraMode
    reader.cameraMode = cameraMode;
    
    //cameraDevice
    if(cameraDeviceToUse != 0)
    {
        reader.cameraDevice = cameraDeviceToUse;
    }
    
    if ([reader isKindOfClass:[ZBarReaderViewController class]])
    {
        if(allowZoom)
        {
            // reader.readerView.allowsPinchZoom = true;
        }
        else
        {
            reader.readerView.allowsPinchZoom = false;
        }
    }
    
    // Default the light to off
    [self turnLightOff];
    
    if(useOverlay)
    {
        if ([self overlay]) {
            NSLog(@"use an overlay");
                        
            if(self.imageName != nil);
            {
                NSLog(@"name: %@",self.imageName);
                // Add Image overlay
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[self imageNamed:[self imageName]]];
                imageView.backgroundColor = [UIColor clearColor];
                imageView.alpha = [self alpha];
                
                reader.cameraOverlayView = imageView;
            }
        }
    }
    
    [reader setTracksSymbols: NO];
    [reader setShowsHelpOnFail: NO];
    [reader setShowsCameraControls: NO];
    [reader setShowsZBarControls: NO];
}

-(void) show
{
    // show
    TiApp* tiApp = [TiApp app];
    [tiApp showModalController:reader animated:YES];
}

- (void) imagePickerController: (UIImagePickerController*) imagePickerController
didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    NSLog(@"imagePickerController (Successful Scan):");
    
    // get the results of image scan
    id <NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    
    int quality = 0;
    ZBarSymbol *symbol = nil;
    for(ZBarSymbol *sym in results)
    {
        NSLog([NSString stringWithFormat:@"%@ %d", @"Quality of Scan (Higher than 0 is good):", sym.quality]);
        if(sym.quality > quality)
        {
            symbol = sym;
        }
    }
    
    // Callback for success
    if (successCallback != nil)
    {
        id listener = [[successCallback retain] autorelease];
        
        // Populate Callback data
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        
        NSString *qrData = symbol.data;
        
        // If true try to encode string with ShiftJIS (use by Chinese and Kanji)
        if([self useJISEncoding])
        {
            if ([qrData canBeConvertedToEncoding:NSShiftJISStringEncoding]) {
                qrData = [NSString stringWithCString:[qrData cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSShiftJISStringEncoding];
            }
        }
        
        [dictionary setObject:qrData forKey:@"data"];
        [dictionary setObject:symbol.typeName forKey:@"type"];
        [proxy _fireEventToListener:@"success" withObject:dictionary listener:listener thisObject:nil];
    }
    
    /*
    // Don't close the scanner if continuous is true
    if(!continuous)
    {
        [UIApplication sharedApplication].statusBarHidden = NO;
        [NSThread sleepForTimeInterval:0.1f];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad && self.popover != nil) {
            [self.popover dismissPopoverAnimated:YES];
            [self setPopover:nil];
        }
        
        [reader dismissViewControllerAnimated:YES completion:nil];
    }
    */
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController*) imagePickerController
{
    NSLog(@"imagePickerControllerDidCancel:");
    
    if (cancelCallback != nil){
        id listener = [[cancelCallback retain] autorelease];
        
        // No data with Cancel
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [proxy _fireEventToListener:@"cancel" withObject:dictionary listener:listener thisObject:nil];
    }
    /*
    [UIApplication sharedApplication].statusBarHidden = NO;
    [NSThread sleepForTimeInterval:0.1f];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad && self.popover != nil) {
        [self.popover dismissPopoverAnimated:YES];
        [self setPopover:nil];
    }
     */
    
    // [reader dismissViewControllerAnimated:YES completion:nil];
    
    /* Removing support of iOS 4.x and older
     if ([reader respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]){
     [reader dismissViewControllerAnimated:YES completion:nil];
     } else {
     [reader dismissModalViewControllerAnimated: YES];
     }
     */
}

- (void) readerControllerDidFailToRead: (ZBarReaderController*) readerController
                             withRetry: (BOOL) retry
{
    NSLog([NSString stringWithFormat:@"readerControllerDidFailToRead: withRetry=%d", retry]);
    
    if (errorCallback != nil)
    {
        id listener = [[errorCallback retain] autorelease];
        
        // No data with error
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [proxy _fireEventToListener:@"error" withObject:dictionary listener:listener thisObject:nil];
    }
    
    /*
    // Don't close the scanner if continuous is true
    if(!continuous)
    {
        [UIApplication sharedApplication].statusBarHidden = NO;
        [NSThread sleepForTimeInterval:0.1f];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad && self.popover != nil) {
            [self.popover dismissPopoverAnimated:YES];
            [self setPopover:nil];
        }
        
        [reader dismissViewControllerAnimated:YES completion:nil];
    }
    */
}

- (void) continuous: (NSDictionary*)args
{
    if ([args objectForKey:@"continuous"] != nil)
    {
        [self setContinuous:[TiUtils boolValue:[args objectForKey:@"continuous"]]];
    }
    else
    {
        [self setContinuous:false];
    }
    
    NSLog([NSString stringWithFormat:@"continuous: %d", continuous]);
}

- (void) userControlLight: (NSDictionary*)args
{    
    if ([args objectForKey:@"userControlLight"] != nil)
    {
        NSLog([NSString stringWithFormat:@"userControlLight: %d", userControlLight]);
    }
    else
    {
        [self setUserControlLight:false];
    }
    
    [self setUserControlLight:[TiUtils boolValue:[args objectForKey:@"userControlLight"]]];
}

- (void) allowZoom: (NSDictionary*)args
{    
    if ([args objectForKey:@"allowZoom"] != nil)
    {
        [self setAllowZoom:[TiUtils boolValue:[args objectForKey:@"allowZoom"]]];
    }
    else
    {
        [self setAllowZoom:true];
    }
    
    NSLog([NSString stringWithFormat:@"allowZoom: %d", allowZoom]);
}

- (void) useFrontCamera: (NSDictionary*)args
{
    if ([args objectForKey:@"useFrontCamera"] != nil)
    {
        if([TiUtils boolValue:[args objectForKey:@"useFrontCamera"]])
        {
            [self setCameraDevice:UIImagePickerControllerCameraDeviceFront];
        }
        else
        {
            [self setCameraDevice:UIImagePickerControllerCameraDeviceRear];
        }
    }
    else
    {
        [self setCameraDevice:UIImagePickerControllerCameraDeviceRear];
    }
    
    NSLog([NSString stringWithFormat:@"cameraDevice: %d", cameraDevice]);
}

- (void) useJISEncoding: (NSDictionary*)args
{    
    if ([args objectForKey:@"useJISEncoding"] != nil)
    {
        [self setUseJISEncoding:[TiUtils boolValue:[args objectForKey:@"useJISEncoding"]]];
    }
    else
    {
        [self setUseJISEncoding:false];
    }
    
    NSLog([NSString stringWithFormat:@"useJISEncoding: %d", useJISEncoding]);
}

#pragma mark Cleanup

-(void)dealloc
{
    NSLog(@"Insided dealloc AcktieZbar");
    
	// release any resources that have been retained by the module
	[super dealloc];
}

@end
