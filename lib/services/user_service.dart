import 'package:shared_preferences/shared_preferences.dart';
import 'package:urban_council/models/resident.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  late Resident _currentUser;
  String? _userId;

  factory UserService() {
    return _instance;
  }

  UserService._internal();

  Future<void> loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('userId');
  }

  // Set the current user
  void setUserId(String userId) {
    _userId = userId;
  }

  String? get userId => _userId;

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    _userId = null;
  }

  // Set the current user
  void setCurrentUser(Resident user) {
    _currentUser = user;
  }

  // Get the current user
  Resident get currentUser => _currentUser;
}
