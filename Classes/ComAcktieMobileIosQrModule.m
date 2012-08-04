/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import <AVFoundation/AVFoundation.h>
#import "ComAcktieMobileIosQrModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiApp.h"

@implementation ComAcktieMobileIosQrModule
@synthesize continuous;
@synthesize userControlLight;
@synthesize allowZoom;
@synthesize useJISEncoding;

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

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"daf68a87-c5c5-44b0-84ef-6498e75cbc1e";
}

// this is generated for your module, please do not change it
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

- (UIImage *)imageNamed:(NSString *)name {    
    NSString *path = [NSString stringWithFormat:@"modules/%@/%@", [self moduleId], name];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", 
                           [[[NSURL fileURLWithPath:path] absoluteString] stringByReplacingOccurrencesOfString:path withString:@""], 
                           [[NSBundle mainBundle] resourcePath], 
                           path, nil];
    NSLog(urlString);
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation]];
    
    return [UIImage imageWithData:[[NSData alloc] initWithContentsOfURL:url]];
}

-(NSString*) overlayColor: (NSDictionary*) overlay
{
    NSString *color = [TiUtils stringValue:[overlay objectForKey:@"color"]];
    NSLog([NSString stringWithFormat:@"%@ %@", @"color:", color]);
    
    NSString* overLayColor = nil;
    if ([color caseInsensitiveCompare:@"blue"] == NSOrderedSame) {
        overLayColor = @"Blue";
    }
    else if ([color caseInsensitiveCompare:@"purple"] == NSOrderedSame) {
        overLayColor = @"Purple";
    }
    else if ([color caseInsensitiveCompare:@"red"] == NSOrderedSame) {
        overLayColor = @"Red";
    }
    else if ([color caseInsensitiveCompare:@"yellow"] == NSOrderedSame) {
        overLayColor = @"Yellow";
    }
    
    return overLayColor;
}

-(NSString*) overlayLayout: (NSDictionary*) overlay
{
    NSString *layout = [TiUtils stringValue:[overlay objectForKey:@"layout"]];
    NSLog([NSString stringWithFormat:@"%@ %@", @"layout:", layout]);
    
    NSString* overlayLayout = nil;
    if ([layout caseInsensitiveCompare:@"center"] == NSOrderedSame) {
        overlayLayout = @"Center";
    }
    else if ([layout caseInsensitiveCompare:@"full"] == NSOrderedSame) {
        overlayLayout = @"FullScreen";
    }
    
    return overlayLayout;
}

-(NSString*) overlayImageName: (NSDictionary*) overlay
{
    NSString *imageName = [TiUtils stringValue:[overlay objectForKey:@"imageName"]];
    NSLog([NSString stringWithFormat:@"%@ %@", @"imageName:", imageName]);
    
    return imageName;
}

-(float) overlayAlpha: (NSDictionary*) overlay
{
    float alpha = [TiUtils floatValue:[overlay objectForKey:@"alpha"] def:1.0f];
    NSLog([NSString stringWithFormat:@"%@ %d", @"alpha:", alpha]);
    
    return alpha;
}

