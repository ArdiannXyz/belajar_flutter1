import '../services/database_service.dart';

class UserRepository {
  final DatabaseService _databaseService;

  UserRepository(this._databaseService);

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    try {
      final db = await _databaseService.database;
      final List<Map<String, dynamic>> results = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      ).timeout(DatabaseService.timeoutDuration);

      return results.isNotEmpty ? results.first : null;
    } on TimeoutException catch (e) {
      throw DatabaseException(
          'Query timeout while getting user: ${e.toString()}');
    } catch (e) {
      throw DatabaseException('Error getting user: ${e.toString()}');
    }
  }
}
