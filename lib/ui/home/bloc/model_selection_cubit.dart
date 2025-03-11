import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ModelSelectionState {}

class ModelSelectionInitial extends ModelSelectionState {
  final String selectedModel;
  ModelSelectionInitial(this.selectedModel);
}

class ModelSelectionCubit extends Cubit<ModelSelectionState> {
  ModelSelectionCubit() : super(ModelSelectionInitial('llama2'));

  void selectModel(String model) {
    emit(ModelSelectionInitial(model));
  }

  String get currentModel => (state as ModelSelectionInitial).selectedModel;
}
