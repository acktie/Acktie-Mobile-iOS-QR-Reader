//
//  ComAcktieMobileIosQrViewProxy.h
//  acktie mobile qr ios
//
//  Created by Tony Nuzzi on 3/3/13.
//
//

#import "TiViewProxy.h"
#import "AcktieZbar.h"

@interface ComAcktieMobileIosQrQRCodeViewProxy : TiViewProxy
{
}

#pragma mark public API
@property(readwrite,retain) KrollCallback *successCallback;
@property(readwrite,retain) AcktieZbar* aZbar;
- (void) scanQR:(id)args;
- (void) turnLightOff:(id)args;
- (void) turnLightOn:(id)args;
- (void) stop:(id)args;

@end
