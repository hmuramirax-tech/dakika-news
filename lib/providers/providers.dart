import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dakika/theme/tokens.dart';

/// Provides the current app tokens based on brightness.
/// In a real app, this would come from a theme provider.
final appTokensProvider = Provider<AppTokens>((ref) {
  return lightTokens;
});

/// User preferences provider.
/// TODO: Persist to Supabase or local storage.
class UserPreferences {
  final String language;
  final String displayDensity;
  final bool dataSaver;
  final bool notificationsEnabled;

  const UserPreferences({
    this.language = 'English',
    this.displayDensity = 'Comfortable',
    this.dataSaver = false,
    this.notificationsEnabled = true,
  });

  UserPreferences copyWith({
    String? language,
    String? displayDensity,
    bool? dataSaver,
    bool? notificationsEnabled,
  }) {
    return UserPreferences(
      language: language ?? this.language,
      displayDensity: displayDensity ?? this.displayDensity,
      dataSaver: dataSaver ?? this.dataSaver,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}

final userPreferencesProvider =
    StateNotifierProvider<UserPreferencesNotifier, UserPreferences>((ref) {
  return UserPreferencesNotifier();
});

class UserPreferencesNotifier extends StateNotifier<UserPreferences> {
  UserPreferencesNotifier() : super(const UserPreferences());

  void setLanguage(String language) {
    state = state.copyWith(language: language);
  }

  void setDisplayDensity(String density) {
    state = state.copyWith(displayDensity: density);
  }

  void setDataSaver(bool value) {
    state = state.copyWith(dataSaver: value);
  }

  void setNotifications(bool value) {
    state = state.copyWith(notificationsEnabled: value);
  }
}
