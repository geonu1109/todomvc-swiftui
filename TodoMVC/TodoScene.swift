import SwiftUI

struct TodoScene: View {
    @StateObject
    var viewModel: TodoViewModel = .init(todoRepository: DefaultTodoRepository(userDefaultsDAO: .init(userDefaults: .standard)))
    
    @FocusState
    var focusInput: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button {
                        self.viewModel.toggleAll()
                    } label: {
                        Image(
                            systemName: self.viewModel.allCompleted ? "checkmark.square" : "square"
                        ).imageScale(.large)
                    }.tint(.primary)
                    Spacer()
                    TextField("", text: self.$viewModel.input)
                        .focused(self.$focusInput)
                        .onSubmit {
                            self.viewModel.submit()
                            self.focusInput = true
                        }
                        .textFieldStyle(.roundedBorder)
                }.padding(
                    .horizontal, 20
                ).frame(height: 40.0)
                List(self.$viewModel.todos) { (todo) in
                    TodoRow(todo: todo)
                        .frame(height: 40.0)
                        .swipeActions {
                            Button(role: .destructive) {
                                withAnimation {
                                    self.viewModel.delete(todo.wrappedValue)
                                }
                            } label: {
                                Text("Delete")
                            }
                        }
                }
            }.listStyle(.plain).navigationTitle(
                "todos"
            ).navigationBarTitleDisplayMode(
                .inline
            )
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
