import 'package:flavormate/data/models/features/stories/story_dto.dart';

class StoriesItemWrapper {
  final StoryFullDto story;
  final bool isAdmin;
  final bool isOwner;

  StoriesItemWrapper({
    required this.story,
    required this.isAdmin,
    required this.isOwner,
  });
}
