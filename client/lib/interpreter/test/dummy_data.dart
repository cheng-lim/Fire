// ignore_for_file: non_constant_identifier_names

import 'package:fire_dev/interpreter/model/response.dart';

class DummyData {
  static Response _encapsule(List<Map<String, dynamic>> docs) {
    return Response(code: 'Z001', values: docs, isParsed: true);
  }

  static final Response placeholder = _encapsule([{}]);

  static final Response noValues = Response(code: 'Z002', isParsed: true);

  static final Response tokyo = _encapsule([_tokyo]);
  static final Response london = _encapsule([_london]);
  static final Response seattle = _encapsule([_seattle]);
  static final Response tokyo_seattle = _encapsule([_tokyo, _seattle]);
  static final Response seattle_london = _encapsule([_seattle, _london]);
  static final Response tokyo_london = _encapsule([_tokyo, _london]);
  static final Response tokyo_seattle_london =
      _encapsule([_tokyo, _seattle, _london]);

  static final Response test_doc = _encapsule([_test_doc]);
  static final Response test_doc2 = _encapsule([_test_doc2]);
  static final Response test_doc_doc2 = _encapsule([_test_doc, _test_doc2]);

  static final Response garry = _encapsule([_garry]);
  static final Response mary = _encapsule([_mary]);
  static final Response rose = _encapsule([_rose]);
  static final Response garry_mary = _encapsule([_garry, _mary]);
  static final Response garry_rose = _encapsule([_garry, _rose]);
  static final Response mary_rose = _encapsule([_mary, _rose]);
  static final Response gary_mary_rose = _encapsule([_garry, _mary, _rose]);

  static final Map<String, dynamic> _tokyo = {
    'id': 'tokyo',
    'data': {
      'country': 'japan',
      'neighbor_cities': ['osaka', 'nagoya', 'kyoto'],
      'population': 2000000,
      'has_lakes': false,
      'birth_rate': 0.89,
    },
  };

  static final Map<String, dynamic> _seattle = {
    'id': 'seattle',
    'data': {
      'country': 'usa',
      'neighbor_cities': ['san francisco', 'los angeles', 'oakland'],
      'population': 1500000,
      'has_lakes': true,
    },
  };

  static final Map<String, dynamic> _london = {
    'id': 'london',
    'data': {
      'country': 'uk',
      'neighbor_cities': ['chelsea', 'oxford', 'cambridge'],
      'population': 123123123,
      'has_lakes': true,
    },
  };

  static final Map<String, dynamic> _test_doc = {
    'id': 'test_doc',
    'data': {
      'has_hurricane': null,
    },
  };

  static final Map<String, dynamic> _test_doc2 = {
    'id': 'test_doc2',
    'data': {
      'has_hurricane': true,
    },
  };

  static final Map<String, dynamic> _garry = {
    'id': 'garry',
    'data': {
      'grades': ['13', 99, 1.1, false],
      'weight': 133.21,
    },
  };

  static final Map<String, dynamic> _mary = {
    'id': 'mary',
    'data': {
      'grades': [2.5, '11', 90, true, null],
      'weight': 100.33,
    },
  };

  static final Map<String, dynamic> _rose = {
    'id': 'rose',
    'data': {
      'grades': [90, '10', false, null, 3.2],
      'weight': 142,
    },
  };
}
