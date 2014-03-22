//
//  Zbar.h
//  acktie mobile qr ios
//
//  Created by Tony Nuzzi on 3/3/13.
//
//

#import <Foundation/Foundation.h>
#import "TiModule.h"
#import "TiUIViewProxy.h"
#import "TiUIButtonProxy.h"

@interface AcktieZbar : NSObject <UINavigationControllerDelegate, ZBarReaderDelegate>
{
    UIView *controls;
    UISwitch *lightSwitch;
}

@property(readwrite,retain) ZBarReaderViewController *reader;

@property(readwrite,retain) KrollCallback *successCallback;
@property(readwrite,retain) KrollCallback *errorCallback;
@property(readwrite,retain) KrollCallback *cancelCallback;
@property(readwrite,assign) BOOL continuous;
@property(readwrite,assign) BOOL userControlLight;
@property(readwrite,assign) BOOL allowZoom;
@property(readwrite,assign) BOOL useJISEncoding;

// Overlay
@property(readwrite,assign) BOOL overlay;
@property(readwrite,assign) float alpha;
@property(readwrite,retain) NSString* color;
@property(readwrite,retain) NSString* layout;
@property(readwrite,retain) NSString* imageName;

@property(readwrite,retain) TiViewProxy* proxy;
@property(readwrite,retain) UIBarButtonItem* navBarButton;
@property(readwrite,retain) UIPopoverController *popover;
@property(readwrite,assign) UIImagePickerControllerCameraDevice cameraDevice;

- (id)init: (NSDictionary*) withDictionary;
- (void) initReader: (NSString*) clsName;
- (UIImage *)imageNamed:(NSString *)name;
- (void) overlayColor: (NSDictionary*) overlay;
- (void) overlayLayout: (NSDictionary*) overlay;
- (void) overlayImageName: (NSDictionary*) overlay;
- (void) overlayAlpha: (NSDictionary*) overlay;
- (void) setCallbacks: (NSDictionary*)args;
- (void) initControls: (ZBarReaderViewController*)readerView showScanButton:(BOOL)showScanButton scanButtonName:(NSString *)scanButtonName;
- (void) turnLightOff;
- (void) turnLightOn;
- (void) toggleLight;
- (void) scan;
- (void) cancel;
- (void) initScanner: (NSString*)readerController cameraMode:(ZBarReaderControllerCameraMode)cameraMode sourceType:(UIImagePickerControllerSourceType)sourceType useOverlay:(BOOL)useOverlay cameraDeviceToUse:(UIImagePickerControllerCameraDevice)cameraDeviceToUse;
- (void) show;
- (void) imagePickerController: (UIImagePickerController*) imagePickerController
 didFinishPickingMediaWithInfo: (NSDictionary*) info;
- (void) imagePickerControllerDidCancel: (UIImagePickerController*) imagePickerController;
- (void) readerControllerDidFailToRead: (ZBarReaderController*) readerController
                             withRetry: (BOOL) retry;
- (void) continuous: (NSDictionary*)args;
- (void) userControlLight: (NSDictionary*)args;
- (void) allowZoom: (NSDictionary*)args;
- (void) useFrontCamera: (NSDictionary*)args;
- (void) useJISEncoding: (NSDictionary*)args;

@end
