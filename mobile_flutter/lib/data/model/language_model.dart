import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LanguageModel extends Equatable {
  final String key;
  final String title;
  final Locale locale;

  const LanguageModel({
    required this.key,
    required this.title,
    required this.locale,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        key,
        title,
        locale,
      ];
}
