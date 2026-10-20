import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/plant.dart';

class PlantRepository {
  PlantRepository(this._client);
  final SupabaseClient _client;

  Future<List<Plant>> fetchPlants() async {
    final data = await _client.from('plants').select().order('created_at');
    return data.map(Plant.fromJson).toList();
  }

  Future<void> addPlant({
    required String nombre,
    required int regar,
    required WateringUnit unidad,
  }) async {
    await _client.from('plants').insert({
      'nombre': nombre,
      'regar': regar,
      'unidad': unidad.name,
    });
  }

  Future<void> waterPlant(String id) async {
    await _client.rpc('regar_planta', params: {'p_id': id});
  }
}