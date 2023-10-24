import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../config/config.dart';
import '../../domain/domain.dart';
import 'package:uuid/uuid.dart';

part 'todos_provider.g.dart';

const uuid = Uuid();

enum FilterType { all, completed, pending }

@Riverpod(keepAlive: true)
class TodoCurrentFilter extends _$TodoCurrentFilter {
  @override
  FilterType build() => FilterType.all;

  void setCurrentFilter(FilterType newFilter) {
    state = newFilter;
  }
}

@Riverpod(keepAlive: true)
class Todos extends _$Todos {
  @override
  List<Todo> build() => List.generate(
        5,
        (index) => Todo(
          id: uuid.v4(),
          description: RandomGenerator.getRandomName(),
          completedAt: index % 2 == 0 ? DateTime.now() : null,
        ),
      );

  void createTodo(String descrition) {
    state = [
      ...state,
      Todo(
        id: uuid.v4(),
        description: descrition,
        completedAt: null,
      )
    ];
  }

  void toggleTodo(String id) {
    state = state.map<Todo>((todo) {
      if (todo.id == id) {
        todo = todo.copyWith(completedAt: todo.done ? null : DateTime.now());
      }

      return todo;
    }).toList();
  }
}

@riverpod
List<Todo> filteredTodos(FilteredTodosRef ref) {
  final currentFilter = ref.watch(todoCurrentFilterProvider);
  final todos = ref.watch(todosProvider);

  switch (currentFilter) {
    case FilterType.all:
      return todos;
    case FilterType.completed:
      return todos.where((todo) => todo.done).toList();
    case FilterType.pending:
      return todos.where((todo) => !todo.done).toList();
  }
}
