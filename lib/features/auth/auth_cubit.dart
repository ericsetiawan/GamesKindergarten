import 'package:bloc/bloc.dart';
import 'user_model.dart';

class AuthCubit extends Cubit<UserModel?> {
  AuthCubit() : super(null);

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (email == 'mutiara' && password == '123456') {
      emit(UserModel(email: email));
      return true;
    } else {
      return false;
    }
  }
}