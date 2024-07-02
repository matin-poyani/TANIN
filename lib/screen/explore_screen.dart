import 'package:flutter/material.dart';
import 'package:get/get.dart';
<<<<<<< HEAD
import '../controllers/music_controller.dart';
import '../models/color_style.dart';
import '../widget/explore_section.dart';

class ExploreScreen extends StatelessWidget {
  final MusicController musicController = Get.put(MusicController());

  ExploreScreen({super.key});
=======
import '../models/color_style.dart';
import '../widget/mini_player.dart';
import 'Search_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Post> posts = fetchPosts();

    return Scaffold(
      backgroundColor: const ColorStyle().colorDark,
      appBar: AppBar(
        title: const Text('TANIN', style: TextStyle(color: Colors.yellow)),
        iconTheme: const IconThemeData(color: Colors.yellow),
        backgroundColor: const ColorStyle().colorDark,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Get.to(SearchScreen());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            Post post = posts[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetailsScreen(post: post),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    Image.network(
                      post.imageUrl,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 150,
                      left: 8,
                      child: Text(
                        post.caption,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 120,
                      right: 8,
                      child: Icon(
                        Icons.play_circle_outline,
                        color: Colors.lightBlueAccent,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomSheet: MiniPlayer(),
    );
  }
}

class PostDetailsScreen extends StatelessWidget {
  final Post post;

  const PostDetailsScreen({super.key, required this.post});
>>>>>>> 1bcdb9e345d239daeed9a727f023a8843cb8a9ad

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      backgroundColor: const ColorStyle().colorDark,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: ExploreSection()),
            ],
          ),
=======
      appBar: AppBar(
        title: const Text('Post Details'),
      ),
      body: Column(
        children: [
          Image.network(
            post.imageUrl,
            fit: BoxFit.cover,
          ),
          Text(post.caption),
>>>>>>> 1bcdb9e345d239daeed9a727f023a8843cb8a9ad
        ],
      ),
    );
  }
}
<<<<<<< HEAD
=======

class Post {
  final String imageUrl;
  final String caption;

  Post({required this.imageUrl, required this.caption});
}

List<Post> fetchPosts() {
  return [
    Post(
      imageUrl: 'https://upmusics.com/wp-content/uploads/2023/12/photo_2023-12-20_18-00-04.jpg',
      caption: 'This is the caption for post 1',
    ),
    Post(
      imageUrl: 'https://upmusics.com/wp-content/uploads/2023/12/photo_2023-12-27_15-34-09.jpg',
      caption: 'This is the caption for post 2',
    ),
    // Add more posts...
  ];
}
>>>>>>> 1bcdb9e345d239daeed9a727f023a8843cb8a9ad
