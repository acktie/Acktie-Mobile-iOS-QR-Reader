# Acktie Mobile QR Module

## Description

This module allows for a quick integration of a QR reader into your Appcelerator Mobile application.  This QR reading ability comes in three scanning modes.

*  Scan from Camera Feed
*  Scan from Photo Album (user selected)
*  Read image from Camera image capture

Additionally, the Camera Feed option has the ability to provide an overlay on the feed.  Several colors and layout are provide by default with the module.  
Documented below are a list of the preloaded overlays.

At this time, it is only for Apple iOS.

**NOTE**: iPhone 3GS or higher is supported.

## Accessing the Acktie Mobile QR Module

To access this module from JavaScript, you would do the following:

	var qrreader = require("com.acktie.mobile.ios.qr");

The qr reader variable is a reference to the Module object.	

## Reference

The following are the Javascript functions you can call with the module.

All of the modules provide callbacks for:

*  success - Called in the event of a successful scan.  Callback data - This callback returns the data of the QR Code scan.

Example: 

	function success(data){
		var qrData = data.data;
	};

*  cancel - Called if the user clicks the cancel button.
*  error - Called if the scan was not successful in reading the QR code.

NOTE: Both cancel and error do not return data.

### scanQRFromAlbum

Scans a QR code from an image selected from the Photo Library

Example:

	scanQRFromAlbum(
	{
		success : success,
		cancel : cancel,
		error : error,
	});

### scanQRFromCamera

Automatically scans a QR code from the live Camera Feed

Example of Scanning from Camera without overlay:

	scanQRFromCamera(
	{
		success : success,
		cancel : cancel,
		error : error,
	});

Example of Scanning from Camera with overlay:

	scanQRFromCamera(
	{
		overlay: {
			color: "blue",
			layout: "full",
		},
		success : success,
		cancel : cancel,
		error : error,
	});

#### Valid overlay options

The following are the value JSON values for overlay.

##### color (optional):
*  blue
*  purple
*  red
*  yellow

##### layout (optional):
*  full
*  center

NOTE: Both color and layout must be specified together.

##### imageName (optional):
Use this property if you want to use your own overlay image.  See the customize overlay section for more details.

##### alpha (optional):
A float value between 0 - 1.  0 being fully transparent and 1 being fully visible.

Example:

alpha: 0.5  // half transparent

### scanQRFromImageCapture

Scans a QR code from an image taken from the Camera.  The user will have to manually click scan for the QR Code to be scanned.
For the most situations, it is better to use scanQRFromCamera.

NOTE:  This feature does not support overlay.

Example:

	scanQRFromImageCapture(
	{
		success : success,
		cancel : cancel,
		error : error,
	});

## Customize Overlay
In this module's subdirectory lives is a directory called assets.  It contains all of the images used in the overlay process.  
In order to customize the overlay you will need to do 2 things:

-  Place your custom image in the assets directory
-  Use the property "imageName" in the scanQRFromCamera arguments (see above).

Example:

	scanQRFromCamera(
	{
		overlay: {
			imageName: "myOverlay.png",
			alpha: 0.35f
		},
		success : success,
		cancel : cancel,
		error : error,
	});
	
NOTE: Specifying an imageName will override any color/layout that is also specified in the same overlay property. Meaning, when they are both specified imageName will take precedence.

However, alpha works on both regardless of what is used (color/layout or imageName).

Included in the example/images subdirectory is an example Photoshop file and .png files. 

NOTE: The overlay feature uses the standard @2x image name for high-res images (iPhone 4 and above). This give you the ability to support the non-retina and retina displays for your overlay. 

Here is a link to Apple's site for the support image types: [Link](http://developer.apple.com/library/ios/#documentation/uikit/reference/UIImage_Class/Reference/Reference.html)

## Known Issues:
In rare instances the QR reader does not properly decode QR codes that contain certain characters.  For example in some instances sharp s (00DF) gets decoded as a "half width katakana semi-voiced sound mark" (FF9F) and small o with diaeresis (00F6) turned into a rectangle character (E490).
To date these are the only characters that don't get properly decoded.  Also, it is only in certain circumstances. 

There is a workaround included in the app.js sample if this happens.  You can do a unicode replacement of the characters to the correct characters.

We are looking into how to fix this issue.

## Author

Tony Nuzzi @ Acktie

Twitter: @Acktie

Email: support@acktie.com
