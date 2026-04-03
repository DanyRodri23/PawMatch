class UserModel {
  String id;
  String name;
  String image;
  List<String> followers;
  List<String> following;

  UserModel({
    required this.id,
    required this.name,
    required this.image,
    List<String>? followers,
    List<String>? following,
  })  : followers = followers ?? [],
        following = following ?? [];
}

class CommentModel {
  String userId;
  String text;
  List<CommentModel> replies;

  CommentModel({
    required this.userId,
    required this.text,
    List<CommentModel>? replies,
  }) : replies = replies ?? [];
}

class PostModel {
  String id;
  String userId;
  String image;
  String description;
  List<String> likes;
  List<CommentModel> comments;

  PostModel({
    required this.id,
    required this.userId,
    required this.image,
    required this.description,
    List<String>? likes,
    List<CommentModel>? comments,
  })  : likes = likes ?? [],
        comments = comments ?? [];
}

class SocialData {

  static String currentUserId = "user1";

  static List<UserModel> users = [

    UserModel(id: "user1", name: "Rocky 🐶", image: ""),
    UserModel(id: "user2", name: "Luna 🐾", image: ""),
  ];

  static List<PostModel> posts = [

    PostModel(
      id: "post1",
      userId: "user2",
      image: "https://images.unsplash.com/photo-1548199973-03cce0bbc87b",
      description: "Jugando en el parque 🌳",
    ),
  ];

  static void toggleFollow(String targetId) {
    final current = users.firstWhere((u) => u.id == currentUserId);
    final target = users.firstWhere((u) => u.id == targetId);

    if (current.following.contains(targetId)) {
      current.following.remove(targetId);
      target.followers.remove(currentUserId);
    } else {
      current.following.add(targetId);
      target.followers.add(currentUserId);
    }
  }

  static void toggleLike(String postId) {
    final post = posts.firstWhere((p) => p.id == postId);

    if (post.likes.contains(currentUserId)) {
      post.likes.remove(currentUserId);
    } else {
      post.likes.add(currentUserId);
    }
  }

  static void addComment(String postId, String text) {
    final post = posts.firstWhere((p) => p.id == postId);

    post.comments.add(
      CommentModel(userId: currentUserId, text: text),
    );
  }

  static void replyComment(String postId, int index, String text) {
    final post = posts.firstWhere((p) => p.id == postId);

    post.comments[index].replies.add(
      CommentModel(userId: currentUserId, text: text),
    );
  }

  static void deleteComment(String postId, int index) {
    final post = posts.firstWhere((p) => p.id == postId);
    post.comments.removeAt(index);
  }
}