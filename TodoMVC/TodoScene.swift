import SwiftUI

struct TodoScene: View {
    @StateObject
    var viewModel: TodoViewModel = .init(todoRepository: DefaultTodoRepository(userDefaultsDAO: .init(userDefaults: .standard)))
    
    @FocusState
    var focusInput: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                TextField("", text: self.$viewModel.input)
                    .frame(height: 40.0)
                    .focused(self.$focusInput)
                    .onSubmit {
                        self.viewModel.submit()
                        self.focusInput = true
                    }
                    .textFieldStyle(.roundedBorder)
                ForEach(self.$viewModel.todos) { (todo) in
                    TodoRow(todo: todo)
                        .frame(height: 40.0)
                }
            }.padding()
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                self.focusInput = true
            }
        }
    }
}

struct TodoScene_Previews: PreviewProvider {
    static var previews: some View {
        TodoScene()
    }
}
