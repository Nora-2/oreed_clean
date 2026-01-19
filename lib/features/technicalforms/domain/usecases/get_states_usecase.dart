import 'package:oreed_clean/features/technicalforms/domain/repositories/technican_repo.dart';
import '../entities/state_entity.dart';

class GetStatesUseCase {
  final TechnicianRepository repository;

  GetStatesUseCase(this.repository);

  Future<List<StateEntity>> call() => repository.getStates();
}
