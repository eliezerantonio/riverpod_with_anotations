import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/config.dart';
import '../../providers/providers.dart';

class TodoScreen extends ConsumerWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('State Provider + Providers'),
      ),
      body: const _TodoView(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          ref
              .read(todosProvider.notifier)
              .createTodo(RandomGenerator.getRandomName());
        },
      ),
    );
  }
}

class _TodoView extends ConsumerWidget {
  const _TodoView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.watch(todoCurrentFilterProvider);
    final todos = ref.watch(filteredTodosProvider);
    return Column(
      children: [
        const ListTile(
          title: Text('Listado de Convidadps'),
          subtitle: Text('Estas são as pessoas para convidar na festa'),
        ),

        SegmentedButton(
          segments: const [
            ButtonSegment(value: FilterType.all, icon: Text('Todos')),
            ButtonSegment(value: FilterType.completed, icon: Text('Enviados')),
            ButtonSegment(
                value: FilterType.pending, icon: Text('Não Enviados')),
          ],
          selected: <FilterType>{currentFilter},
          onSelectionChanged: (value) {
            ref
                .watch(todoCurrentFilterProvider.notifier)
                .setCurrentFilter(value.first);
          },
        ),
        const SizedBox(height: 5),

        /// Listado de personas a invitar
        Expanded(
          child: ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return SwitchListTile(
                  title: Text(todo.description),
                  value: todo.done,
                  onChanged: (value) {
                    ref.read(todosProvider.notifier).toggleTodo(todo.id);
                  });
            },
          ),
        )
      ],
    );
  }
}
