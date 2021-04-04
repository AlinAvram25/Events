class Post {
  String postID = '';
  String title = '';
  String description = '';
  String userID = '';
  List<String> tags = new List<String>();
  String location = '';
  String topic = '';
  String date = '';
  String userName = '';
  bool personal = false;

  bool get getPersonal => personal;

  set setPersonal(bool personal) => this.personal = personal;

  String get getUserName => userName;

  set setUserName(String userName) => this.userName = userName;

  String get getDescription => description;

  set setDescription(String description) => this.description = description;

  String get getDate => date;

  set setDate(String date) => this.date = date;

  String get getTopic => topic;

  set setTopic(String topic) => this.topic = topic;

  String get getLocation => location;

  set setLocation(String location) => this.location = location;

  String get getPostID => postID;

  set setPostID(String postID) => this.postID = postID;

  String get getTitle => title;

  set setTitle(String title) => this.title = title;

  String get getUserID => userID;

  set setUserID(String userID) => this.userID = userID;

  List<String> get getTags => tags;

  set setTags(List<String> tags) => this.tags = tags;
}
