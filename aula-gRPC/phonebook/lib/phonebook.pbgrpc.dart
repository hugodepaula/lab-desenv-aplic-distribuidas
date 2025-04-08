//
//  Generated code. Do not modify.
//  source: phonebook.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'phonebook.pb.dart' as $0;

export 'phonebook.pb.dart';

@$pb.GrpcServiceName('phonebook.PhonebookService')
class PhonebookServiceClient extends $grpc.Client {
  static final _$lookupNumber = $grpc.ClientMethod<$0.LookupRequest, $0.LookupResponse>(
      '/phonebook.PhonebookService/LookupNumber',
      ($0.LookupRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.LookupResponse.fromBuffer(value));

  PhonebookServiceClient(super.channel,
      {super.options,
      super.interceptors});

  $grpc.ResponseFuture<$0.LookupResponse> lookupNumber($0.LookupRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$lookupNumber, request, options: options);
  }
}

@$pb.GrpcServiceName('phonebook.PhonebookService')
abstract class PhonebookServiceBase extends $grpc.Service {
  $core.String get $name => 'phonebook.PhonebookService';

  PhonebookServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.LookupRequest, $0.LookupResponse>(
        'LookupNumber',
        lookupNumber_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LookupRequest.fromBuffer(value),
        ($0.LookupResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.LookupResponse> lookupNumber_Pre($grpc.ServiceCall $call, $async.Future<$0.LookupRequest> $request) async {
    return lookupNumber($call, await $request);
  }

  $async.Future<$0.LookupResponse> lookupNumber($grpc.ServiceCall call, $0.LookupRequest request);
}
