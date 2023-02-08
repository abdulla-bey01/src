import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_page_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: BlocBuilder<HomePageViewModel, int>(
        builder: (context, count) => Center(
            child: Text(
          '$count',
          style: const TextStyle(fontSize: 25),
        )),
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => context.read<HomePageViewModel>().increment(),
          ),
          const SizedBox(height: 4),
          FloatingActionButton(
            child: const Icon(Icons.data_object),
            onPressed: () => context.read<HomePageViewModel>().getInt(),
          ),
        ],
      ),
    );
  }
}
