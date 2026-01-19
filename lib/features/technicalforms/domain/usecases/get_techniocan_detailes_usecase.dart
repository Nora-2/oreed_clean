import 'package:oreed_clean/features/technicalforms/domain/entities/technican_detailes_entity.dart';
import 'package:oreed_clean/features/technicalforms/domain/repositories/technican_repo.dart';

class GetTechnicianDetailsUseCase {
  final TechnicianRepository repo;

  GetTechnicianDetailsUseCase(this.repo);

  Future<TechnicianDetailsEntity> call(int id) => repo.getTechnicianDetails(id);
}
