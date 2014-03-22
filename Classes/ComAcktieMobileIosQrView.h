//
//  ComAcktieMobileIosQrView.h
//  acktie mobile qr ios
//
//  Created by Tony Nuzzi on 3/3/13.
//
//

#import "TiUIView.h"
#import "AcktieZbar.h"

@interface ComAcktieMobileIosQrQRCodeView : TiUIView <ZBarReaderDelegate>
{
    @protected ZBarReaderViewController *reader;
}

- (void) scanQR:(id)args;
- (void) toggleLight:(id)args;
- (void) stop:(id)args;

@end
