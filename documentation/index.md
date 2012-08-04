# Acktie Mobile QR Module

## Description

This module allows for a quick integration of a QR reader into your Appcelerator Mobile application.  This QR reading ability comes in three scanning modes.

*  Scan from Camera Feed
*  Scan from Photo Album (user selected)
*  Read image from Camera image capture

Additionally, the Camera Feed option has the ability to provide an overlay on the feed.  Several colors and layout are provide by default with the module.  
Documented below are a list of the preloaded overlays.

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
*  error - Called if the scan was not successful in reading the QR code. (Only called from Image Capture)

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

#### color (optional):
*  blue
*  purple
*  red
*  yellow

#### layout (optional):
*  full
*  center

NOTE: Both color and layout must be specified together.  Also, iPad does not have a "full" option and will default to "center".

#### imageName (optional):
Use this property if you want to use your own overlay image.  See the customize overlay section for more details.

#### alpha (optional):
A float value between 0 - 1.  0 being fully transparent and 1 being fully visible.

Example:

alpha: 0.5  // half transparent

#### allowZoom (optional):
This feature controls whether or not the user is allowed to use the pitch to zoom gesture.

Example:

allowZoom: false,

By default this value is true.

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

## Additional options:
These options apply to one to many of the above modes.

### Apply to all

#### continuous (optional):
This feature will continuously scan for QR codes even after one has been detected.  The user will have to click the "Done" button to exit the QR scan screen.
With each QR code that is detected the "success" event will be triggers so you program will be able to process each QR code.  Also, the application can use
the phone virate feature to indicate a scan took place.  See example app.js for details.

Example:

continuous: true,

By default this value is false.

#### useJISEncoding (optional):
This option is used to encode the QR code result with the Shift JIS encoding.  This is necessary when encoding Kanji Characters and UTF-8 is not sufficient.
By default the QR encoder will use UTF-8.  For most circumstances UTF-8 will work fine. 

Example:

useJISEncoding: true,

By default this value is false.

### Apply to scanQRFromCamera and scanQRFromImageCapture

#### userControlLight (optional):
This feature will presents the user an On/Off switch in which to control the flash/torch.  In scanQRFromCamera the light will be continuously on and in scanQRFromImageCapture
the light will flash when the picture is taken.

Example:

userControlLight: true,

By default this value is false.

*NOTE*: By not setting this variable or setting it to false will default the mode to auto, which means the camera will make the determination when to use the light.

## Customize Overlay
In this module's subdirectory lives is a directory called assets.  It contains all of the images used in the overlay process.  
In order to customize the overlay you will need to do 2 things:

-  Create a directory under your mobile app's "Resources" directory called "modules/com.acktie.mobile.android.qr".  This is the directory
   where you will put your custom images.
-  Use the property "imageName" in the scanQRFromCamera arguments (see above).

NOTE: In previous versions of the documention it instructed you to put your custom images in the module asset directory.  That is still valid.  However, we have made change to allow you
to place your custom images in your mobile application project.

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

## Change Log
*  1.0 Initial Release
*  1.1 Document encoding issue and other minor documentation, made toolbar less transparent, update app.js
*  1.2 Added a few features a customer requested.  Added Continuous Reader, ability for user to control the phone light, and disable pinch zoom.
*  1.3 Added iPad image examples.  Added ipad support for supplied overlays.
*  1.4 Added useJISEndoding option.

## Author

Tony Nuzzi @ Acktie

Twitter: @Acktie

Email: support@acktie.com
