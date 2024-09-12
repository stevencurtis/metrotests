struct PersonDTO: Decodable {
    let name: String
}

extension PersonDTO {
    func toDomain() -> Person {
        Person(name: name)
    }
}
