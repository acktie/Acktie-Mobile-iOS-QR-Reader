/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "ComAcktieMobileIosQrModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiApp.h"

@implementation ComAcktieMobileIosQrModule

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

- (void) initControls: (ZBarReaderViewController*) readerView: (BOOL) showScanButton: (NSString *) scanButtonName
{    
    UIView *view = readerView.view;
    
    CGRect r = view.bounds;
    r.origin.y = r.size.height - 54;
    r.size.height = 54;
    controls = [[UIView alloc] initWithFrame: r];
    [controls setAlpha:0.75f];
    controls.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleTopMargin;
    controls.backgroundColor = [UIColor blackColor];
    
    UIToolbar *toolbar = [UIToolbar new];
    r.origin.y = 0;
    toolbar.frame = r;
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    if(showScanButton)
    {
        toolbar.items =
        [NSArray arrayWithObjects:
         [[[UIBarButtonItem alloc]
           initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
           target: self
           action: @selector(cancel)]
          autorelease],
         [[[UIBarButtonItem alloc]
           initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
           target: nil
           action: nil]
          autorelease],
         [[[UIBarButtonItem alloc]
           initWithTitle: scanButtonName
           style: UIBarButtonItemStyleDone
           target: self
           action: @selector(scan)]
          autorelease],
         [[[UIBarButtonItem alloc]
           initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
           target: nil
           action: nil]
          autorelease],
         nil];    
    }
    else
    {
        toolbar.items =
        [NSArray arrayWithObjects:
         [[[UIBarButtonItem alloc]
           initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
           target: self
           action: @selector(cancel)]
          autorelease],
         nil];    
    }
    
    [controls addSubview: toolbar];
    [toolbar release];
    
    [view addSubview: controls];
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
        [reader dismissModalViewControllerAnimated: YES];

    [controls release];
    controls = nil;
}

-(void)initScanner: (NSDictionary*) args: (NSString*) readerController: (ZBarReaderControllerCameraMode) cameraMode: (UIImagePickerControllerSourceType) sourceType: (BOOL) useOverlay
{
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
                overlayImageName = [NSString stringWithFormat:@"%@-%@.png", layout, color];
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
            
                // Configure reader
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
        
        [dictionary setObject:symbol.data forKey:@"data"];
        [dictionary setObject:symbol.typeName forKey:@"type"];             
        [self _fireEventToListener:@"success" withObject:dictionary listener:listener thisObject:nil];  
    }
    
    // dismiss the controller (NB: dismiss from the *picker*)
    [reader dismissModalViewControllerAnimated: YES];
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
    
    [reader dismissModalViewControllerAnimated: YES];
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
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
    
    [self initScanner:args :readerController :cameraMode :sourceType :useOverlay];
    
    [self show];
}
@end
