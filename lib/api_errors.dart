/// {@category api}

library api_error_fields;

import 'dart:convert';

abstract class ApiErrorFields {
  toMap() {
    return {'_': 'NOT IMPLEMENTED'};
  }

  String toJson() => json.encode(toMap());
}

mixin Messages on ApiErrorFields {
  static List<String>? decode(List<dynamic>? messages) =>
      messages != null ? List<String>.from(messages.map((x) => x)) : null;

  List<dynamic>? encodeMessages(List<String>? messages) => messages != null
      ? List<dynamic>.from(
          messages.map((x) => x),
        )
      : null;
}
