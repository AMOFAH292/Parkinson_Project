import 'package:flutter/material.dart';

// Data model for a News Article or Resource Card
class NewsArticle {
  final String title;
  final String source;
  final String date;
  final String imageUrl;
  final IconData categoryIcon;
  final Color categoryColor;

  const NewsArticle({
    required this.title,
    required this.source,
    required this.date,
    required this.imageUrl,
    required this.categoryIcon,
    required this.categoryColor,
  });
}

class ExploreScreen extends StatelessWidget {
   const ExploreScreen({super.key});

  // Mock data for the news feed
  static const List<NewsArticle> trendingNews =  [
    NewsArticle(
      title: 'New Study Links Gut Health to Early PD Diagnosis',
      source: 'Science Today',
      date: '1 hour ago',
      imageUrl: 'https://placehold.co/600x400/80DEEA/000000?text=Gut+Health+Research',
      categoryIcon: Icons.science_outlined,
      categoryColor: Colors.teal,
    ),
    NewsArticle(
      title: 'The Role of Exercise in Managing Tremor Severity',
      source: 'Wellness Weekly',
      date: '2 days ago',
      imageUrl: 'https://placehold.co/600x400/A5D6A7/000000?text=Fitness+Tips',
      categoryIcon: Icons.fitness_center_outlined,
      categoryColor: Colors.green,
    ),
    NewsArticle(
      title: 'FDA Approves New Drug Therapy for Motor Fluctuations',
      source: 'Health News Network',
      date: '5 days ago',
      imageUrl: 'https://placehold.co/600x400/9FA8DA/000000?text=Medical+Breakthrough',
      categoryIcon: Icons.medical_services_outlined,
      categoryColor: Colors.indigo,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Explore News & Trends',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey.withValues(alpha: 0.5),
            width: 0.6,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Trending Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Trending Topics',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Horizontal Trending List
            SizedBox(
              height: 250, // Height for the horizontal list
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: trendingNews.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(left: 8.0, right: index == trendingNews.length - 1 ? 8.0 : 0),
                    child: TrendingNewsCard(article: trendingNews[index]),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),

            // Latest News Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Latest News & Research',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Vertical List of Articles
            ...trendingNews.reversed.map((article) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0, left: 24, right: 24),
                child: ArticleListItem(article: article),
              );
            }),

            const SizedBox(height: 20),
            // Call to Action / Featured Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.deepPurple.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Community Resources',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Find local support groups, educational webinars, and caregiving guides from trusted non-profits.',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.people_outline),
                        label: const Text('Explore Resources'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.deepPurple,
                          side: const BorderSide(color: Colors.deepPurple),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// CUSTOM WIDGETS
// -----------------------------------------------------------------------------

class TrendingNewsCard extends StatelessWidget {
  final NewsArticle article;

  const TrendingNewsCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              article.imageUrl,
              height: 120,
              width: 300,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 120,
                width: 300,
                color: Colors.grey.shade200,
                alignment: Alignment.center,
                child: const Text('Image Unavailable', style: TextStyle(color: Colors.grey)),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: article.categoryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(article.categoryIcon, size: 14, color: article.categoryColor),
                      const SizedBox(width: 4),
                      Text(
                        article.source,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: article.categoryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  article.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  article.date,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ArticleListItem extends StatelessWidget {
  final NewsArticle article;

  const ArticleListItem({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              article.imageUrl,
              height: 70,
              width: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 70,
                width: 70,
                color: Colors.grey.shade200,
                alignment: Alignment.center,
                child: Icon(Icons.public, size: 28, color: Colors.grey.shade400),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(article.categoryIcon, size: 14, color: article.categoryColor),
                    const SizedBox(width: 4),
                    Text(
                      article.source,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: article.categoryColor,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      article.date,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}