- (id) setCallbacks: (NSDictionary*)args
{
    // callbacks
    if ([args objectForKey:@"success"] != nil)
    {
        NSLog(@"Received success callback");
        
        successCallback = [args objectForKey:@"success"];
        ENSURE_TYPE_OR_NIL(successCallback,KrollCallback);
        [successCallback retain];
    }
    
    if ([args objectForKey:@"error"] != nil) 
    {
        NSLog(@"Received error callback");
        
        errorCallback = [args objectForKey:@"error"];
        ENSURE_TYPE_OR_NIL(errorCallback,KrollCallback);
        [errorCallback retain];
    }
    
    if ([args objectForKey:@"cancel"] != nil) 
    {
        NSLog(@"Received cancel callback");
        
        cancelCallback = [args objectForKey:@"cancel"];
        ENSURE_TYPE_OR_NIL(cancelCallback,KrollCallback);
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

- (void) initControls: (ZBarReaderViewController*) readerView: (BOOL) showScanButton: (NSString *) scanButtonName
{    
    UIView *view = readerView.view;
    
    CGRect r = view.bounds;
    r.origin.y = r.size.height - 54;
    r.size.height = 54;
    controls = [[UIView alloc] initWithFrame: r];
    controls.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];

    [controls setAlpha:0.75f];
    controls.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleTopMargin;
    controls.backgroundColor = [UIColor blackColor];
    
    UIToolbar *toolbar = [UIToolbar new];
    toolbar.translucent = true;
    r.origin.y = 0;
    toolbar.frame = r;
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UIBarButtonSystemItem button = 0;
    
    if(continuous)
    {
        button = UIBarButtonSystemItemDone;
    }
    else
    {
        button = UIBarButtonSystemItemCancel;
    }
    
    NSMutableArray *toolBarItems = [[NSMutableArray alloc] init];
    [toolBarItems addObject:[[[UIBarButtonItem alloc]
                              initWithBarButtonSystemItem: button
                              target: self
                              action: @selector(cancel)]
                             autorelease]];
    [toolBarItems addObject:[self flexSpace]];
    if(showScanButton)
    {
        [toolBarItems addObject:[[[UIBarButtonItem alloc]
                                  initWithTitle: scanButtonName
                                  style: UIBarButtonItemStyleDone
                                  target: self
                                  action: @selector(scan)]
                                 autorelease]];
        
        [toolBarItems addObject:[self flexSpace]];
    }
    
    if (userControlLight) 
    {
        lightSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [lightSwitch addTarget:self action:@selector(toggleLight) forControlEvents:UIControlEventValueChanged];
        
        [toolBarItems addObject:[[[UIBarButtonItem alloc]
                                  initWithCustomView:lightSwitch]
                                 autorelease]];
    }

    toolbar.items = toolBarItems;
    [controls addSubview: toolbar];
    [toolbar release];
        
    [view addSubview: controls];
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
    else
    {
        [UIApplication sharedApplication].statusBarHidden = NO; 
        [NSThread sleepForTimeInterval:0.1f];
        [reader dismissModalViewControllerAnimated: YES];
    }
        
    [controls release];
    controls = nil;
}

-(void)initScanner: (NSDictionary*) args: (NSString*) readerController: (ZBarReaderControllerCameraMode) cameraMode: (UIImagePickerControllerSourceType) sourceType: (BOOL) useOverlay
{
    // 
    [self useJISEncoding:args];
    
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
    
    if ([reader isKindOfClass:[ZBarReaderViewController class]]) 
    {
        if(allowZoom)
        {
            reader.readerView.allowsPinchZoom = true;
        }
        else
        {
            reader.readerView.allowsPinchZoom = false;
        }
    }
    
    if(userControlLight)
    {
        // Default the light to off
        [self turnLightOff];
    }
    
    if(useOverlay)
    {
        if ([args objectForKey:@"overlay"] != nil) {
            NSDictionary* overlay = [args objectForKey:@"overlay"];
            NSLog(@"overlay");
        
            NSString* color = [self overlayColor:overlay];
            NSString* layout = [self overlayLayout:overlay];
        
            NSString* overlayImageName = nil;
            
            if(color != nil && layout != nil)
            {
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
                {
                    overlayImageName = [NSString stringWithFormat:@"Center-%@-ipad.png", color];
                }
                else
                {
                    overlayImageName = [NSString stringWithFormat:@"%@-%@.png", layout, color];
                }
            }
        
            NSString* imageName = [self overlayImageName:overlay];
            if(imageName != nil)
            {
                overlayImageName = [NSString stringWithString:imageName];
            }
        
            if(overlayImageName != nil)
            {
                // Add Image overlay
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[self imageNamed:overlayImageName]];
                imageView.backgroundColor = [UIColor clearColor];
                imageView.alpha = [self overlayAlpha:overlay];
                
                reader.cameraOverlayView = imageView;
            }
        }
    }
    
    
    [reader setTracksSymbols: NO];
    [reader setShowsHelpOnFail: NO];
    
    // callbacks
    [self setCallbacks:args];
}

