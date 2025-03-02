import 'package:hive/hive.dart';
import '../models/user_model.dart';

class UserRepository {
  final Box<UserModel> _userBox;

  UserRepository(this._userBox);

  Future<void> addUser(UserModel user) async {
    await _userBox.put(user.id, user);
  }

  Future<void> deleteUser(String userId) async {
    await _userBox.delete(userId);
  }

  List<UserModel> getAllUsers() {
    return _userBox.values.toList();
  }
}
