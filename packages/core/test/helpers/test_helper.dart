import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/utils/ssl_client_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks(
  [DatabaseHelper, SslClientProvider],
  customMocks: [MockSpec<http.Client>(as: #MockHttpClient)],
)
void main() {}
