import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../application/internal/queryservices/person_directory_query_service_impl.dart';
import '../../../interfaces/rest/transform/identity_transform.dart';
import 'registered_persons_state.dart';

class RegisteredPersonsCubit extends Cubit<RegisteredPersonsState> {
  final PersonDirectoryQueryServiceImpl queryService;

  RegisteredPersonsCubit({required this.queryService}) : super(const RegisteredPersonsState());

  Future<void> loadPersons({int page = 1, int pageSize = 20}) async {
    emit(state.copyWith(status: RegisteredPersonsStatus.loading, errorMessage: null));

    try {
      final query = toGetRegisteredPersonsQuery(page: page, pageSize: pageSize);
      final response = await queryService.handleGetRegisteredPersons(query);
      emit(
        state.copyWith(
          status: response.items.isEmpty ? RegisteredPersonsStatus.empty : RegisteredPersonsStatus.success,
          page: response,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RegisteredPersonsStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
