import 'package:app/features/my_work/presentation/models/time_tracking_summary.dart';
import 'package:app/features/my_work/presentation/providers/my_tasks_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

double _parseHours(String label) {
  // Parse labels like "8h" or "8.5h"
  final match = RegExp(r'(\d+\.?\d*)').firstMatch(label);
  if (match != null) {
    return double.tryParse(match.group(1)!) ?? 0;
  }
  return 0;
}

final myTimeSummaryProvider = Provider<TimeTrackingSummary>((ref) {
  final asyncTasks = ref.watch(myTasksProvider);

  return asyncTasks.when(
    data: (result) {
      double totalEstimate = 0;
      double totalLogged = 0;

      for (final task in result.items) {
        if (task.estimateHoursLabel != null) {
          totalEstimate += _parseHours(task.estimateHoursLabel!);
        }
        if (task.loggedHoursLabel != null) {
          totalLogged += _parseHours(task.loggedHoursLabel!);
        }
      }

      return TimeTrackingSummary(
        totalEstimatedHours: totalEstimate,
        totalLoggedHours: totalLogged,
        remainingHours: (totalEstimate - totalLogged).clamp(0, double.infinity),
      );
    },
    loading: () => TimeTrackingSummary.empty(),
    error: (_, __) => TimeTrackingSummary.empty(),
  );
});
