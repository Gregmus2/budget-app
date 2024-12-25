import 'package:fb/config.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:sync_proto_gen/sync/sync.pbgrpc.dart';

class SyncService {
  late SyncServiceClient _client;

  Future init() async {
    final address = GlobalConfig().apiURL.split(':');
    final channel = GrpcOrGrpcWebClientChannel.toSingleEndpoint(
        host: address[0], port: int.parse(address[1]), transportSecure: GlobalConfig().secureTransport);
    _client = SyncServiceClient(channel);
  }

  Future<List<Operation>?> syncData(Iterable<Operation> data) async {
    SyncDataResponse response;

    try {
      response = await _client.syncData(SyncDataRequest(operations: data));

      return response.operations;
    } catch (e) {
      // todo handle properly
      print('Error syncing data: $e');
    }

    return null;
  }
}