import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'cubit/user_cubit.dart';
import 'data/models/user_model.dart';
import 'data/repositories/user_repository.dart';
import 'presentation/screens/user_form_screen.dart';
import 'presentation/screens/user_list_screen.dart';

import 'presentation/screens/user_edit_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(AddressModelAdapter());

  // Abrir caja de Hive
  final userBox = await Hive.openBox<UserModel>('userBox');

  runApp(MyApp(userRepository: UserRepository(userBox)));
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository;

  const MyApp({super.key, required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserCubit(userRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Gestión de Usuarios',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => const UserListScreen(),
          '/userForm': (context) => const UserFormScreen(),
          '/userEdit': (context) => (UserEditScreen(
              user: ModalRoute.of(context)!.settings.arguments as UserModel)),
        },
      ),
    );
  }
}
