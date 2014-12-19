// Playground - noun: a place where people can play

import Foundation

struct Grapher {
  let categories = [String]()
  let colors = [String]()

  init(categories: [String], colors:[String]) {
    var result = [String]()
    for var i = 1; i < categories.count; i++ {
      result.append(categories[i].lowercaseString)
    }
    self.categories = result

    for var i = 1; i < colors.count; i++ {
      result.append(colors[i].lowercaseString)
    }
  }
}

struct Grapher2 {
  let categories: [String]
  let colors: [String]

  init(categories: [String], colors:[String]) {
    self.categories = [String]()
    for var i = 1; i < categories.count; i++ {
      self.categories.append(categories[i].lowercaseString)
    }

    self.colors = [String]()
    for var i = 1; i < colors.count; i++ {
      self.colors.append(colors[i].lowercaseString)
    }
  }
}

struct Grapher3 {
  let categories: [String]
  let colors: [String]

  init(categories: [String], colors:[String]) {
    self.categories = [String]()
    for category in  categories {
      self.categories.append(category.lowercaseString)
    }

    self.colors = [String]()
    for color in colors {
      self.colors.append(color.lowercaseString)
    }
  }
}

struct Grapher4 {
  let categories: [String]
  let colors: [String]

  init(categories: [String], colors:[String]) {
    let lc = { (s:String) in s.lowercaseString }
    self.categories = categories.map(lc)
    self.colors = colors.map(lc)
  }
}


let g = Grapher2(categories: ["X","Y","Z"], colors: ["RED", "YELLOW"])

let y = [1,2,3].map { x in x^2 }
