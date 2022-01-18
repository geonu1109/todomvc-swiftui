import Foundation

protocol TodoRepository {
    func findAll() -> [Todo]
    func save(_ todo: Todo)
    func delete(_ todo: Todo)
}

struct DefaultTodoRepository: TodoRepository {
    let userDefaultsDAO: UserDefaultsDAO
    
    init(userDefaultsDAO: UserDefaultsDAO) {
        self.userDefaultsDAO = userDefaultsDAO
    }
    
    func findAll() -> [Todo] {
        do {
            return try self.userDefaultsDAO
                .findAll()
                .sorted { $0.creationDate > $1.creationDate }
        } catch {
            return []
        }
    }
    
    func save(_ todo: Todo) {
        do {
            try self.userDefaultsDAO.save(todo)
        } catch {
            return
        }
    }
    
    func delete(_ todo: Todo) {
        do {
            try self.userDefaultsDAO.delete(todo)
        } catch {
            return
        }
    }
}
