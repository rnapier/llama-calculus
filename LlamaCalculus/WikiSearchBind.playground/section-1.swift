// Playground - noun: a place where people can play

import Foundation

let queryBase = "http://en.wikipedia.org/w/api.php?"
  + "action=opensearch&format=json&search="

extension Optional {
  func flatMap<U>(f: T -> U?) -> U? {
    if let x = self {
      return f(x)
    }
    return nil
  }
}

infix operator >>== { associativity left }
func >>== <T,U>(lhs: T?, rhs: T -> U?) -> U? {
  return lhs.flatMap(rhs)
}

func URLForSearch(search: String) -> NSURL? {
  return search
    .stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
    >>== { NSURL(string: queryBase + $0) }
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
    >>== { $0.count == 2 ? $0 : nil }
    >>== { $0[1] as? [String] }
}

func pagesForSearch(search: String) -> [String]? {
  return URLForSearch(search)
    >>== DataForURL
    >>== JSONForData
    >>== ParseJSON
}

pagesForSearch("Albert ")
