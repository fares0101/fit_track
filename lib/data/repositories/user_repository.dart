import 'package:hive/hive.dart';

import '../../core/constants/app_constants.dart';
import '../models/user_model.dart';

class UserRepository {
  Box<UserModel> get _box => Hive.box<UserModel>(AppConstants.hiveBoxUser);

  UserModel getUser() {
    return _box.get('user') ??
        const UserModel(
          name: 'Alex Morgan',
          weight: 68,
          height: 172,
          age: 29,
          units: 'kg',
          fitnessGoal: 'Build endurance',
        );
  }

  Future<void> saveUser(UserModel user) async {
    await _box.put('user', user);
  }
}
