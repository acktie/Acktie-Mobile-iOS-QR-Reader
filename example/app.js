var qrreader = undefined;
var qrCodeWindow = undefined;
var qrCodeView = undefined;

if (Ti.Platform.osname === 'iphone' || Ti.Platform.osname === 'ipad') {
	qrreader = require('com.acktie.mobile.ios.qr');
} else if (Ti.Platform.osname === 'android') {
	qrreader = require('com.acktie.mobile.android.qr');
}

//create object instance, a parasitic subclass of Observable
var self = Ti.UI.createWindow({backgroundColor: 'white'});

var qrFromAlbumButton = Titanium.UI.createButton({
	title : 'QR Code from Camera (Album)',
	height : 40,
	width : '100%',
	top : 10
});

qrFromAlbumButton.addEventListener('click', function() {
	// Android does not currently support reading from the Image Gallery
	if (Ti.Platform.osname === 'iphone' || Ti.Platform.osname === 'ipad') {
		qrreader.scanQRFromAlbum({
			success : success,
			cancel : cancel,
			error : error,
		});
	} else if (Ti.Platform.osname === 'android') {
		alert("Scanning from Image Gallery is not support on Android");
	}
});

self.add(qrFromAlbumButton);

var qrFromCameraButton = Titanium.UI.createButton({
	title : 'QR Code from Camera (Sampling)',
	height : 40,
	width : '100%',
	top : 60
});
qrFromCameraButton.addEventListener('click', function() {
	var options = {
		// ** Android QR Reader properties (ignored by iOS)
		backgroundColor : 'black',
		width : '100%',
		height : '90%',
		top : 0,
		left : 0,
		// **

		// ** Used by both iOS and Android
		overlay : {
			color : "blue",
			layout : "center",
			alpha : .75
		},
		success : success,
		cancel : cancel,
		error : error,
	};

	if (Ti.Platform.name == "android") {
		scanQRFromCamera(options);
	} else {
		qrreader.scanQRFromCamera(options);
	}
});

self.add(qrFromCameraButton);

var qrFromCameraContButton = Titanium.UI.createButton({
	title : 'From Camera (Sampling Continuous)',
	height : 40,
	width : '100%',
	top : 110
});
qrFromCameraContButton.addEventListener('click', function() {
	var options = {
		// ** Android QR Reader properties (ignored by iOS)
		backgroundColor : 'black',
		width : '100%',
		height : '90%',
		top : 0,
		left : 0,
		// **

		// ** Used by iOS (allowZoom/userControlLight ignored on Android)
		userControlLight : true,
		allowZoom : false,

		// ** Used by both iOS and Android
		overlay : {
			imageName : 'exampleBranding.png',
		},
		continuous : true,
		success : success,
		cancel : cancel,
		error : error,
	};

	if (Ti.Platform.name == "android") {
		scanQRFromCamera(options);
	} else {
		qrreader.scanQRFromCamera(options);
	}
});

self.add(qrFromCameraContButton);

var qrFromManualCameraButton = Titanium.UI.createButton({
	title : 'QR Code from Camera (Manual Capture)',
	height : 40,
	width : '100%',
	top : 160
});
qrFromManualCameraButton.addEventListener('click', function() {
	var options = {
		// ** Android QR Reader properties (ignored by iOS)
		backgroundColor : 'black',
		width : '100%',
		height : '90%',
		top : 0,
		left : 0,
		scanQRFromImageCapture : true,
		overlay : {
			color : "purple",
			layout : "center",
			alpha : .75
		},
		// **

		// ** Used by both iOS and Android
		scanButtonName : 'Scan Code!',
		success : success,
		cancel : cancel,
		error : error,
	};

	if (Ti.Platform.name == "android") {
		scanQRFromImageCapture(options);
	} else {
		qrreader.scanQRFromImageCapture(options);
	}
});

self.add(qrFromManualCameraButton);

