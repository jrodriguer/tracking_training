import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';
import 'theme.dart';

class TrackingTrainingApp extends ConsumerWidget {
  const TrackingTrainingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Tracking Training',
      theme: buildAppTheme(),
      routerConfig: router,
    );
  }
}
