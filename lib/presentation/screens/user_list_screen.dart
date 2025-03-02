import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/user_cubit.dart';
import '../../cubit/user_state.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {

    context.read<UserCubit>().loadUsers();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Usuarios"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/userForm');
            },
          ),
        ],
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            final users = state.users;

            if (users.isEmpty) {
              return const Center(child: Text("No hay usuarios disponibles"));
            }

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${user.firstName} ${user.lastName}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text('Nacimiento: ${user.birthDate}',
                              style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/userEdit',
                                arguments: user,
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              context.read<UserCubit>().deleteUser(user.id);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is UserError) {
            return Center(child: Text(state.message));
          }

          return const Center(child: Text("Cargando..."));
        },
      ),
    );
  }
}
