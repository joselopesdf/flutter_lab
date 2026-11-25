import 'package:flutter/material.dart';
import 'package:flutter_lab/ui/flutter_lab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() {


  final binding = WidgetsFlutterBinding.ensureInitialized();
  binding.deferFirstFrame();
  runApp(const ProviderScope(child: FlutterLabApp()));


}