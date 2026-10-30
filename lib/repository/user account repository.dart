import '../services/user account service.dart';

class UserAccountRepository {
  final UserAccountService _service = UserAccountService();

  Future getUserData(String userId) async {
    return await _service.fetchUserData(userId);
  }
}