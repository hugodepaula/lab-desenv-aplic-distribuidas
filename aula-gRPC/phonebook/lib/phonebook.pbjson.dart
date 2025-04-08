//
//  Generated code. Do not modify.
//  source: phonebook.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use lookupRequestDescriptor instead')
const LookupRequest$json = {
  '1': 'LookupRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `LookupRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lookupRequestDescriptor = $convert.base64Decode(
    'Cg1Mb29rdXBSZXF1ZXN0EhIKBG5hbWUYASABKAlSBG5hbWU=');

@$core.Deprecated('Use lookupResponseDescriptor instead')
const LookupResponse$json = {
  '1': 'LookupResponse',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'phone_number', '3': 2, '4': 1, '5': 9, '10': 'phoneNumber'},
    {'1': 'found', '3': 3, '4': 1, '5': 8, '10': 'found'},
  ],
};

/// Descriptor for `LookupResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lookupResponseDescriptor = $convert.base64Decode(
    'Cg5Mb29rdXBSZXNwb25zZRISCgRuYW1lGAEgASgJUgRuYW1lEiEKDHBob25lX251bWJlchgCIA'
    'EoCVILcGhvbmVOdW1iZXISFAoFZm91bmQYAyABKAhSBWZvdW5k');

