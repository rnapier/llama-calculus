// Playground - noun: a place where people can play

enum EmailTag { case Home; case Work; case Other }

struct EmailAddress {
    let address: String
    let tag: EmailTag
}

struct Customer {
    let name: String
    let emails: [EmailAddress]
}

func emails(customers: [Customer], #tag:EmailTag) -> [String] {
    var emails = [String]()
    for customer in customers {
        for email in customer.emails {
            if email.tag == tag { emails.append(email.address) }
        }
    }
    return emails
}

func emails2(customers: [Customer], #tag: EmailTag) -> [String] {
    return join([],
        customers.map { customer in
            customer.emails
                .filter { $0.tag == tag }
                .map { $0.address }
        })
}

func emails3(customers: [Customer], #tag: EmailTag) -> [String] {
    return
        customers.flatMap { customer in
            customer.emails
                .filter { $0.tag == tag }
                .map { $0.address }
    }
}

