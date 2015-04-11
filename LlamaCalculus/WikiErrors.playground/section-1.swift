import Foundation

let queryBase = "http://en.wikipedia.org/w/api.php?"
    + "action=opensearch&format=json&search="

func mkError(message: String) -> NSError {
    return NSError(domain: "", code: 0,
        userInfo: [NSLocalizedDescriptionKey: message])
}

func err<T>(err: NSErrorPointer, message: String) -> T? {
    if err != nil { err.memory = mkError(message) }
    return nil
}

func err(err: NSErrorPointer, message: String) -> Bool {
    if err != nil { err.memory = mkError(message) }
    return false
}

func URLForSearch(search: String, #error: NSErrorPointer) -> NSURL? {
    if let
        encoded = search
            .stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            ?? err(error, "Malformed Search: \(search)") {

                return NSURL(string: queryBase + encoded)
                    ?? err(error, "Malformed URL: \(encoded)")
    }
    return nil
}

func DataForURL(url: NSURL, #error: NSErrorPointer) -> NSData? {
    return NSURLConnection.sendSynchronousRequest(NSURLRequest(URL: url),
        returningResponse: nil, error: error)
}

func JSONForData(data: NSData, #error: NSErrorPointer) -> AnyObject? {
    return NSJSONSerialization.JSONObjectWithData(data,
        options: NSJSONReadingOptions(0), error: error)
}

func ParseJSON(json: AnyObject, #error: NSErrorPointer) -> [String]? {
    if  let array = json as? [AnyObject] ?? err(error, "Expected array. Received: \(json)")
        where array.count >= 2           || err(error, "Array incorrect size: \(array)") {
            return array[1] as? [String] ?? err(error, "Malformed array: \(array)")
    }
    return nil
}

func pagesForSearch(search: String, #error: NSErrorPointer) -> [String]? {
    if let
        url             = URLForSearch(search, error: error),
        data            = DataForURL(url, error: error),
        json: AnyObject = JSONForData(data, error: error) {
            return ParseJSON(json, error: error)
    }
    return nil
}

var error: NSError?
pagesForSearch("Albert ", error: &error)
error