var qrFromManualContCameraButton = Titanium.UI.createButton({
	title : 'Camera from Manual Capture (Continuous)',
	height : 40,
	width : '100%',
	top : 210
});
qrFromManualContCameraButton.addEventListener('click', function() {
	var options = {
		// ** Android QR Reader properties (ignored by iOS)
		backgroundColor : 'black',
		width : '100%',
		height : '90%',
		top : 0,
		left : 0,
		scanQRFromImageCapture : true,
		overlay : {
			color : "red",
			layout : "center",
		},
		// **

		// ** Used by iOS (allowZoom/userControlLight ignored on Android)
		continuous : true,
		userControlLight : true,
		// **

		// ** Used by both iOS and Android
		scanButtonName : 'Keep Scanning!',
		success : success,
		cancel : cancel,
		error : error,
	};

	if (Ti.Platform.name == "android") {
		scanQRFromImageCapture(options);
	} else {
		qrreader.scanQRFromImageCapture(options);
	}
});

self.add(qrFromManualContCameraButton);

function success(data) {
	Titanium.Media.vibrate();
	alert(data.data);
};

function cancel() {
	alert("Cancelled");
};

function error() {
	alert("error");
};

/*
 * Function that mimics the iPhone QR Code reader behavior.
 */
function scanQRFromCamera(options) {
	qrCodeWindow = Titanium.UI.createWindow({
		backgroundColor : 'black',
		width : '100%',
		height : '100%',
	});
	qrCodeView = qrreader.createQRCodeView(options);

	var closeButton = Titanium.UI.createButton({
		title : "close",
		bottom : 0,
		left : 0
	});
	var lightToggle = Ti.UI.createSwitch({
		value : false,
		bottom : 0,
		right : 0
	});

	closeButton.addEventListener('click', function() {
		qrCodeView.stop();
		qrCodeWindow.close();
	});

	lightToggle.addEventListener('change', function() {
		qrCodeView.toggleLight();
	})

	qrCodeWindow.add(qrCodeView);
	qrCodeWindow.add(closeButton);

	if (options.userControlLight != undefined && options.userControlLight) {
		qrCodeWindow.add(lightToggle);
	}

	// NOTE: Do not make the window Modal.  It screws stuff up.  Not sure why
	qrCodeWindow.open();
}

/*
 * Function that mimics the iPhone QR Code reader behavior.
 */
function scanQRFromImageCapture(options) {

	qrCodeWindow = Titanium.UI.createWindow({
		backgroundColor : 'black',
		width : '100%',
		height : '100%',
	});
	qrCodeView = qrreader.createQRCodeView(options);

	var closeButton = Titanium.UI.createButton({
		title : "close",
		bottom : 0,
		left : 0
	});

	var scanQRCode = Titanium.UI.createButton({
		title : options.scanButtonName,
		bottom : 0,
		left : '50%'
	});

	var lightToggle = Ti.UI.createSwitch({
		value : false,
		bottom : 0,
		right : 0
	});

	closeButton.addEventListener('click', function() {
		qrCodeView.stop();
		qrCodeWindow.close();
	});

	scanQRCode.addEventListener('click', function() {
		qrCodeView.scanQR();
	});

	lightToggle.addEventListener('change', function() {
		qrCodeView.toggleLight();
	})

	qrCodeWindow.add(qrCodeView);
	qrCodeWindow.add(scanQRCode);
	qrCodeWindow.add(closeButton);

	if (options.userControlLight != undefined && options.userControlLight) {
		qrCodeWindow.add(lightToggle);
	}

	// NOTE: Do not make the window Modal.  It screws stuff up.  Not sure why
	qrCodeWindow.open();
}

if (Ti.Platform.osname === 'android') {
	var activity = Ti.Android.currentActivity;
	activity.addEventListener('pause', function(e) {
		Ti.API.info('Inside pause');
		if (qrCodeView != undefined) {
			qrCodeView.stop();
		}

		if (qrCodeWindow != undefined) {
			qrCodeWindow.close();
		}
	});
}

self.open();