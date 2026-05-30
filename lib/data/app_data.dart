import 'package:hive_flutter/hive_flutter.dart';

const List<String> defaultSubjects = [
  'C Programming',
  'Flutter',
  'Mathematics',
  'Network',
  'General',
];

List<String> getSubjects() {
  final box = Hive.box('profileBox');
  final saved = box.get('subjects');
  if (saved != null) {
    return List<String>.from(saved);
  }
  return List<String>.from(defaultSubjects);
}

void saveSubjects(List<String> subjects) {
  final box = Hive.box('profileBox');
  box.put('subjects', subjects);
}
