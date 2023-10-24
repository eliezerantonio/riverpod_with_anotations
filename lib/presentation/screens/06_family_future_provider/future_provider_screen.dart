import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';

class FamilyFutureScreen extends ConsumerStatefulWidget {
  const FamilyFutureScreen({super.key});

  @override
  FamilyFutureScreenState createState() => FamilyFutureScreenState();
}

class FamilyFutureScreenState extends ConsumerState<FamilyFutureScreen> {
  int pokemonId = 1;
  @override
  Widget build(BuildContext context) {
    final pokemonAsync = ref.watch(pokemonProvider(pokemonId));
    return Scaffold(
      appBar: AppBar(
        title: Text('PokemonId $pokemonId'),
      ),
      body: Center(
        child: pokemonAsync.when(
            data: (data) => Text(data),
            error: (error, __) => Text("$error"),
            loading: CircularProgressIndicator.adaptive),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'btn-add',
            child: const Icon(Icons.add),
            onPressed: () {
              // ref.invalidate(pokemonNameProvider);
              pokemonId++;
              setState(() {});
            },
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            child: const Icon(Icons.remove),
            onPressed: () {
              // ref.invalidate(pokemonNameProvider);
              if (pokemonId <= 1) return;
              pokemonId--;
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
