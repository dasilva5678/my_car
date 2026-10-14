import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_car/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:my_car/features/auth/presentation/bloc/forgot_password_event.dart';
import 'package:my_car/features/auth/presentation/bloc/forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordUseCase _forgotPassword;

  ForgotPasswordBloc({required ForgotPasswordUseCase forgotPassword})
      : _forgotPassword = forgotPassword,
        super(const ForgotPasswordInitial()) {
    on<ForgotPasswordSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    ForgotPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(const ForgotPasswordLoading());
    final email = event.email.trim();
    final result = await _forgotPassword(email: email);
    result.fold(
      onLeft: (failure) => emit(ForgotPasswordFailure(failure.message)),
      onRight: (_) => emit(ForgotPasswordSuccess(email)),
    );
  }
}
