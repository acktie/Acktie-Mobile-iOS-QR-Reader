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
	top : 10
});

// Open Photo Album to choose image with QR code
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
	top : 60
});

// Launch Camera Feed and detect QR Code
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
	top : 110
});

// Launch Camera and have use manually take picture of QR Code
qrFromManualCameraButton.addEventListener('click', function() {
	qrreader.scanQRFromImageCapture({
		success : success,
		cancel : cancel,
		error : error,
	});
});

function success(data) {
	if(data != undefined && data.data != undefined) {
		alert(data.data);
	}
};

function cancel() {
	alert("Cancelled");
};

function error() {
	alert("error");
};

function success(data) {
	if(data != undefined && data.data != undefined) {
		alert(data.data);
	}
};

function cancel() {
	alert("Cancelled");
};

function error() {
	alert("error");
};

window.add(qrFromManualCameraButton);

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