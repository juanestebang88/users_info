import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:user_info/cubit/user_cubit.dart';
import 'package:user_info/cubit/user_state.dart';
import 'package:user_info/data/models/user_model.dart';
import 'package:user_info/data/repositories/user_repository.dart';
import 'package:bloc_test/bloc_test.dart';

import 'user_cubit_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late MockUserRepository mockUserRepository;
  late UserCubit userCubit;

  const String testUserId = '1';
  final UserModel testUser = UserModel(
    id: testUserId,
    firstName: 'Test',
    lastName: 'User',
    birthDate: DateTime(1990, 1, 1),
    addresses: [],
  );
  final List<UserModel> emptyUserList = [];
  final List<UserModel> singleUserList = [testUser];
  final List<UserModel> multipleUsers = [
    UserModel(
      id: '1',
      firstName: 'Alice',
      lastName: 'Smith',
      birthDate: DateTime(1995, 5, 20),
      addresses: [],
    ),
    UserModel(
      id: '2',
      firstName: 'Bob',
      lastName: 'Johnson',
      birthDate: DateTime(1988, 3, 15),
      addresses: [],
    ),
  ];

  setUp(() {
    mockUserRepository = MockUserRepository();
    userCubit = UserCubit(mockUserRepository);
  });

  tearDown(() {
    userCubit.close();
  });

  group('UserCubit', () {
    group('loadUsers', () {
      blocTest<UserCubit, UserState>(
        'emite [UserLoading, UserLoaded] cuando loadUsers se ejecuta correctamente',
        build: () {
          when(mockUserRepository.getAllUsers()).thenReturn(singleUserList);
          return userCubit;
        },
        act: (cubit) => cubit.loadUsers(),
        expect: () => equals([
          UserLoading(),
          UserLoaded(singleUserList),
        ]),
        verify: (cubit) {
          verify(mockUserRepository.getAllUsers()).called(1);
          verifyNoMoreInteractions(mockUserRepository);
        },
      );

      blocTest<UserCubit, UserState>(
        'emite [UserLoading, UserError] cuando loadUsers lanza un error',
        build: () {
          when(mockUserRepository.getAllUsers())
              .thenThrow(Exception('Error al cargar usuarios'));
          return userCubit;
        },
        act: (cubit) => cubit.loadUsers(),
        expect: () => equals([
          UserLoading(),
          UserError(
              'Error al cargar los usuarios: Exception: Error al cargar usuarios'),
        ]),
        verify: (cubit) {
          verify(mockUserRepository.getAllUsers()).called(1);
          verifyNoMoreInteractions(mockUserRepository);
        },
      );

      blocTest<UserCubit, UserState>(
        'emite [UserLoading, UserLoaded] cuando no hay usuarios en la base de datos',
        build: () {
          when(mockUserRepository.getAllUsers()).thenReturn(emptyUserList);
          return userCubit;
        },
        act: (cubit) => cubit.loadUsers(),
        expect: () => equals([
          UserLoading(),
          UserLoaded(emptyUserList),
        ]),
        verify: (cubit) {
          verify(mockUserRepository.getAllUsers()).called(1);
          verifyNoMoreInteractions(mockUserRepository);
        },
      );
    });

    group('addUser', () {
      blocTest<UserCubit, UserState>(
        'emite [UserLoading, UserLoaded] cuando addUser se ejecuta correctamente',
        build: () {
          when(mockUserRepository.getAllUsers()).thenReturn(singleUserList);
          return userCubit;
        },
        act: (cubit) => cubit.addUser(testUser),
        expect: () => equals([
          UserLoading(),
          UserLoaded(singleUserList),
        ]),
        verify: (cubit) {
          verify(mockUserRepository.addUser(testUser)).called(1);
          verify(mockUserRepository.getAllUsers()).called(1);
          verifyNoMoreInteractions(mockUserRepository);
        },
      );

      blocTest<UserCubit, UserState>(
        'emite [UserLoading, UserError] cuando addUser lanza un error',
        build: () {
          when(mockUserRepository.addUser(any))
              .thenThrow(Exception('Error al agregar usuario'));
          return userCubit;
        },
        act: (cubit) => cubit.addUser(testUser),
        expect: () => equals([
          UserLoading(),
          UserError(
              'Error al agregar el usuario: Exception: Error al agregar usuario'),
        ]),
        verify: (cubit) {
          verify(mockUserRepository.addUser(testUser)).called(1);
          verifyNoMoreInteractions(mockUserRepository);
        },
      );
    });

    group('deleteUser', () {
      blocTest<UserCubit, UserState>(
        'emite [UserLoading, UserLoaded] cuando deleteUser se ejecuta correctamente',
        build: () {
          when(mockUserRepository.getAllUsers()).thenReturn(emptyUserList);
          return userCubit;
        },
        act: (cubit) => cubit.deleteUser(testUserId),
        expect: () => equals([
          UserLoading(),
          UserLoaded(emptyUserList),
        ]),
        verify: (cubit) {
          verify(mockUserRepository.deleteUser(testUserId)).called(1);
          verify(mockUserRepository.getAllUsers()).called(1);
          verifyNoMoreInteractions(mockUserRepository);
        },
      );
    });

    blocTest<UserCubit, UserState>(
      'emite [UserLoading, UserLoaded] con múltiples usuarios en la base de datos',
      build: () {
        when(mockUserRepository.getAllUsers()).thenReturn(multipleUsers);
        return userCubit;
      },
      act: (cubit) => cubit.loadUsers(),
      expect: () => equals([
        UserLoading(),
        UserLoaded(multipleUsers),
      ]),
      verify: (cubit) {
        verify(mockUserRepository.getAllUsers()).called(1);
        verifyNoMoreInteractions(mockUserRepository);
      },
    );
  });
}
