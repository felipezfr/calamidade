import 'package:coopartilhar/app/features/auth/interactor/repositories/i_auth_repository.dart';

import 'package:core_module/core_module.dart';

class AuthRepositoryImpl implements IAuthRepository {
  const AuthRepositoryImpl({
    required this.client,
  });

  final IRestClient client;

  @override
  Future<Output<SessionEntity>> login({
    required CredentialsEntity credentials,
  }) async {
    try {
      final response = await client.post(
        RestClientRequest(
          path: '/core/v1/auth/email/login',
          data: SessionAdapter.toJson(credentials: credentials),
        ),
      );

      return Right(SessionAdapter.fromJson(response.data));
    } on BaseException catch (err) {
      if (err.data['erros']['email'] == 'emailNotExists') {
        return const Left(
            DefaultException(message: 'E-mail não foi encontrado'));
      }

      if (err.data['erros']['password'] == 'incorrectPassword') {
        return const Left(DefaultException(message: 'Senha incorreta'));
      }
      return Left(DefaultException(message: err.message));
    } catch (_) {
      return const Left(DefaultException(message: 'Erro desconhecido'));
    }
  }
}
