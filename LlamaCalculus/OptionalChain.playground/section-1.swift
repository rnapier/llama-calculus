// Playground - noun: a place where people can play

import Foundation

class Person {
    var residence: Residence?
}
class Residence {
    var numberOfRooms = 1
}

let john = Person()

let roomCount = john.residence?.numberOfRooms
let rc = john.residence.map { $0.numberOfRooms }

let r = john.residence.flatMap { $0.numberOfRooms }
