class AppRouteNames {
  static const String login = 'login';
  static const String projects = 'projects';
  static const String projectDetails = 'projectDetails';
  static const String projectOverview = 'projectOverview';
  static const String projectMilestones = 'projectMilestones';
  static const String projectTasks = 'projectTasks';
  static const String projectTimeline = 'projectTimeline';
  static const String projectTeam = 'projectTeam';

  static const String myWork = 'myWork';
  static const String settings = 'settings';
  static const String themePreview = 'themePreview';
}

class AppRoutePaths {
  static const login = '/login';
  static const projects = '/projects';
  static const projectDetails = ':id';
  static const projectMilestones = '/projects/:id/milestones';
  static const projectTasks = '/projects/:id/tasks';
  
  static const myWork = '/my-work';
  static const settings = '/settings';
  static const themePreview = '/theme-preview';
}
