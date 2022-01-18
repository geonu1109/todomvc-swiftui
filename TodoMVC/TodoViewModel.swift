import Foundation

@MainActor
final class TodoViewModel: ObservableObject {
    private let todoRepository: TodoRepository
    
    @Published
    var todos: [Todo]
    
    @Published
    var filter: TodoFilter = .all
    
    var filtered: [Todo] {
        switch self.filter {
        case .all:
            return self.todos
        case .active:
            return self.todos.filter { !$0.isCompleted }
        case .completed:
            return self.todos.filter { $0.isCompleted }
        }
    }
    
    var leftCountLabel: String {
        guard !self.todos.isEmpty else {
            return "no items"
        }
        let leftCount = self.todos.filter { !$0.isCompleted }.count
        if leftCount == 1 {
            return "1 item left"
        } else {
            return "\(leftCount) items left"
        }
    }
    
    var hasCompleted: Bool {
        return self.todos.contains { todo in
            return todo.isCompleted
        }
    }
    
    var allCompleted: Bool {
        if self.todos.isEmpty {
            return false
        } else {
            return self.todos.allSatisfy { $0.isCompleted }
        }
    }
    
    @Published
    var input: String = ""
    
    init(todoRepository: TodoRepository) {
        self.todoRepository = todoRepository
        self._todos = .init(initialValue: todoRepository.findAll())
    }
    
    func toggle(_ todo: Todo) {
        var todo = todo
        todo.isCompleted.toggle()
        self.todoRepository.save(todo)
        guard let index = self.todos.firstIndex(where: { $0.id == todo.id }) else {
            return
        }
        self.todos[index] = todo
    }
    
    func toggleAll() {
        let allCompleted = self.allCompleted
        let todos: [Todo] = self.todos.map {
            var todo = $0
            todo.isCompleted = !allCompleted
            return todo
        }
        self.todoRepository.saveAll(todos)
        self.todos = todos
    }
    
    func submit() {
        let input: String = self.input.trimmingCharacters(in: [" "])
        guard !input.isEmpty else {
            return
        }
        self.input = ""
        let newTodo: Todo = .init(title: input)
        self.todoRepository.save(newTodo)
        self.todos.insert(newTodo, at: 0)
    }
    
    func delete(_ todo: Todo) {
        self.todoRepository.delete(todo)
        guard let index = self.todos.firstIndex(of: todo) else {
            return
        }
        self.todos.remove(at: index)
    }
    
    func deleteAllCompleted() {
        let targets = self.todos.filter { $0.isCompleted }
        self.todoRepository.deleteAll(targets)
        let remains = self.todos.filter { !$0.isCompleted }
        self.todos = remains
    }
}
