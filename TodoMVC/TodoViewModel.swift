import Foundation

@MainActor
final class TodoViewModel: ObservableObject {
    private let todoRepository: TodoRepository
    
    @Published
    var todos: [Todo]
    
    @Published
    var input: String = ""
    
    init(todoRepository: TodoRepository) {
        self.todoRepository = todoRepository
        self._todos = .init(initialValue: todoRepository.findAll())
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
}
