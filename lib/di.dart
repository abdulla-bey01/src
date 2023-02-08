import 'package:get_it/get_it.dart';
import 'package:str/counter_repositories.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<ICounterRepository>(
    //if we want to keep counter data on shared preferences we use SharedPreferencesCounterRepository()
    //if we want to keep counter data on secure storage we use SecureStorageCounterRepository()
    //if we want to keep counter data on remote repository we use RemoteCounterRepository()
    SharedPreferencesCounterRepository(),
  );
}
