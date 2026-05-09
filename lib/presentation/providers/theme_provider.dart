// lib/presentation/providers/theme_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// By default hum dark theme rakhenge
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);