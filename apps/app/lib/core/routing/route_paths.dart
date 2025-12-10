class RoutePaths {
  static const String login = '/login';
  static const String projects = '/projects';
  static const String myWork = '/my-work';
  static const String settings = '/settings';

  static String projectDetails(String id) => '/projects/$id';

  static String projectOverview(String id) => '/projects/$id/overview';
  static String projectTasks(String id) => '/projects/$id/tasks';
  static String projectTimeline(String id) => '/projects/$id/timeline';
  static String projectFiles(String id) => '/projects/$id/files';
  static String projectTeam(String id) => '/projects/$id/team';
}