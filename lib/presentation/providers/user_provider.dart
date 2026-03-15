import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepository(),
);

class UserNotifier extends StateNotifier<UserModel> {
  UserNotifier(this._repository)
      : super(const UserModel(name: '', weight: 0, height: 0, age: 0)) {
    load();
  }

  final UserRepository _repository;

  void load() {
    state = _repository.getUser();
  }

  Future<void> updateUser(UserModel user) async {
    await _repository.saveUser(user);
    load();
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserModel>(
  (ref) => UserNotifier(ref.watch(userRepositoryProvider)),
);
