// Playground - noun: a place where people can play

import Foundation

let queryBase = "http://en.wikipedia.org/w/api.php?"
    + "action=opensearch&format=json&search="

func pagesForSearch(search: String) -> [String]? {
    if let
        encoded = search
            .stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding),
        url = NSURL(string: queryBase + encoded),
        data = NSURLConnection.sendSynchronousRequest(
            NSURLRequest(URL: url),
            returningResponse: nil,
            error: nil),
        json: AnyObject = NSJSONSerialization.JSONObjectWithData(
            data,
            options: NSJSONReadingOptions(0),
            error: nil),
        array = json as? [AnyObject] where array.count >= 2 {
            return array[1] as? [String]
    }
    return nil
}

pagesForSearch("Albert ")
