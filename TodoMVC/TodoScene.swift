import SwiftUI

struct TodoScene: View {
    @StateObject
    var viewModel: TodoViewModel = .init(todoRepository: DefaultTodoRepository(userDefaultsDAO: .init(userDefaults: .standard)))
    
    @FocusState
    var focusInput: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Divider()
                HStack {
                    Button {
                        self.viewModel.toggleAll()
                    } label: {
                        Image(
                            systemName: self.viewModel.allCompleted ? "checkmark.square" : "square"
                        ).imageScale(.large)
                    }.tint(
                        .primary
                    ).disabled(self.viewModel.todos.isEmpty)
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
                ).frame(height: 30.0)
                Divider()
                if !self.viewModel.filtered.isEmpty {
                    List(self.viewModel.filtered) { (todo) in
                        HStack {
                            Button {
                                self.viewModel.toggle(todo)
                            } label: {
                                Image(
                                    systemName: todo.isCompleted ? "checkmark.square" : "square"
                                )
                            }
                            Text(todo.title)
                                .strikethrough(todo.isCompleted)
                                .foregroundColor(todo.isCompleted ? .secondary : .primary)
                        }.frame(
                            height: 30.0
                        ).swipeActions {
                            Button(role: .destructive) {
                                withAnimation {
                                    self.viewModel.delete(todo)
                                }
                            } label: {
                                Text("Delete")
                            }
                        }
                    }.listStyle(
                        .plain
                    )
                } else {
                    Text(self.viewModel.todos.isEmpty ? "empty" : "filtered")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                if !self.viewModel.todos.isEmpty {
                    Divider()
                    VStack {
                        HStack {
                            ForEach(TodoFilter.allCases, id: \.self) { (todoFilter) in
                                Button {
                                    self.viewModel.filter = todoFilter
                                } label: {
                                    if self.viewModel.filter == todoFilter {
                                        Text(todoFilter.rawValue)
                                            .font(.caption)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color.secondary, lineWidth: 1)
                                            )
                                    } else {
                                        Text(todoFilter.rawValue)
                                            .font(.caption)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                    }
                                }.tint(
                                    self.viewModel.filter == todoFilter ? .primary : .accentColor
                                ).frame(
                                    maxWidth: .infinity
                                )
                            }
                        }
                    }.padding(
                        .horizontal, 20
                    ).frame(height: 30.0)
                    Divider()
                        .background(Color.clear)
                }
            }.navigationTitle(
                "todos"
            ).navigationBarTitleDisplayMode(
                .inline
            ).toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(self.viewModel.leftCountLabel)
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            self.viewModel.deleteAllCompleted()
                        }
                    } label: {
                        Text("Clear completed")
                            .font(.caption)
                    }.disabled(!self.viewModel.hasCompleted)
                }
            }
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
