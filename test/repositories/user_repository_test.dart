import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:hive/hive.dart';
import 'package:user_info/data/models/user_model.dart';
import 'package:user_info/data/repositories/user_repository.dart';

import 'user_repository_test.mocks.dart';

@GenerateMocks([Box])
void main() {
  late MockBox<UserModel> mockUserBox;
  late UserRepository userRepository;

  setUp(() {
    mockUserBox = MockBox<UserModel>();
    userRepository = UserRepository(mockUserBox);
  });

  group('UserRepository', () {
    final testUser = UserModel(
      id: '1',
      firstName: 'Test',
      lastName: 'User',
      birthDate: DateTime(1990, 1, 1),
      addresses: [],
    );

    group('getAllUsers', () {
      test('devuelve una lista vacía cuando no hay usuarios en la caja', () {
        when(mockUserBox.values).thenReturn([]);
        
        final users = userRepository.getAllUsers();

        expect(users, isEmpty);
        verify(mockUserBox.values).called(1);
        verifyNoMoreInteractions(mockUserBox);
      });

      test('devuelve una lista con usuarios cuando la caja tiene datos', () {
        when(mockUserBox.values).thenReturn([testUser]);

        final users = userRepository.getAllUsers();

        expect(users, isNotEmpty);
        expect(users.length, 1);
        expect(users.first, equals(testUser));
        verify(mockUserBox.values).called(1);
        verifyNoMoreInteractions(mockUserBox);
      });
    });

    group('addUser', () {
      test('agrega un usuario a la caja correctamente', () async {
        when(mockUserBox.put(testUser.id, testUser)).thenAnswer((_) async => {});

        await userRepository.addUser(testUser);

        verify(mockUserBox.put(testUser.id, testUser)).called(1);
        verifyNoMoreInteractions(mockUserBox);
      });
    });

    group('deleteUser', () {
      test('elimina un usuario de la caja por ID', () async {
        when(mockUserBox.delete(testUser.id)).thenAnswer((_) async => {});

        await userRepository.deleteUser(testUser.id);

        verify(mockUserBox.delete(testUser.id)).called(1);
        verifyNoMoreInteractions(mockUserBox);
      });
    });
  });
}
