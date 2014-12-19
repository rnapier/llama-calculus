// Playground - noun: a place where people can play

import Foundation

let queryBase = "http://en.wikipedia.org/w/api.php?"
  + "action=opensearch&format=json&search="

func URLForSearch(search: String) -> NSURL? {
  if let encoded = search
    .stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
      return NSURL(string: queryBase + encoded)
  }
  return nil
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
  if let array = json as? [AnyObject] {
    if array.count == 2 {
      return array[1] as? [String]
    }
  }
  return nil
}

func pagesForSearch(search: String) -> [String]? {
  if let url = URLForSearch(search) {
    if let data = DataForURL(url) {
      if let json: AnyObject = JSONForData(data) {
        return ParseJSON(json)
      }}}
  return nil
}

pagesForSearch("Albert ")