-(void) show
{
    // show
    TiApp* tiApp = [TiApp app];
    [tiApp showModalController:reader animated:YES];
}

// ZBarReaderDelegate Methods
// Define Block variable to tests out different encodings
void (^tryGetCStringUsingEncoding)(NSString*, NSStringEncoding) = ^(NSString* originalNSString, NSStringEncoding encoding) {
    NSLog(@"Trying to convert \"%@\" using encoding: 0x%X", originalNSString, encoding);
    BOOL canEncode = [originalNSString canBeConvertedToEncoding:encoding];
    if (!canEncode)
    {
        NSLog(@"    Can not encode \"%@\" using encoding %X", originalNSString, encoding);
    }
    else
    {
        // Try encoding using NSString getCString:maxLength:encoding:
        NSUInteger cStrLength = [originalNSString lengthOfBytesUsingEncoding:encoding];
        char cstr[cStrLength];
        [originalNSString getCString:cstr maxLength:cStrLength encoding:encoding];
        NSLog(@"    Converted(1): \"%s\"  (expected length: %u)",
              cstr, cStrLength);
        
        // Try encoding using NSString dataUsingEncoding:allowLossyConversion:          
        NSData *strData = [originalNSString dataUsingEncoding:encoding allowLossyConversion:YES];
        char cstr2[[strData length] + 1];
        memcpy(cstr2, [strData bytes], [strData length] + 1);
        cstr2[[strData length]] = '\0';
        NSLog(@"    Converted(2): \"%s\"  (expected length: %u)",
              cstr2, [strData length]);
    }
};

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
        
        /*  Debugging encoding issues
        tryGetCStringUsingEncoding(qrData, NSUTF8StringEncoding);
        tryGetCStringUsingEncoding(qrData, NSUTF16StringEncoding);
        tryGetCStringUsingEncoding(qrData, NSUTF32StringEncoding);
        tryGetCStringUsingEncoding(qrData, NSShiftJISStringEncoding);
         */
        
        // If true try to encode string with ShiftJIS (use by Chinese and Kanji)
        if([self useJISEncoding])
        {
            if ([qrData canBeConvertedToEncoding:NSShiftJISStringEncoding]) { 
                qrData = [NSString stringWithCString:[qrData cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSShiftJISStringEncoding]; 
            }   
        }
        
        [dictionary setObject:qrData forKey:@"data"];
        [dictionary setObject:symbol.typeName forKey:@"type"];             
        [self _fireEventToListener:@"success" withObject:dictionary listener:listener thisObject:nil];  
    }
    
    // Don't close the scanner if continuous is true
    if(!continuous)
    {
        [UIApplication sharedApplication].statusBarHidden = NO; 
        [NSThread sleepForTimeInterval:0.1f];
        [reader dismissModalViewControllerAnimated: YES];
    }    
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController*) imagePickerController
{
    NSLog(@"imagePickerControllerDidCancel:");
    
    if (cancelCallback != nil){
        id listener = [[cancelCallback retain] autorelease];
        
        // No data with Cancel
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [self _fireEventToListener:@"cancel" withObject:dictionary listener:listener thisObject:nil];   
    }
    
    [UIApplication sharedApplication].statusBarHidden = NO; 
    [NSThread sleepForTimeInterval:0.1f];
    [reader dismissModalViewControllerAnimated: YES];
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
        [self _fireEventToListener:@"error" withObject:dictionary listener:listener thisObject:nil];    
    }
    
    // Don't close the scanner if continuous is true
    if(!continuous)
    {
        [UIApplication sharedApplication].statusBarHidden = NO; 
        [NSThread sleepForTimeInterval:0.1f];
        [reader dismissModalViewControllerAnimated: YES];
    }
}

