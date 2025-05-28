import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:offline_first/core/extension/num_x.dart';
import 'package:offline_first/core/services/cache_service/local_cache_manager.dart';
import 'package:offline_first/feature/home/domain/entity/article.dart';
import 'package:offline_first/feature/news_detail/presentation/widgets/news_detail_text_body.dart';

class NewsDetailView extends StatelessWidget {
  const NewsDetailView({
    required this.article,
    super.key,
  });
  final Article article;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article.sourceVal ?? '')),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          CachedNetworkImage(
            imageUrl: article.urlToImageVal ?? '',
            memCacheHeight: 200.cacheSize(context),
            cacheManager: LocalCacheManager.instance,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              article.titleVal ?? '',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          NewsDetailTextBody(content: 'by ${article.authorVal ?? ''}'),
          NewsDetailTextBody(content: article.descriptionVal ?? ''),
          NewsDetailTextBody(content: article.contentVal ?? ''),
        ],
      ),
    );
  }
}
