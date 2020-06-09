import 'package:flutter_test/flutter_test.dart';
import 'package:lebonmarche/model/marche.dart';
import 'package:lebonmarche/services/fetch_data.dart' as dataFetch;
// Create a MockClient using the Mock class provided by the Mockito package.
// Create new instances of this class in each test.

main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('fetch_data', () {
    test('returns a List of Marche if the firestore call completes successfully', () async {
      expect(await dataFetch.getMarches(), isInstanceOf<List<Marche>>());
    });
  });
}