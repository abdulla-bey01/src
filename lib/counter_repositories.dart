import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

//we need this base class because of dependency injection
//we use this

/*di container            Base class         Implementation
  getIt.registerSingleton<ICounterRepository>(SharedPreferencesCounterRepository());
  now we are using SharedPreferencesCounterRepository() as an implementation. 
  If we need to keep counter data in secure storage, 
  we will only change SharedPreferencesCounterRepository() to SecureStorageCounterRepository()
*/
abstract class ICounterRepository {
  Future<int> get();
  Future<bool> save(int i);
  Future<bool> update(int i);
  Future<bool> remove();
}
//if we want to add new repository to keep counter data, we should implement it from ICounterRepository.
//for example we decided to use hive to keep counter data,
//we just create class HiveCounterRepository implements ICounterRepository{}
//and will update id in DI container di container            Base class         Implementation
//                                   getIt.registerSingleton<ICounterRepository>(SharedPreferencesCounterRepository());

//
//
//
//SharedPreferences implementation of ICounterRepository
class SharedPreferencesCounterRepository implements ICounterRepository {
  @override
  Future<int> get() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('counter') ?? 0;
  }

  @override
  Future<bool> remove() async {
    final prefs = await SharedPreferences.getInstance();
    final removed = await prefs.remove('counter');
    return removed;
  }

  @override
  Future<bool> save(int i) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = await prefs.setInt('counter', i);
    return saved;
  }

  @override
  Future<bool> update(int i) async {
    return await save(i);
  }
}

//
//
//
//SecureStorage implementation of ICounterRepository
class SecureStorageCounterRepository implements ICounterRepository {
  final storage = const FlutterSecureStorage();
  @override
  Future<int> get() async {
    int i;
    final value = await storage.read(key: 'counter-secure-storage');
    if (value == null) {
      i = 0;
    } else {
      i = int.tryParse(value)!;
    }
    return i;
  }

  @override
  Future<bool> remove() async {
    try {
      await storage.delete(key: 'counter-secure-storage');
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> save(int i) async {
    try {
      await storage.write(key: 'counter-secure-storage', value: i.toString());
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> update(int i) async {
    return await save(i);
  }
}

//
//
//
///we create this abstratc class to keep httpclient and some information like host inside oh it
abstract class INetworkManager {
  final Client client;
  final String host;
  INetworkManager({required this.client, required this.host});
}

//
//
//
//we extend this class from INetworkManager implement-override client and host properties of first host
class IFirstHostNetworkManager extends INetworkManager {
  IFirstHostNetworkManager()
      : super(client: Client(), host: 'https://firsthost.com');
}

//
//
//
//we extend this class from INetworkManager implement-override client and host properties of second host
class ISecondHostNetworkManager extends INetworkManager {
  ISecondHostNetworkManager()
      : super(client: Client(), host: 'https://secondhost.com');
}

//if we want to work with first host data source we should extend this class from IFirstHostNetworkManager
//if we want to work with second host data source we should extend this class from ISecondHostNetworkManager
//we implement this class from ICounterRepository because of that the class get and pass counter repository abstract methods, properties to theis children
abstract class ICounterFirstNetworkManager extends IFirstHostNetworkManager
    implements ICounterRepository {}

//same ^
abstract class ICounterSecondNetworkManager extends ISecondHostNetworkManager
    implements ICounterRepository {}

//
//
//
//finally we create remote repository implementation of counter repository
//if we want work with first counter host we extends this class from ICounterFirstNetworkManager.
//if we want work with second counter host we extends this class from ICounterSecondNetworkManager.
//Remember ICounterFirstNetworkManager delivers ICounterRepository methods, properties, etc and host and client of IFirstHostNetworkManager.
//ICounterSecondNetworkManager delivers ICounterRepository methods, properties, etc and host and client of ICounterSecondNetworkManager.
class RemoteCounterRepository extends ICounterFirstNetworkManager {
  @override
  Future<int> get() {
    throw UnimplementedError();
  }

  @override
  Future<bool> remove() {
    throw UnimplementedError();
  }

  @override
  Future<bool> save(int i) {
    throw UnimplementedError();
  }

  @override
  Future<bool> update(int i) {
    throw UnimplementedError();
  }
}
