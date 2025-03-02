import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/user_model.dart';
import '../data/repositories/user_repository.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;

  UserCubit(this.userRepository) : super(UserInitial());

  void loadUsers() async {
    try {
      emit(UserLoading());
      final users = userRepository.getAllUsers();
      emit(UserLoaded(users));
    } catch (e) {
      emit(UserError('Error al cargar los usuarios: $e'));
    }
  }

  void addUser(UserModel user) async {
    try {
      emit(UserLoading());
      await userRepository.addUser(user);
      final users = userRepository.getAllUsers();
      emit(UserLoaded(users));
    } catch (e) {
      emit(UserError('Error al agregar el usuario: $e'));
    }
  }

  void deleteUser(String userId) async {
    try {
      emit(UserLoading());
      await userRepository.deleteUser(userId);
      final users = userRepository.getAllUsers();
      emit(UserLoaded(users));
    } catch (e) {
      emit(UserError('Error al eliminar el usuario: $e'));
    }
  }
}
