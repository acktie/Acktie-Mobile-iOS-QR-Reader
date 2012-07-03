//
//  ImageToPDF.h
//  acktie mobile qr ios
//
//  Created by Frank Nuzzi on 7/3/12.
//  Copyright (c) 2012 Paypal (An Ebay Company). All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ImageToPDF : NSObject {
    
}

+ (NSData *) convertImageToPDF: (UIImage *) image;
+ (NSData *) convertImageToPDF: (UIImage *) image withResolution: (double) resolution;
+ (NSData *) convertImageToPDF: (UIImage *) image withHorizontalResolution: (double) horzRes verticalResolution: (double) vertRes;
+ (NSData *) convertImageToPDF: (UIImage *) image withResolution: (double) resolution maxBoundsRect: (CGRect) boundsRect pageSize: (CGSize) pageSize;

@end
