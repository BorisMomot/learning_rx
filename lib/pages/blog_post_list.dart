import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:learning_rx/models/blog_post.dart';
import 'package:learning_rx/viewmodels/blog_post_vm.dart';
import 'package:learning_rx/pages/blog_post_modify.dart';

class BlogPostList extends StatelessWidget {
  BlogPostViewModel get _vm => GetIt.I<BlogPostViewModel>();

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.month}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learn Rx'),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: StreamBuilder<List<BlogPost>>(
          stream: _vm.outBlogPostList,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            final blogPosts = snapshot.data;

            return ListView.builder(
                itemCount: blogPosts.length,
                itemBuilder: (BuildContext context, int index) {
                  final blogPost = blogPosts[index];
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 12, right: 12, top: 8, bottom: 8),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => BlogPostModify(
                                  blogPost: blogPost,
                                )));
                      },
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              blogPost.title,
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              formatDate(blogPost.publishDate),
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                  );
                });
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        elevation: 30,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => BlogPostModify()));
        },
      ),
    );
  }
}
