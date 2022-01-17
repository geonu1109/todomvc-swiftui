import Foundation

struct Todo: Identifiable, Codable, Hashable {
    let id: UUID
    let creationDate: Date
    var title: String
    var isCompleted: Bool
    
    init(id: UUID = .init(), creationDate: Date = .now, title: String, isCompleted: Bool = false) {
        self.id = id
        self.creationDate = creationDate
        self.title = title
        self.isCompleted = isCompleted
    }
}
