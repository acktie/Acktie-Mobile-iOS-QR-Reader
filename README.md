# Acktie Mobile QR Reader Module (iOS) for 2.0

**NOTE:** This documentation is for 2.0 which allow for the creating of the scanner from a view. The overlay functionality will be deprecated and removed in future releases. Our goal is to simplify the scanner and allow you to create an awesome mobile experience with our modules. Previous releases documentation: [http://www.acktie.com/documentation-and-examples/acktie-mobile-qr-reader-module-ios-prior-to-2-0/](http://www.acktie.com/documentation-and-examples/acktie-mobile-qr-reader-module-ios-prior-to-2-0/)

## Example

A working example of how to use this module can be found on Github at
[https://github.com/acktie/Acktie-Mobile-QR-Example](https://github.com/acktie
/Acktie-Mobile-QR-Example).

## Description

This module allows for a quick integration of a QR reader into your
Appcelerator Mobile application. This QR reading ability comes in three
scanning modes.

  * Scan from Camera Feed
  * Scan from Photo Album (user selected)
**NOTE**: iPhone 3GS or higher is supported. 

## Accessing the Acktie Mobile QR Module

To get started, review the [module install instructions](http://docs.appcelera
tor.com/titanium/2.0/#!/guide/Using_Titanium_Modules) on the Appcelerator
website. To access this module from JavaScript, you would do the following:

    
    var qrreader = require("com.acktie.mobile.ios.qr"); 

The qr reader variable is a reference to the Module object.

## Reference

The following are the Javascript functions you can call with the module. Both
functions scanQRFromAlbum and createQRView provide callbacks for:

  * success - Called in the event of a successful scan. Callback data - This callback returns the data of the QR Code scan.
Example:

    
    function success(data){ var qrData = data.data; }; 

  * cancel - Called if the user clicks the cancel button.
  * error - Called if the scan was not successful in reading the QR code. (**Only scanQRFromAlbum**)
NOTE: Both cancel and error do not return data.

### scanQRFromAlbum

Scans a QR code from an image selected from the Photo Library Example:

    
    qrreader.scanQRFromAlbum( { success : success, cancel : cancel, error : error, }); 

#### view or navBarButton

For **iPad Only**, you need to specify an view (which could be a button, table
cell, or an actual view) or a button in the navigation bar (the button
assigned to a window's rightnavbutton or leftnavbutton) in order to use the
scanQRFromAlbum feature. This will provide a popover that will show a list of
existing photos to choose the QR from. _NOTE:_ you must specify a view or a
navBarButton but not both. Also, specifying either value on an iPhone will be
ignored, so it is safe to specify the values without having to test for the
platform.

# Creating the QR Scanning view

The following syntax is used to create a new QR scanneing view. The QR module
will create a Titanium compatible view that allow you to attach it where any
view is allowed.

    
    var view = qrreader.createQRView({...});

## createQRView Arguments

These options apply to one to many of the above modes.

#### useFrontCamera (optional):

This option is used to enable the camera view to use the front facing camera.
NOTE: Most (if not all), front facing cameras are a fixed focus camera that
will not auto-focus on an object. This can result in a lower read success rate
for scanning in low light. Take this into consideration when developing your
app. Example: useFrontCamera: true, By default this value is false and to the
back camera.

#### useJISEncoding (optional):

This option is used to encode the QR code result with the Shift JIS encoding.
This is necessary when encoding Kanji Characters and UTF-8 is not sufficient.
By default the QR encoder will use UTF-8. For most circumstances UTF-8 will
work fine. Example: useJISEncoding: true, By default this value is false.

## createQRView Functions

#### stop()

This function will stop the active scanner from scanning and close the view.
If an app requires an experience where the user presses a cancel button be
sure to call the stop() function on the QR scanning view. Calling the stop()
function will trigger the cancel callback.

#### turnLightOn()/turnLightOff()

These functions are used to turn the devices light on for scanning. These
function allow for use in an UI element such as a Switch. However, an app may,
by design, restrict or always turn on the device's light. If the device does
not have a light nothing happens.

## Known Issues:

The core QR Code reader uses UTF-8 to decode the QR code. There have been
instances where characters have been mistranslated (this only applies to
Chinses, Japanses, and German characters). To ensure your QR code is
transalated correctly. It is advised that you encode your QR Codes with a
UTF-8 Byte order mark (BOM). Here is of an example of using Kaywa to specify
the UTF-8 BOM. http://qr.kaywa.com/img.php?s=8&amp;d=%EF%BB%BF Example: http://qr.
kaywa.com/img.php?s=8&amp;d=%EF%BB%BF{%22name%22:%22%E7%8E%89%E7%B1%B3%22}

## Change Log

  * 1.0 Initial Release
  * 1.1 Document encoding issue and other minor documentation, made toolbar less transparent, update app.js
  * 1.2 Added a few features a customer requested. Added Continuous Reader, ability for user to control the phone light, and disable pinch zoom.
  * 1.3 Added iPad image examples. Added ipad support for supplied overlays.
  * 1.4 Added useJISEndoding option.
  * 1.5 Fixed an issue where the customized overlay images were not using the Retina images.
  * 1.6 Added better support for Scan from Album on the iPad
  * 1.7 iOS 6 support
  * 1.8 Front Facing Camera Support, Fixed an issue where apps were not build when using Ti Store Kit
  * 2.0 Simplified the QR code scanner. Scanning window is now created via the createQRView.

## Author

Tony Nuzzi @ Acktie 
Twitter: @Acktie 
Email: support@acktie.com

Code licensed under Apache License v2.0, documentation under CC BY 3.0.

Libaries Used:

Portions of this software utilize the ZBar bar code reader:
  For more information you can go to: http://zbar.sourceforge.net/

Attribution is welcome but not required.

