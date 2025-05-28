import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:offline_first/core/dependency_injection/di.dart';
import 'package:offline_first/core/extension/num_x.dart';
import 'package:offline_first/core/services/cache_service/local_cache_manager.dart';
import 'package:offline_first/core/services/navigation_service/i_navigation_service.dart';
import 'package:offline_first/feature/home/domain/entity/article.dart';
import 'package:offline_first/feature/news_detail/presentation/view/news_detail_view.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({
    required this.article,
    super.key,
  });

  final Article article;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        sl<INavigationService>()
            .push(context, NewsDetailView(article: article));
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.titleVal ?? '',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('by ${article.authorVal ?? ''}'),
            CachedNetworkImage(
              imageUrl: article.urlToImageVal ?? '',
              memCacheHeight: 200.cacheSize(context),
              cacheManager: LocalCacheManager.instance,
            ),
          ],
        ),
      ),
    );
  }
}
