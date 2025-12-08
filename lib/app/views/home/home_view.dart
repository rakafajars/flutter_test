import 'package:flutter/material.dart';

import '../../widgets/category_chip.dart';
import '../../widgets/news_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              bottom: 20,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF7B1FA2), Color(0xFF9C27B0)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Top News',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Indonesia',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      CategoryChip(label: 'Lokal', isSelected: true),
                      CategoryChip(label: 'Politics', isSelected: false),
                      CategoryChip(label: 'Tech', isSelected: false),
                      CategoryChip(label: 'Sport', isSelected: false),
                      CategoryChip(label: 'Entertainment', isSelected: false),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                NewsCard(
                  title:
                      'Government announces new plan to support small businesses',
                  source: 'The News',
                  time: '2h ago',
                  imageUrl: 'https://picsum.photos/400/200?random=1',
                  isFeatured: true,
                ),
                NewsCard(
                  title:
                      'New technology is transforming the renewable energy sector',
                  source: 'Daily Post',
                  time: '4h ago',
                  imageUrl: 'https://picsum.photos/400/200?random=2',
                ),
                NewsCard(
                  title:
                      'Political leaders meet to discuss recent policy changes',
                  source: 'National Times',
                  time: '6h ago',
                  imageUrl: 'https://picsum.photos/400/200?random=3',
                ),
                NewsCard(
                  title:
                      'Economy shows signs of recovery after a year of challenges',
                  source: 'Global News',
                  time: '12h ago',
                  imageUrl: 'https://picsum.photos/400/200?random=4',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
