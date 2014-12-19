import Foundation

let queryBase = "http://en.wikipedia.org/w/api.php?"
  + "action=opensearch&format=json&search="

func mkError(message: String) -> NSError {
  return NSError(domain: "", code: 0,
    userInfo: [NSLocalizedDescriptionKey: message])
}

final class Box<T> {
  let unbox: T
  init(_ value: T) { self.unbox = value }
}

func success<T,E>(value: T) -> Result<T,E> {
  return .Success(Box(value))
}

func failure<T,E>(error: E) -> Result<T,E> {
  return .Failure(Box(error))
}

func withError<T>(f: NSErrorPointer -> T?, file: String = __FILE__, line: Int = __LINE__) -> Result<T, NSError> {
  var error: NSError?
  return f(&error).map(success) ?? failure(error ?? mkError(""))
}

enum Result<T,E> {
  case Success(Box<T>)
  case Failure(Box<E>)

  func value() -> T? {
    switch self {
    case .Success(let box): return box.unbox
    case .Failure: return nil
    }
  }
  init(_ x: T?, failWith: E) {
    switch x {
    case .Some(let v): self = Success(Box(v))
    case .None: self = Failure(Box(failWith))
    }
  }

  func flatMap<U>(transform:T -> Result<U,E>) -> Result<U,E> {
    switch self {
    case Success(let value): return transform(value.unbox)
    case Failure(let error): return .Failure(error)
    }
  }
}

extension Result: Printable {
  var description: String {
    switch self {
    case .Success(let box):
      return "Success: \(box.unbox)"
    case .Failure(let error):
      return "Failure: \(error.unbox)"
    }
  }
}

func URLForSearch(search: String) -> Result<NSURL, NSError> {
  return success(search)
    .flatMap { Result(
      $0.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding),
      failWith: mkError("Malformed Search: \($0)")) }
    .flatMap { Result(NSURL(string: queryBase + $0),
      failWith: mkError("Malformed URL: \($0)"))}
}

func DataForURL(url: NSURL) -> Result<NSData, NSError> {
  return withError { error in
    NSURLConnection.sendSynchronousRequest(NSURLRequest(URL: url),
      returningResponse: nil, error: error)}
}

func JSONForData(data: NSData) -> Result<AnyObject, NSError> {
  return withError { error in
    NSJSONSerialization.JSONObjectWithData(data,
      options: NSJSONReadingOptions(0), error: error)}
}

func ParseJSON(json: AnyObject) -> Result<[String], NSError> {
  return
    Result(json as? [AnyObject],
      failWith: mkError("Expected array. Received: \(json)"))

      .flatMap { Result($0.count == 2 ? $0 : nil,
        failWith: mkError("Array incorrect size: \($0)"))}

      .flatMap { Result($0[1] as? [String],
        failWith: mkError("Malformed array: \($0)"))}
}

func pagesForSearch(search: String) -> Result<[String], NSError> {
  return URLForSearch(search)
    .flatMap(DataForURL)
    .flatMap(JSONForData)
    .flatMap(ParseJSON)
}

pagesForSearch("Albert ")
