/// The entry point of the Art of Evolve application.
/// Initializes Firebase, Hive, Notifications, and runs the app.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/app.dart';
import 'src/services/storage/hive_service.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'src/services/notifications/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await HiveService.init();
  await NotificationService.initStatic();

  runApp(const ProviderScope(child: ArtOfEvolveApp()));
}
