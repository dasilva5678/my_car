class AppUser {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
  });
}

/// A lightweight in-memory auth repository that replaces Firebase usage.
/// This keeps the same API surface used by the rest of the app but
/// no longer depends on Firebase. It's suitable for local development
/// or as a placeholder for a future auth implementation.
class AuthRepository {
  final Map<String, String> _credentials = {}; // email -> password
  final Map<String, AppUser> _users = {}; // email -> AppUser
  AppUser? _currentUser;

  AuthRepository();

  Future<AppUser?> getCurrentUser() async {
    return _currentUser;
  }

  Future<AppUser?> signIn({
    required String email,
    required String password,
  }) async {
    final stored = _credentials[email];
    if (stored == null) return null;
    if (stored != password) return null;
    _currentUser = _users[email];
    return _currentUser;
  }

  Future<AppUser?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    if (_credentials.containsKey(email)) {
      throw Exception('Usuário já existe.');
    }
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final user = AppUser(id: id, name: name, email: email);
    _credentials[email] = password;
    _users[email] = user;
    _currentUser = user;
    return user;
  }

  Future<void> signOut() async {
    _currentUser = null;
  }

  Future<void> deleteAccount() async {
    final user = _currentUser;
    if (user != null) {
      _credentials.remove(user.email);
      _users.remove(user.email);
    }
    _currentUser = null;
  }
}
