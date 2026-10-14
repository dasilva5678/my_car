import 'dart:async';

import 'package:equatable/equatable.dart';

sealed class VehiclesEvent extends Equatable {
  const VehiclesEvent();

  @override
  List<Object?> get props => [];
}

/// Carrega (ou recarrega) a lista. Com a lista já na tela, recarrega sem
/// voltar para o loading.
///
/// [completer] é concluído ao fim do carregamento — usado pelo
/// pull-to-refresh, já que um resultado igual ao atual não emite estado.
final class VehiclesRequested extends VehiclesEvent {
  final Completer<void>? completer;

  const VehiclesRequested({this.completer});
}

/// [completer] recebe `true` quando a remoção deu certo.
final class VehicleDeleted extends VehiclesEvent {
  final String id;
  final Completer<bool>? completer;

  const VehicleDeleted(this.id, {this.completer});

  @override
  List<Object?> get props => [id];
}
