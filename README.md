# ASCDVBarcode

A cordova plugin for QRCode read.

## Features

1. read local QRCode image
2. scan barcode

## Usage

```js
// uri example
cordova.plugins.ASCDVBarcode.readBarcode(
  { imageType: 0, uri: image.substr('file://'.length) },
  results => {
    console.log(results);
  },
  error => {
    alert('read bar code error');
  }
);
// base64 example
cordova.plugins.ASCDVBarcode.readBarcode(
  { imageType: 1, base64: image },
  results => {
    console.log(results);
  },
  error => {
    alert('read bar code error');
  }
);
```

## API

### `ASCDVBarcode.readBarcode(options: ReadOptions, successCallback: (results: [string]) => void, errorCallback: (error) => void)`
read barcode from local file

### ReadOptions

| name      | type   | description                                                               |
| --------- | ------ | ------------------------------------------------------------------------- |
| imageType | string | 0: uri; 1: base64                                                         |
| uri       | string | if imageType == 0, set uri to image path. **don't prefix with `file://`** |
| base64    | string | if imageType == 1, set base64 to base64 string                            |

### `scanBarcode(success: (results: [string]) => void, error: (error: any) => void)`
open the camera and scan barcode