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
    
    func pressEnter() {
        let input: String = self.input
        guard !input.isEmpty else {
            return
        }
        self.input = ""
        let newTodo: Todo = .init(title: input)
        self.todos.insert(newTodo, at: 0)
    }
}
