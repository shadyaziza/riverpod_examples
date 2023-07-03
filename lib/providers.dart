import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Old API
/// Provider
/// StateProvider - d
/// StateNotifierProvider - d
/// FutureProvider
/// SteamProvider
/// Provider
///
/// New API
/// NotifierProvider
/// AsyncNotifierProvider  - AsyncValue

// di
class AB {
  void call() {}
}

final abProvider = Provider((ref) => AB()); //

final isAdminProvider = StateProvider<bool>((ref) => false);

final counterControlerProvider =
    StateNotifierProvider<ControllerProviderNotifier, int>(
        (ref) => ControllerProviderNotifier(10));

class ControllerProviderNotifier extends StateNotifier<int> {
  ControllerProviderNotifier(super.state);

  void increment() {
    state++;
  }

  void decrement() {
    state--;
  }
}

final streamProvider = StreamProvider<int>((ref) async* {
  int i = 0;
  const maxCount = 10;
  while (true) {
    await Future.delayed(const Duration(seconds: 1));
    yield i++;
    if (i == maxCount) break;
  }
});

final dataAsyncProvider = FutureProvider((ref) async {
  await Future.delayed(const Duration(seconds: 2));
  return await Future.value({'futureData': 'future data value '});
});

final dataNotifierProvider =
    AsyncNotifierProvider<DataProviderNotifier, Map<String, dynamic>>(() {
  return DataProviderNotifier();
});

class DataProviderNotifier extends AsyncNotifier<Map<String, dynamic>> {
  // init state
  @override
  FutureOr<Map<String, dynamic>> build() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(seconds: 2));
      return await Future.value({'futureData': 'future data valued'});
    });
    return state.maybeWhen(orElse: () => {}, data: (data) => data);
  }
}

final counterNotifierProvider = NotifierProvider<CounterProviderNotifier, int>(
    () => CounterProviderNotifier());

class CounterProviderNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }
}
