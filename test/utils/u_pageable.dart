import 'package:flavormate/data/models/local/pageable_dto.dart';

abstract class UPageableDto {
  static PageableDto<T> fromTestData<T>(List<T> input) {
    return PageableDto(
      metadata: Metadata(
        totalElements: input.length,
        pageSize: input.length,
        currentPage: 1,
        totalPages: 1,
      ),
      data: input,
    );
  }
}
