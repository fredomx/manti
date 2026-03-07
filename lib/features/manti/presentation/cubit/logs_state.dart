import 'package:equatable/equatable.dart';
import 'package:manti/features/manti/domain/entities/maintenance_log.dart';

class LogsState extends Equatable {
  final bool isLoading;
  final List<MaintenanceLog> logs;
  final String? errorMessage;

  const LogsState({
    this.isLoading = false,
    this.logs = const [],
    this.errorMessage,
  });

  LogsState copyWith({
    bool? isLoading,
    List<MaintenanceLog>? logs,
    String? errorMessage,
  }) {
    return LogsState(
      isLoading: isLoading ?? this.isLoading,
      logs: logs ?? this.logs,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, logs, errorMessage];
}
