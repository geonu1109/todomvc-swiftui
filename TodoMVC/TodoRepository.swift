import Foundation

protocol TodoRepository {
    func findAll() -> [Todo]
    func save(_ todo: Todo)
    func saveAll(_ todos: [Todo])
    func delete(_ todo: Todo)
    func deleteAll(_ todos: [Todo])
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
    
    func saveAll(_ todos: [Todo]) {
        do {
            try self.userDefaultsDAO.saveAll(todos)
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
    
    func deleteAll(_ todos: [Todo]) {
        do {
            try self.userDefaultsDAO.deleteAll(todos)
        } catch {
            return
        }
    }
}
