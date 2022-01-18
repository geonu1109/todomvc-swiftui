import SwiftUI

struct TodoRow: View {
    @Binding
    var todo: Todo
    
    var body: some View {
        HStack {
            Button {
                self.todo.isCompleted.toggle()
            } label: {
                Image(
                    systemName: todo.isCompleted ? "checkmark.square" : "square"
                )
            }
            Text(self.todo.title)
                .strikethrough(self.todo.isCompleted)
                .foregroundColor(self.todo.isCompleted ? .secondary : .primary)
        }
    }
    
    init(todo: Binding<Todo>) {
        self._todo = todo
    }
}
