interface cordova {
    plugins: CordovaPlugins
}

interface CordovaPlugins {
    ASCDVBarcode: ASCDVBarcode
}

interface ASCDVBarcode {
    /**
     * 
     * @param {Object} options 
     * @param {string} options.imageType 0: uri 1: base64
     * @param {string} options.uri
     * @param {string} options.base64
     * @param {*} success 
     * @param {*} error 
     */
    readBarcode(options: ReadOptions, success: (results: [string]) => void, error: (error: any) => void);
    scanBarcode(success: (results: [string]) => void, error: (error: any) => void);
}

interface ReadOptions {
    imageType: number,
    uri: string,
    base64: string
}