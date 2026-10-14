import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_car/core/error/exceptions.dart';
import 'package:my_car/core/network/api_client.dart';
import 'package:my_car/core/network/auth_token_store.dart';
import 'package:my_car/core/network/endpoints.dart';
import 'package:my_car/features/auth/data/datasources/auth_remote_datasource.dart';

import '../../../../helpers/fixtures.dart';

class _MockApiClient extends Mock implements ApiClient {}

void main() {
  late _MockApiClient client;
  late AuthTokenStore tokenStore;
  late AuthRemoteDataSourceImpl dataSource;

  setUp(() {
    client = _MockApiClient();
    tokenStore = AuthTokenStore();
    dataSource = AuthRemoteDataSourceImpl(client, tokenStore);
  });

  void stubLogin(dynamic response) => when(
        () => client.post(Endpoints.login, data: any(named: 'data')),
      ).thenAnswer((_) async => response);

  group('signIn', () {
    test('envia e-mail normalizado e senha intacta', () async {
      stubLogin({'id': 1, 'name': tName, 'email': tEmail});

      await dataSource.signIn(email: '  JESSICA@Mail.com ', password: ' p ');

      verify(
        () => client.post(
          Endpoints.login,
          data: {'email': tEmail, 'password': ' p '},
        ),
      ).called(1);
    });

    for (final entry in {
      'objeto raiz': {'id': 1, 'name': tName, 'email': tEmail},
      'chave user': {
        'user': {'id': 1, 'name': tName, 'email': tEmail},
      },
      'data.user': {
        'data': {
          'user': {'id': 1, 'username': tName, 'email': tEmail},
        },
      },
    }.entries) {
      test('lê usuário no formato "${entry.key}"', () async {
        stubLogin(entry.value);

        final user =
            await dataSource.signIn(email: tEmail, password: tPassword);

        expect(user.id, '1');
        expect(user.name, tName);
        expect(user.email, tEmail);
      });
    }

    for (final entry in {
      'token na raiz': {
        'token': 'abc',
        'user': {'id': 1, 'name': tName, 'email': tEmail},
      },
      'accessToken em data': {
        'data': {
          'accessToken': 'abc',
          'user': {'id': 1, 'name': tName, 'email': tEmail},
        },
      },
    }.entries) {
      test('guarda o token no formato "${entry.key}"', () async {
        stubLogin(entry.value);

        await dataSource.signIn(email: tEmail, password: tPassword);

        expect(tokenStore.token, 'abc');
      });
    }

    test('lança ParseException quando a resposta não tem usuário', () async {
      stubLogin({'token': 'abc'});

      expect(
        () => dataSource.signIn(email: tEmail, password: tPassword),
        throwsA(isA<ParseException>()),
      );
    });

    test('lança ParseException quando a resposta não é um objeto', () async {
      stubLogin('ok');

      expect(
        () => dataSource.signIn(email: tEmail, password: tPassword),
        throwsA(isA<ParseException>()),
      );
    });

    test('propaga AppException do ApiClient', () async {
      when(() => client.post(any(), data: any(named: 'data')))
          .thenThrow(const NetworkException());

      expect(
        () => dataSource.signIn(email: tEmail, password: tPassword),
        throwsA(isA<NetworkException>()),
      );
    });
  });

  group('register', () {
    test('cria usuário e impede e-mail duplicado', () async {
      final user = await dataSource.register(
        name: ' $tName ',
        email: tEmail,
        password: tPassword,
      );
      expect(user.name, tName);

      expect(
        () => dataSource.register(
          name: tName,
          email: tEmail.toUpperCase(),
          password: tPassword,
        ),
        throwsA(isA<UserAlreadyExistsException>()),
      );
    });
  });

  group('forgotPassword', () {
    test('envia o e-mail normalizado para o endpoint', () async {
      when(() =>
              client.post(Endpoints.forgotPassword, data: any(named: 'data')))
          .thenAnswer((_) async => null);

      await dataSource.forgotPassword(email: '  JESSICA@Mail.com ');

      verify(
        () => client.post(Endpoints.forgotPassword, data: {'email': tEmail}),
      ).called(1);
    });

    test('propaga AppException do ApiClient', () async {
      when(() => client.post(any(), data: any(named: 'data')))
          .thenThrow(const ServerException(statusCode: 500));

      expect(
        () => dataSource.forgotPassword(email: tEmail),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
