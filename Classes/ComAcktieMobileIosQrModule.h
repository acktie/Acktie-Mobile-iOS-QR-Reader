/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "TiModule.h"

@interface ComAcktieMobileIosQrModule : TiModule <UINavigationControllerDelegate, ZBarReaderDelegate>
{
    @private ZBarReaderViewController *reader;
             KrollCallback *successCallback;
             KrollCallback *errorCallback;
             KrollCallback *cancelCallback;
    UIView *controls;
}

@end
