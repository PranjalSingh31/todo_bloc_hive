import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';

class ThemeState {
  final bool isDark;
  ThemeState(this.isDark);
}

class ThemeCubit extends Cubit<ThemeState> {
  final Box _settingsBox = Hive.box('settings');
  ThemeCubit() : super(ThemeState(false));

  void loadTheme() {
    final isDark = _settingsBox.get('isDark', defaultValue: false) as bool;
    emit(ThemeState(isDark));
  }

  void toggleTheme() {
    final newTheme = !state.isDark;
    _settingsBox.put('isDark', newTheme);
    emit(ThemeState(newTheme));
  }
}
