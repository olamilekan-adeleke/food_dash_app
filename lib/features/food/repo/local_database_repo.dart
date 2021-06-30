import 'package:food_dash_app/cores/utils/config.dart';
import 'package:food_dash_app/features/auth/model/user_details_model.dart';
import 'package:hive/hive.dart';

class LocaldatabaseRepo {
  static const String userDataBoxName = 'user_data';

  Future<void> saveUserDataToLocalDB(Map<String, dynamic> data) async {
    final Box<Map<String, dynamic>> userBox = Hive.box(Config.userDataBox);
    await userBox.put(userDataBoxName, data);
  }

  Future<UserDetailsModel> getUserDataFromLocalDB() async {
    final Box<Map<String, dynamic>> _userBox = Hive.box(Config.userDataBox);
    final Map<String, dynamic>? _userData = _userBox.get(userDataBoxName);

    return UserDetailsModel.fromMap(_userData!);
  }
}
