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

    // load model from disk
    final modelPath = await getModelPath('embed.onnx');
    final model = MiniLmL6V2.load(modelPath);

    return ObjectBoxService._create(store, model);
  }

  @override
  Future<void> insert(Document doc) async {
    final embedding = await getEmbeding(doc.content!, embeddingModel);
    final x = InternalDoc(doc.id, embedding);

    final box = store.box<InternalDoc>();
    box.put(x);
  }

  @override
  Future<int> purge() async {
    await Future.delayed(Duration(seconds: 1));
    return 1;
  }

  @override
  Future<List<String>> query(String text, [int nNearestNeighbors = 10]) async {
    final queryEmbedding = await getEmbeding(text, embeddingModel);

    final box = store.box<InternalDoc>();
    final query =
        box.query(InternalDoc_.embedding.nearestNeighborsF32(queryEmbedding, nNearestNeighbors)).build();

    // get results
    final results = await query.findWithScoresAsync();
    return results.map((o)=>o.object.uid).toList();
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
  // document insertion
  Future<void> insert(Document doc);
  // return ids for most similar
  Future<List<String>> query(String query, [int nNearestNeighbors = 10]);
  // purge and return howmany we cleared
  Future<int> purge();
}
