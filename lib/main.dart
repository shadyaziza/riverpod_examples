import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_examples/providers.dart';
import 'dart:math' as math;

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const StateNotifierExample(),
                      ),
                    ),
                child: const Text('StateProvider and StateNotifierProvider')),
            ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const FutureExample(),
                      ),
                    ),
                child: const Text('FutureExample')),
            ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const StreamExample(),
                      ),
                    ),
                child: const Text('StreamExample')),
            ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const HooksExample(),
                      ),
                    ),
                child: const Text('HooksExample'))
          ],
        ),
      ),
    );
  }
}

class StateNotifierExample extends ConsumerStatefulWidget {
  const StateNotifierExample({super.key});

  @override
  ConsumerState<StateNotifierExample> createState() =>
      _StateNotifierExampleState();
}

class _StateNotifierExampleState extends ConsumerState<StateNotifierExample> {
  // int _counter = 0;

  void _incrementCounter() {
    // ref.read(isAdminProvider.notifier).state =
    //     !ref.read(isAdminProvider.notifier).state;
    // setState(() {
    //   _counter++;
    // });

    ref.read(counterControlerProvider.notifier).increment();
  }

  void _decrementCounter() {
    ref.read(counterControlerProvider.notifier).decrement();
  }

  @override
  Widget build(BuildContext context) {
    // final isAdmin = ref.watch(isAdminProvider);
    final count = ref.watch(counterControlerProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('StateProvider + StateNotifierProvider'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$count',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: _decrementCounter,
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

class FutureExample extends ConsumerWidget {
  const FutureExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(dataAsyncProvider);
    final isLoading = ref.watch(dataAsyncProvider).isLoading ||
        ref.watch(dataAsyncProvider).isRefreshing;
    ref.listen<AsyncValue<Map<String, dynamic>>>(
      dataAsyncProvider,
      (previous, next) {
        if (next.isRefreshing) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Row(
            children: [
              CircularProgressIndicator.adaptive(),
              Text('Provider is refreshing...')
            ],
          )));
        }
      },
    );

    return Scaffold(
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FloatingActionButton(
              onPressed: () {
                // ref.read(dataNotifierProvider.notifier).getData();
              },
              child: const Icon(Icons.abc),
            ),
            FloatingActionButton(
              onPressed: () {
                ref.invalidate(dataAsyncProvider);
              },
              child: const Icon(Icons.refresh),
            ),
          ],
        ),
        appBar: AppBar(
          title: const Text('Future Example'),
        ),
        body: Center(
          child: asyncData.when(
            data: (data) => Text(data.toString()),
            error: (e, _) => Text(e.toString()),
            loading: () => const CircularProgressIndicator.adaptive(),
          ),
        ));
  }
}

class StreamExample extends ConsumerWidget {
  const StreamExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(streamProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Stream Example'),
        ),
        body: Center(
          child: asyncData.when(
            data: (data) => Text(data.toString()),
            error: (e, _) => Text(e.toString()),
            loading: () => const CircularProgressIndicator.adaptive(),
          ),
        ));
  }
}

class HooksExample extends HookConsumerWidget {
  const HooksExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = useState<Color>(Colors.red);
    // final txtEditingControlelr = useTextEditingController(text: TextEditingValue());
    // final txtEditingControlelr = useAn(text: TextEditingValue());

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          color.value = Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
              .withOpacity(1.0);
        },
        child: const Icon(Icons.color_lens),
      ),
      backgroundColor: color.value,
      appBar: AppBar(
        title: const Text('Hooks Example'),
      ),
    );
  }
}
