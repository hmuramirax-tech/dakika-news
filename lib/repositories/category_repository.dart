import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dakika/models/models.dart';
import 'package:dakika/repositories/supabase_client.dart';

/// Repository for category-related database operations.
class CategoryRepository {
  final SupabaseClient _client = SupabaseClientService.client;

  /// Get all active categories.
  Future<List<Category>> getCategories() async {
    final response = await _client
        .from('categories')
        .select()
        .eq('is_active', true)
        .order('sort_order', ascending: true);

    return (response as List)
        .map((json) => Category.fromJson(json))
        .toList();
  }

  /// Get category by name.
  Future<Category?> getCategoryByName(String name) async {
    final response = await _client
        .from('categories')
        .select()
        .eq('name', name.toLowerCase())
        .maybeSingle();

    if (response == null) return null;
    return Category.fromJson(response);
  }
}
