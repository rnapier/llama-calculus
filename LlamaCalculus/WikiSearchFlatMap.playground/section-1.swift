// Playground - noun: a place where people can play

import Foundation

let queryBase = "http://en.wikipedia.org/w/api.php?"
    + "action=opensearch&format=json&search="

func URLForSearch(search: String) -> NSURL? {
    return search
        .stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        .flatMap { NSURL(string: queryBase + $0) }
}

func DataForURL(url: NSURL) -> NSData? {
    return NSURLConnection.sendSynchronousRequest(NSURLRequest(URL: url),
        returningResponse: nil, error: nil)
}

func JSONForData(data: NSData) -> AnyObject? {
    return NSJSONSerialization.JSONObjectWithData(data,
        options: NSJSONReadingOptions(0), error: nil)
}

func ParseJSON(json: AnyObject) -> [String]? {
    return (json as? [AnyObject])
        .flatMap { $0.count >= 2 ? $0 : nil }
        .flatMap { $0[1] as? [String] }
}

func pagesForSearch(search: String) -> [String]? {
    return URLForSearch(search)
        .flatMap(DataForURL)
        .flatMap(JSONForData)
        .flatMap(ParseJSON)
}

pagesForSearch("Albert ")
