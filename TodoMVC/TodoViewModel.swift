import Foundation

@MainActor
final class TodoViewModel: ObservableObject {
    private let todoRepository: TodoRepository
    
    @Published
    var todos: [Todo]
    
    var allCompleted: Bool {
        return self.todos.allSatisfy { $0.isCompleted }
    }
    
    @Published
    var input: String = ""
    
    init(todoRepository: TodoRepository) {
        self.todoRepository = todoRepository
        self._todos = .init(initialValue: todoRepository.findAll())
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
}
