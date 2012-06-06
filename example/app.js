// Example of using Acktie Mobile QR

// Import
var qrreader = require("com.acktie.mobile.ios.qr");

// open a single window
var window = Ti.UI.createWindow({
	backgroundColor : 'white'
});

var qrFromAlbumButton = Titanium.UI.createButton({
	title : 'QR Code from Camera (Album)',
	height : 40,
	width : '100%',
	top : 5
});

qrFromAlbumButton.addEventListener('click', function() {
	qrreader.scanQRFromAlbum({
		success : success,
		cancel : cancel,
		error : error,
	});
});

window.add(qrFromAlbumButton);

var qrFromCameraButton = Titanium.UI.createButton({
	title : 'QR Code from Camera (Sampling)',
	height : 40,
	width : '100%',
	top : 50
});
qrFromCameraButton.addEventListener('click', function() {
	qrreader.scanQRFromCamera({
		overlay : {
			color : "blue",
			layout : "full",
		},
		success : success,
		cancel : cancel,
		error : error,
	});
});

window.add(qrFromCameraButton);

var qrFromManualCameraButton = Titanium.UI.createButton({
	title : 'QR Code from Camera (Manual Capture)',
	height : 40,
	width : '100%',
	top : 100
});
qrFromManualCameraButton.addEventListener('click', function() {
	qrreader.scanQRFromImageCapture({
		success : success,
		cancel : cancel,
		error : error,
	});
});

window.add(qrFromManualCameraButton);

window.open();

