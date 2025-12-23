// The entry point for the Art of Evolve application.
//
// This file initializes the Flutter binding, sets up Firebase,
// initializes Hive storage, and runs the root [ArtOfEvolveApp].
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'src/app.dart';
import 'src/services/notifications/notification_service.dart';
import 'src/services/storage/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await HiveService.init();
  await NotificationService.initStatic();

  runApp(const ProviderScope(child: ArtOfEvolveApp()));
}
