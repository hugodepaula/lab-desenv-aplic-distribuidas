import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:offline_first/core/constant/app_constants.dart';
import 'package:offline_first/core/dependency_injection/di.dart';
import 'package:offline_first/feature/home/presentation/provider/cubit/news_cubit.dart';
import 'package:offline_first/feature/home/presentation/widgets/news_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NewsCubit>(
      create: (inner) => sl<NewsCubit>()..newsFlow(),
      child: Scaffold(
        appBar: AppBar(title: const Text(AppConstants.appName)),
        body: BlocConsumer<NewsCubit, NewsState>(
          listener: (context, state) {
            state.maybeMap(
              orElse: () {},
              localDbError: (value) =>
                  ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Local Db Error :(')),
              ),
            );
          },
          builder: (context, state) {
            return state.maybeMap(
              orElse: SizedBox.shrink,
              loading: (value) =>
                  const Center(child: CircularProgressIndicator()),
              loaded: (value) => Center(
                child: ListView.separated(
                  itemCount: value.articles.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final article = value.articles[index];
                    return NewsCard(article: article);
                  },
                ),
              ),
              error: (value) => Center(child: Text(value.message ?? 'Error')),
            );
          },
        ),
      ),
    );
  }
}
