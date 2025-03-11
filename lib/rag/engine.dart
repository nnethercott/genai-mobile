import 'package:fonnx/models/minilml6v2/mini_lm_l6_v2.dart';
import 'package:path_provider/path_provider.dart';
import 'utils.dart';
import 'package:genai_mobile/models/document.dart';
import 'package:genai_mobile/objectbox.g.dart';
import 'package:path/path.dart' as p;
import 'package:objectbox/objectbox.dart';

@Entity()
class InternalDoc {
  @Id()
  int id = 0;

  // Foreign key to document database
  @Index(type: IndexType.hash)
  String uid;

  @HnswIndex(dimensions: 384)
  @Property(type: PropertyType.floatVector)
  List<double>? embedding;

  InternalDoc(this.uid, this.embedding);
}

class ObjectBoxService implements VectorService {
  late final Store store;
  late final MiniLmL6V2 embeddingModel;

  // Constructors
  ObjectBoxService._create(this.store, this.embeddingModel);

  static Future<ObjectBoxService> create() async {
    // initialize object store
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(
      directory: p.join(docsDir.path, "docs_store"),
    );

    // initialize model
    final modelPath = await getModelPath('embed.onnx');
    final model = MiniLmL6V2.load(modelPath);

    return ObjectBoxService._create(store, model);
  }

  @override
  Future<void> add(Document doc) async {
    if (doc.content != null) {
      final embedding = await getEmbeding(doc.content!, embeddingModel);
      final x = InternalDoc(doc.id, embedding);

      final box = store.box<InternalDoc>();
      box.put(x);
    }
  }

  @override
  Future<void> delete(Document doc) async {
    final box = store.box<InternalDoc>();
    await box.query(InternalDoc_.uid.equals(doc.id)).build().removeAsync();
  }

  @override
  Future<List<String>> query(String prompt, [int nNearestNeighbors = 10]) async {
    final queryEmbedding = await getEmbeding(prompt, embeddingModel);

    final box = store.box<InternalDoc>();
    final query =
        box
            .query(
              InternalDoc_.embedding.nearestNeighborsF32(
                queryEmbedding,
                nNearestNeighbors,
              ),
            )
            .build();

    // get results
    final results = await query.findWithScoresAsync();
    return results.map((o) => o.object.uid).toList();
  }
}

// FIXME: make this generic with Embedding trait
Future<List<double>> getEmbeding(String text, MiniLmL6V2 model) async {
  var v = await model.getEmbeddingAsVector(
    MiniLmL6V2.tokenizer.tokenize(text).first.tokens,
  );

  // normalize
  v = v / v.norm();
  return v.toList();
}

/// Interface for document retreival
abstract class VectorService {
  Future<void> add(Document doc);
  Future<void> delete(Document doc);
  Future<List<String>> query(String prompt, [int nNearestNeighbors = 10]);
}
