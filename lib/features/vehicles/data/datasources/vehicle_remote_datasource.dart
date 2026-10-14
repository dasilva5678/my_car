import 'package:my_car/core/error/exceptions.dart';
import 'package:my_car/core/network/api_client.dart';
import 'package:my_car/core/network/endpoints.dart';
import 'package:my_car/features/vehicles/data/models/vehicle_model.dart';

abstract interface class VehicleRemoteDataSource {
  Future<List<VehicleModel>> getVehicles();

  Future<VehicleModel> createVehicle(VehicleModel vehicle);

  Future<VehicleModel> updateVehicle(VehicleModel vehicle);

  Future<void> deleteVehicle(String id);
}

class VehicleRemoteDataSourceImpl implements VehicleRemoteDataSource {
  final ApiClient _client;

  const VehicleRemoteDataSourceImpl(this._client);

  @override
  Future<List<VehicleModel>> getVehicles() async {
    final data = await _client.get(Endpoints.vehicles);
    return _extractList(data).map(_parseVehicle).toList();
  }

  @override
  Future<VehicleModel> createVehicle(VehicleModel vehicle) async {
    final data = await _client.post(Endpoints.vehicles, data: vehicle.toMap());
    return _parseVehicle(_unwrap(data));
  }

  @override
  Future<VehicleModel> updateVehicle(VehicleModel vehicle) async {
    final data = await _client.put(
      Endpoints.vehicle(vehicle.id),
      data: vehicle.toMap(),
    );
    return _parseVehicle(_unwrap(data));
  }

  @override
  Future<void> deleteVehicle(String id) async {
    // 204 não traz corpo; erros chegam como AppException.
    await _client.delete(Endpoints.vehicle(id));
  }

  /// Aceita `[...]`, `{data: [...]}` e `{content: [...]}` (página do Spring).
  /// Corpo vazio equivale a lista vazia.
  List<dynamic> _extractList(dynamic responseData) {
    if (responseData == null || responseData == '') return const [];
    final list = responseData is Map
        ? responseData['data'] ?? responseData['content']
        : responseData;
    if (list is! List) {
      throw const ParseException('Lista de veículos inválida.');
    }
    return list;
  }

  dynamic _unwrap(dynamic responseData) =>
      responseData is Map && responseData['data'] is Map
          ? responseData['data']
          : responseData;

  VehicleModel _parseVehicle(dynamic json) {
    if (json is! Map) {
      throw const ParseException('Veículo não é um objeto.');
    }
    if (json['id'] == null) {
      throw const ParseException('Veículo sem id.');
    }
    return VehicleModel.fromMap(Map<String, dynamic>.from(json));
  }
}