- (void) continuous: (id)args
{
    ENSURE_SINGLE_ARG_OR_NIL(args, NSDictionary);
    
    if ([args objectForKey:@"continuous"] != nil) 
    {
        [self setContinuous:[TiUtils boolValue:[args objectForKey:@"continuous"]]];
        NSLog([NSString stringWithFormat:@"continuous: %d", continuous]);
    }
    else
    {
        [self setContinuous:false];
    }
}

- (void) userControlLight: (id)args
{
    ENSURE_SINGLE_ARG_OR_NIL(args, NSDictionary);
    
    if ([args objectForKey:@"userControlLight"] != nil) 
    {
        [self setUserControlLight:[TiUtils boolValue:[args objectForKey:@"userControlLight"]]];
        NSLog([NSString stringWithFormat:@"userControlLight: %d", userControlLight]);
    }
    else
    {
        [self setUserControlLight:false];
    }
}

- (void) allowZoom: (id)args
{
    ENSURE_SINGLE_ARG_OR_NIL(args, NSDictionary);
    
    if ([args objectForKey:@"allowZoom"] != nil) 
    {
        [self setAllowZoom:[TiUtils boolValue:[args objectForKey:@"allowZoom"]]];
        NSLog([NSString stringWithFormat:@"allowZoom: %d", allowZoom]);
    }
    else
    {
        [self setAllowZoom:true];
    }
}

- (void) useJISEncoding: (id)args
{
    ENSURE_SINGLE_ARG_OR_NIL(args, NSDictionary);
    
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

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
    [self setContinuous:false];
    [self setUserControlLight:false];
    [self setAllowZoom:true];
	
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma Public APIs

-(void)scanQRFromCamera:(id)args
{
    NSLog(@"scanQRFromCamera");
    ENSURE_UI_THREAD(scanQRFromCamera, args);
    ENSURE_SINGLE_ARG_OR_NIL(args, NSDictionary);
    
    NSString* readerController = @"ZBarReaderViewController";
    ZBarReaderControllerCameraMode cameraMode = ZBarReaderControllerCameraModeSampling;
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    BOOL useOverlay = true;
    
    [self continuous:args];
    [self userControlLight:args];
    [self allowZoom:args];
    [self initScanner:args :readerController :cameraMode :sourceType :useOverlay];
    
    // Use custom controls
    reader.showsZBarControls = NO;
    [self initControls:reader :false :nil];
    
    [self show];
}

-(void)scanQRFromImageCapture:(id)args
{
    NSLog(@"scanQRFromImageCapture");
    ENSURE_UI_THREAD(scanQRFromImageCapture, args);
    ENSURE_SINGLE_ARG_OR_NIL(args, NSDictionary);
    
    NSString* readerController = @"ZBarReaderController";
    ZBarReaderControllerCameraMode cameraMode = ZBarReaderControllerCameraModeDefault;
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    BOOL useOverlay = false;
    NSString* scanButtonName = @"Scan";
    
    if ([args objectForKey:@"scanButtonName"] != nil) 
    {
        NSString* name = [args objectForKey:@"scanButtonName"];
        NSLog([NSString stringWithFormat:@"scanButtonName: %@", name]);
        
        scanButtonName = [NSString stringWithString:name];
    }
    
    [self continuous:args];
    [self userControlLight:args];
    [self initScanner:args :readerController :cameraMode :sourceType :useOverlay];
    
    reader.showsZBarControls = NO;
    reader.showsCameraControls = NO;
    [self initControls:reader :true :scanButtonName];

    
    [self show];
}

-(void)scanQRFromAlbum: (id)args
{
    NSLog(@"scanQRFromAlbum");
    ENSURE_UI_THREAD(scanQRFromAlbum, args);
    ENSURE_SINGLE_ARG_OR_NIL(args, NSDictionary);
    
    NSString* readerController = @"ZBarReaderController";
    ZBarReaderControllerCameraMode cameraMode = ZBarReaderControllerCameraModeDefault;
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    BOOL useOverlay = false;
    
    [self continuous:args];
    [self initScanner:args :readerController :cameraMode :sourceType :useOverlay];
    
    [self show];
}
@end
