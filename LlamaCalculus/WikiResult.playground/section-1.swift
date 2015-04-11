import Foundation
import Result

let queryBase = "http://en.wikipedia.org/w/api.php?"
    + "action=opensearch&format=json&search="

func mkError(message: String) -> NSError {
    return NSError(domain: "", code: 0,
        userInfo: [NSLocalizedDescriptionKey: message])
}

func URLForSearch(search: String) -> Result<NSURL, NSError> {
    return
        Result(search.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding),
            failWith: mkError("Malformed Search: \(search)"))

            >>- { Result(NSURL(string: queryBase + $0),
                failWith: mkError("Malformed URL: \($0)"))}
}

func DataForURL(url: NSURL) -> Result<NSData, NSError> {
    return try { error in
        NSURLConnection.sendSynchronousRequest(NSURLRequest(URL: url),
            returningResponse: nil, error: error)}
}

func JSONForData(data: NSData) -> Result<AnyObject, NSError> {
    return try { error in
        NSJSONSerialization.JSONObjectWithData(data,
            options: NSJSONReadingOptions(0), error: error)}
}

func ParseJSON(json: AnyObject) -> Result<[String], NSError> {
    return
        Result(json as? [AnyObject],               failWith: mkError("Expected array. Received: \(json)"))
            >>- { Result($0.count >= 2 ? $0 : nil, failWith: mkError("Array incorrect size: \($0)"))}
            >>- { Result($0[1] as? [String],       failWith: mkError("Malformed array: \($0)"))}
}

func pagesForSearch(search: String) -> Result<[String], NSError> {
    return URLForSearch(search)
        >>- DataForURL
        >>- JSONForData
        >>- ParseJSON
}

pagesForSearch("Albert ").description
