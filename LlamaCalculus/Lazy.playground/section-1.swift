// Playground - noun: a place where people can play

import Cocoa

let xs = [1,2,3]

let ys = lazy(xs)
    .map { $0 + 1 }
    .filter { $0 % 2 == 0 }

let result = ys.array

