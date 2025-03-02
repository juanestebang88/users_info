import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/user_cubit.dart';
import '../../data/models/user_model.dart';
import 'package:uuid/uuid.dart';

class UserFormScreen extends StatefulWidget {
  const UserFormScreen({super.key});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final List<AddressModel> _addresses = [];
  final Uuid uuid = const Uuid(); // Para generar IDs únicos.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear Usuario"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo de Nombre
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: "Nombre"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor ingresa el nombre";
                  }
                  return null;
                },
              ),
              // Campo de Apellido
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: "Apellido"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor ingresa el apellido";
                  }
                  return null;
                },
              ),
              // Campo de Fecha de Nacimiento
              TextFormField(
                controller: _birthDateController,
                decoration: const InputDecoration(labelText: "Fecha de Nacimiento (YYYY-MM-DD)"),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor ingresa la fecha de nacimiento";
                  }
                  // Valida formato básico
                  final dateRegExp = RegExp(r'\d{4}-\d{2}-\d{2}');
                  if (!dateRegExp.hasMatch(value)) {
                    return "Formato inválido. Usa YYYY-MM-DD";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Lista de Direcciones
              Expanded(
                child: ListView.builder(
                  itemCount: _addresses.length,
                  itemBuilder: (context, index) {
                    final address = _addresses[index];
                    return ListTile(
                      title: Text(address.street),
                      subtitle: Text(address.city),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _addresses.removeAt(index);
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Botón para agregar dirección
              ElevatedButton(
                onPressed: () async {
                  final address = await _showAddressDialog();
                  if (address != null) {
                    setState(() {
                      _addresses.add(address);
                    });
                  }
                },
                child: const Text("Agregar Dirección"),
              ),
              const SizedBox(height: 16),
              // Botón para guardar usuario
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Crear el usuario
                    final user = UserModel(
                      id: uuid.v4(),
                      firstName: _firstNameController.text,
                      lastName: _lastNameController.text,
                      birthDate: DateTime.parse(_birthDateController.text),
                      addresses: _addresses,
                    );
                    context.read<UserCubit>().addUser(user);
                    Navigator.pop(context); // Regresar a la lista de usuarios
                  }
                },
                child: const Text("Guardar Usuario"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Diálogo para agregar direcciones
  Future<AddressModel?> _showAddressDialog() async {
    final TextEditingController streetController = TextEditingController();
    final TextEditingController cityController = TextEditingController();

    return await showDialog<AddressModel>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Agregar Dirección"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: streetController,
                decoration: const InputDecoration(labelText: "Calle"),
              ),
              TextFormField(
                controller: cityController,
                decoration: const InputDecoration(labelText: "Ciudad"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                final street = streetController.text.trim();
                final city = cityController.text.trim();
                if (street.isNotEmpty && city.isNotEmpty) {
                  Navigator.pop(
                    context,
                    AddressModel(
                      id: uuid.v4(),
                      street: street,
                      city: city,
                    ),
                  );
                }
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Liberar recursos
    _firstNameController.dispose();
    _lastNameController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }
}
