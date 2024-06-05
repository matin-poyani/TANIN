import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanin/models/color_style.dart';
import '../widget/bottom_nav_bar.dart';
import 'Search_screen.dart';

class Explorer extends StatelessWidget {
  const Explorer({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch or generate content
    List<Post> posts = fetchPosts();

    return Scaffold(
      backgroundColor: const ColorStyle().colorDark,
      appBar: AppBar(  title: const Text('TANIN', style: TextStyle(color: Colors.yellow)),
          iconTheme: const IconThemeData(color: Colors.yellow),
          backgroundColor: const ColorStyle().colorDark,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Get.to(SearchScreen());
              },
            )
          ],
        ),
      bottomNavigationBar:   BottomNavBar(),
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
                // Navigate to post details screen
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
                    //caption post explorer
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
    );
  }
}

class PostDetailsScreen extends StatelessWidget {
  final Post post;

  const PostDetailsScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          // Other post details like likes, comments, etc.
        ],
      ),
    );
  }
}

class Post {
  final String imageUrl;
  final String caption;

  Post({required this.imageUrl, required this.caption});
}

// Fetch or generate dummy posts
List<Post> fetchPosts() {
  return [
    Post(
      imageUrl:
          'https://upmusics.com/wp-content/uploads/2023/12/photo_2023-12-20_18-00-04.jpg',
      caption: 'This is the caption for post 1',
    ),
    Post(
      imageUrl:
          'https://upmusics.com/wp-content/uploads/2023/12/photo_2023-12-27_15-34-09.jpg',
      caption: 'This is the caption for post 2',
    ),

    Post(
      imageUrl:
          'https://upmusics.com/wp-content/uploads/2023/12/photo_2023-12-20_18-00-04.jpg',
      caption: 'This is the caption for post 2',
    ),

    Post(
      imageUrl:
          'https://upmusics.com/wp-content/uploads/2023/12/photo_2023-12-27_15-34-09.jpg',
      caption: 'This is the caption for post 2',
    ),

    Post(
      imageUrl:
          'https://upmusics.com/wp-content/uploads/2023/12/photo_2023-12-20_18-00-04.jpg',
      caption: 'This is the caption for post 2',
    ),

    Post(
      imageUrl:
          'https://upmusics.com/wp-content/uploads/2023/12/photo_2023-12-20_18-00-04.jpg',
      caption: 'This is the caption for post 2',
    ),

    Post(
      imageUrl:
          'https://upmusics.com/wp-content/uploads/2023/12/photo_2023-12-20_18-00-04.jpg',
      caption: 'This is the caption for post 2',
    ),

    Post(
      imageUrl:
          'https://upmusics.com/wp-content/uploads/2023/12/photo_2023-12-20_18-00-04.jpg',
      caption: 'This is the caption for post 2',
    ),
    // Add more posts...
  ];
}
