class AIModel {
  final String id;
  final String name;
  final String description;

  const AIModel({
    required this.id,
    required this.name,
    required this.description,
  });
}

class AIModels {
  static const llama2 = AIModel(
    id: 'llama2',
    name: 'Llama 2',
    description: 'Meta\'s open source large language model',
  );

  static const mistral = AIModel(
    id: 'mistral',
    name: 'Mistral',
    description: 'Mistral AI\'s efficient language model',
  );

  static const gpt2 = AIModel(
    id: 'gpt2',
    name: 'GPT-2',
    description: 'OpenAI\'s GPT-2 language model',
  );

  static const bert = AIModel(
    id: 'bert',
    name: 'BERT',
    description: 'Google\'s BERT language model',
  );

  static const List<AIModel> allModels = [
    llama2,
    mistral,
    gpt2,
    bert,
  ];

  static AIModel getModelById(String id) {
    return allModels.firstWhere(
      (model) => model.id == id,
      orElse: () => llama2,
    );
  }
}
