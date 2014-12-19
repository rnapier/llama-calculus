// Playground - noun: a place where people can play

import Cocoa

let xs = [1,3,5]
let sum = xs.reduce(0, +)

func minMax<T: Comparable>(xs: [T]) -> (minVal: T, maxVal: T) {
  let seq = dropFirst(xs)
  let initial = (xs[0], xs[0])
  return reduce(seq, initial) { (a, x) in
    (min(a.minVal, x), max(a.maxVal, x))
  }
}

