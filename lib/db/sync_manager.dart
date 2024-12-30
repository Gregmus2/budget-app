import 'package:fb/db/repository.dart';
import 'package:fb/db/sync_service.dart';

class SyncManager {
  late Repository _repository;
  late SyncService _syncService;

  SyncManager(Repository repository, SyncService syncService) {
    _repository = repository;
    _syncService = syncService;
  }

  Future sync() async {
    final operations = await _repository.getOperations();
    final syncedOperations = await _syncService.syncData(operations);
    _repository.deleteAll(tableOperations);

    if (syncedOperations != null) {
      await _repository.applyOperations(syncedOperations);
    }
  }
}