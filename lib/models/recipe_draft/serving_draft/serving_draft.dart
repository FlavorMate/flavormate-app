import 'package:dart_mappable/dart_mappable.dart';

part 'serving_draft.mapper.dart';

@MappableClass()
class ServingDraft with ServingDraftMappable {
  final double amount;
  final String label;

  ServingDraft(this.amount, this.label);
}
