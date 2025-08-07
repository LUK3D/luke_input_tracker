import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luke_input_tracker/luke_input_tracker.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async => await LukeInputTracker.init());
  test('Should have permission', () async {
    expect( await LukeInputTracker.isAccessibilityPermissionGranted(), true);
  });
}
