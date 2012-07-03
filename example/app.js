// Example of using Acktie Mobile QR

// Import
var qrreader = require("com.acktie.mobile.ios.qr");

// open a single window
var self = Ti.UI.createWindow({
	backgroundColor : 'white'
});

var qrFromAlbumButton = Titanium.UI.createButton({
	title : 'QR Code from Camera (Album)',
	height : 40,
	width : '100%',
	top : 10
});

qrFromAlbumButton.addEventListener('click', function() {
	qrreader.scanQRFromAlbum({
		success : success,
		cancel : cancel,
		error : error,
	});
});

self.add(qrFromAlbumButton);

var qrFromCameraButton = Titanium.UI.createButton({
	title : 'QR Code from Camera (Sampling)',
	height : 40,
	width : '100%',
	top : 60
});
qrFromCameraButton.addEventListener('click', function() {
	qrreader.scanQRFromCamera({
		overlay : {
			color : "blue",
			layout : "center",
		},
		success : success,
		cancel : cancel,
		error : error,
	});
});

self.add(qrFromCameraButton);

var qrFromCameraContButton = Titanium.UI.createButton({
	title : 'From Camera (Sampling Continuous)',
	height : 40,
	width : '100%',
	top : 110
});
qrFromCameraContButton.addEventListener('click', function() {
	qrreader.scanQRFromCamera({
		overlay : {
			color : "purple",
			layout : "center",
		},
		continuous : true,
		userControlLight : true,
		allowZoom : false,
		success : success,
		cancel : cancel,
		error : error,
	});
});

self.add(qrFromCameraContButton);

var qrFromManualCameraButton = Titanium.UI.createButton({
	title : 'QR Code from Camera (Manual Capture)',
	height : 40,
	width : '100%',
	top : 160
});
qrFromManualCameraButton.addEventListener('click', function() {
	qrreader.scanQRFromImageCapture({
		scanButtonName : 'Scan Code!',
		success : success,
		cancel : cancel,
		error : error,
	});
});

self.add(qrFromManualCameraButton);

var qrFromManualContCameraButton = Titanium.UI.createButton({
	title : 'Camera from Manual Capture (Continuous)',
	height : 40,
	width : '100%',
	top : 210
});
qrFromManualContCameraButton.addEventListener('click', function() {
	qrreader.scanQRFromImageCapture({
		scanButtonName : 'Keep Scanning!',
		continuous : true,
		userControlLight : true,
		success : success,
		cancel : cancel,
		error : error,
	});
});

self.add(qrFromManualContCameraButton);

function success(data) {
	if(data != undefined && data.data != undefined) {
		Titanium.Media.vibrate();
		alert(data.data);
	}
};

function cancel() {
	alert("Cancelled");
};

function error() {
	alert("error");
};

window.open();

/* Used to debug encoding issues
 function success(data) {
 if(data != undefined && data.data != undefined) {
 var newData = data.data.replace('\uFF9F', '\u00DF').replace('\uE490', '\u00F6');
 Ti.API.info(newData);
 Ti.API.info(toUnicode(newData));
 alert(newData);
 }
 };

 function toUnicode(theString) {
 var unicodeString = '';
 for (var i=0; i < theString.length; i++) {
 var char = theString.charAt(i);
 var theUnicode = theString.charCodeAt(i).toString(16).toUpperCase();
 while (theUnicode.length < 4) {
 theUnicode = '0' + theUnicode;
 }
 theUnicode = '\\u' + theUnicode;
 unicodeString += theUnicode + char;
 }
 return unicodeString;
 }
 */