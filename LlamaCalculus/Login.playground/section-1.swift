// Playground - noun: a place where people can play

import Cocoa

extension Optional {
    func flatMap<U>(f: T -> U?) -> U? {
        if let x = self {
            return f(x)
        }
        return nil
    }
}

struct Connection { }

func login(#domain: String, #username: String, #password: String)
    -> Connection {
        println(domain, username, password)
        return Connection()
}

func login(#domain: String?, #username: String?, #password: String?)
    -> Connection? {
        if let
            d = domain,
            u = username,
            p = password {
                return login(domain: d, username: u, password: p)
        }
        return nil
}

func login2(#domain: String?, #username: String?, #password: String?)
    -> Connection? {
        return
            domain      .flatMap { d in
                username  .flatMap { u in
                    password.flatMap { p in
                        login(domain: d, username: u, password: p)
                    }}}
}


let d = ["domain": "example.com", "username": "bob", "password": "pa$$word!" ]

var connection: Connection?
if let domain = d["domain"],
    username = d["username"],
    password = d["password"] {
        connection = login(domain: domain,
            username: username, password: password)
}


let c = login(domain: d["domain"], username: d["username"], password: d["password"])
let C = login2(domain: d["domain"], username: d["username"], password: d["password"])


func makeOptional<A,B,C,R>(f: (A,B,C) -> R) -> (A?,B?,C?) -> R? {
    return { (a,b,c) in
        a.flatMap { a in b.flatMap { b in c.flatMap { c in
            f(a,b,c)
            }}}}
}


let c2 = makeOptional(login)(d["domain"], d["username"], d["password"])
