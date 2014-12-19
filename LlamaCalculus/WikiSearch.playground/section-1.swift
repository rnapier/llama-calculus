// Playground - noun: a place where people can play

import Foundation

let queryBase = "http://en.wikipedia.org/w/api.php?"
  + "action=opensearch&format=json&search="


func pagesForSearch(search: String) -> [String]? {
  if let encoded = search
    .stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
      if let url = NSURL(string: queryBase + encoded) {
        let req = NSURLRequest(URL: url)
        if let data = NSURLConnection.sendSynchronousRequest(req,
          returningResponse: nil, error: nil) {
            if let json: AnyObject = NSJSONSerialization
              .JSONObjectWithData(data,
                options: NSJSONReadingOptions(0), error: nil) {
                  if let array = json as? [AnyObject] {
                    if array.count == 2 {
                      return array[1] as? [String]
                    }}}}}}
  return nil
}

pagesForSearch("Albert ")
