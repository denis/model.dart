library model_tests;

import 'dart:html' as html;
import 'dart:json' as json;
import 'dart:async';
import 'package:unittest/unittest.dart';
import 'package:unittest/mock.dart';
import 'package:unittest/html_config.dart';

import 'package:model/model.dart';

import 'http_request_mock.dart';
part 'storage/local_test.dart';
part 'storage/restful_test.dart';
part 'request_test.dart';
part 'hash_map_dirty_test.dart';

void main() {
  //localStorageTest();
  restfulStorageTest();
  requestTest();
  hashMapDirtyTest();
  // TODO: Model's tests
  // TODO: Model's factory tests
  // TODO: Model's association tests
}
