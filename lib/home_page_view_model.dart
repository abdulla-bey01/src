import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:str/counter_repositories.dart';

import 'di.dart';

class HomePageViewModel extends Cubit<int> {
  HomePageViewModel() : super(0) {
    getInt();
  }

  void getInt() async {
    emit(await getIt<ICounterRepository>().get());
  }

  void increment() {
    emit(state + 1);
    getIt<ICounterRepository>().update(state);
  }
}
