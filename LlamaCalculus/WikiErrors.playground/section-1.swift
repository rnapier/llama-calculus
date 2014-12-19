import Foundation

let queryBase = "http://en.wikipedia.org/w/api.php?"
  + "action=opensearch&format=json&search="

func mkError(message: String) -> NSError {
  return NSError(domain: "", code: 0,
    userInfo: [NSLocalizedDescriptionKey: message])
}

func URLForSearch(search: String, #error: NSErrorPointer) -> NSURL? {
  var err: NSError?
  if let encoded = search
    .stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
      if let url = NSURL(string: queryBase + encoded) {
        return url
      } else { err = mkError("Malformed URL: \(encoded)") }
  } else { err = mkError("Malformed Search: \(search)") }

  if error != nil { error.memory = err }
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
  var err: NSError?
  if let array = json as? [AnyObject] {
    if array.count == 2 {
      if let list = array[1] as? [String] {
        return list
      } else { err = mkError("Malformed array: \(array)") }
    } else { err = mkError("Array incorrect size: \(array)") }
  } else { err = mkError("Expected array. Received: \(json)") }

  if error != nil { error.memory = err }
  return nil
}

func pagesForSearch(search: String, #error: NSErrorPointer) -> [String]? {
  if let url = URLForSearch(search, error: error) {
    if let data = DataForURL(url, error: error) {
      if let json: AnyObject = JSONForData(data, error: error) {
        return ParseJSON(json, error: error)
      }}}
  return nil
}

var error: NSError?
pagesForSearch("Albert ", error: &error)
