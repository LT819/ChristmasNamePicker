//
//  Chooser.swift
//  Chooser
//
//  Created by Luke Tomlinson on 9/6/17.
//  Copyright © 2017 Luke Tomlinson. All rights reserved.
//

import Foundation

class Chooser {
    
    let people: [Person] = [
        Person.init("Emily", exceptions:["David", "Little David", "Deborah", "Isaac"]),
        Person.init("David", exceptions:["Emily", "Little David", "Deborah", "Isaac"]),
        Person.init("Little David", exceptions:["David", "Emily"]),
        Person.init("Deborah", exceptions:["David", "Emily"]),
        Person.init("Isaac", exceptions:["David", "Emily"]),
        Person.init("Luke", exceptions:["Kaity"]),
        Person.init("Kaity", exceptions:["Luke"]),
        Person.init("William"),
        Person.init("Jonathan"),
        Person.init("Caroline"),
        Person.init("Charlotte"),
        Person.init("Peter"),
        Person.init("Abby"),
    ]
    
    func assignGiftees(peeps: [Person]) -> [Person] {
        
        let people = peeps.sorted(by: {(p1, p2) in  return p1.exceptions.count > p2.exceptions.count})
        var pool = Set(people)
        
        for person in people {
            
            let selfException: Set<Person> = [person]
            let allExceptions = person.exceptions.union(selfException)
            let possibleGiftees = Set(pool).subtracting(allExceptions)
            
            let giftee = Array(possibleGiftees).randomElement()
            person.giftee = giftee
            pool.remove(giftee)
        }
        
        return people
    }
}


class Person: ExpressibleByStringLiteral {
    
    let name: String
    var giftee: Person? = nil
    var exceptions: Set<Person> = []
    
    
    required init(_ name: String, exceptions: Set<Person> = []) {
        self.name = name
        self.exceptions = exceptions
    }
    
    required init(stringLiteral value: String) {
        self.name = value
    }
    
    required init(unicodeScalarLiteral value: String) {
        self.name = value
    }
    
    required init(extendedGraphemeClusterLiteral value: String) {
        self.name = value
    }
}

extension Person: Hashable {
    
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.name == rhs.name
    }
    
    var hashValue: Int {
        return name.hashValue
    }
}

extension Person: CustomStringConvertible {
    
    var description: String {
        let gifteeString = self.giftee?.name ?? "NOBODY"
        return "\(self.name) is getting a gift for: \(gifteeString)\n"
    }
}

extension Array {
    
    func randomElement() -> Element {
        return self[Int(arc4random()) % self.count]
    }
}

