import SwiftUI

struct TodoScene: View {
    @State
    private(set) var todos: [Todo] = [
        .init(title: "Todo")
    ]
    
    var body: some View {
        List(self.$todos) { (todo) in
            TodoRow(todo: todo)
        }
    }
}

struct TodoScene_Previews: PreviewProvider {
    static var previews: some View {
        TodoScene()
    }
}
