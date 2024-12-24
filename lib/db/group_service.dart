import 'dart:convert';

import 'package:fb/config.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:sync_proto_gen/sync/sync.pbgrpc.dart';

class GroupService {
  late SyncServiceClient _client;

  Future init() async {
    final address = GlobalConfig().apiURL.split(':');
    final channel = GrpcOrGrpcWebClientChannel.toSingleEndpoint(
        host: address[0], port: int.parse(address[1]), transportSecure: GlobalConfig().secureTransport);
    _client = SyncServiceClient(channel);
  }

  Future<void> joinGroup(String groupId) async {
    try {
      await _client.joinGroup(JoinGroupRequest(group: groupId));
    } catch (e) {
      // todo handle properly
      print('Error joining group: $e');
    }
  }

  Future<void> leaveGroup(String groupId) async {
    try {
      await _client.leaveGroup(LeaveGroupRequest(group: groupId));
    } catch (e) {
      // todo handle properly
      print('Error leaving group: $e');
    }
  }
}