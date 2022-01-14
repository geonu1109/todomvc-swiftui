import Foundation

@MainActor
final class TodoViewModel: ObservableObject {
    @Published
    var todos: [Todo] = [
        .init(title: "Todo")
    ]
    
    @Published
    var input: String = ""
    
    init() {}
    
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
