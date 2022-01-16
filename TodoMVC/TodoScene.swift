import SwiftUI

struct TodoScene: View {
    @StateObject
    var viewModel: TodoViewModel = .init(todoRepository: DefaultTodoRepository(userDefaultsDAO: .init(userDefaults: .standard, jsonEncoder: .init(), jsonDecoder: .init())))
    
    var body: some View {
        List(self.$viewModel.todos) { (todo) in
            TodoRow(todo: todo)
        }
    }
}

struct TodoScene_Previews: PreviewProvider {
    static var previews: some View {
        TodoScene()
    }
}
