import 'package:oreed_clean/features/home/domain/repositories/home_repo.dart';

import '../entities/section_entity.dart';

class GetSectionsUseCase {
  final MainHomeRepository repository;
  GetSectionsUseCase(this.repository);
  Future<List<SectionEntity>> call(int? companyId) =>
      repository.getSections(companyId);
}
