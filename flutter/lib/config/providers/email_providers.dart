import 'package:clean_architecture/config/providers/core_providers.dart';
import 'package:clean_architecture/data/repositories/emails/email_repository.dart';
import 'package:clean_architecture/data/repositories/emails/email_repository_remote.dart';
import 'package:clean_architecture/data/services/email_api_service.dart';
import 'package:clean_architecture/domain/use_cases/delete_email_use_case.dart';
import 'package:clean_architecture/domain/use_cases/list_emails_use_case.dart';
import 'package:clean_architecture/domain/use_cases/toggle_email_read_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final emailApiServiceProvider = Provider<EmailApiService>(
  (ref) => EmailApiService(ref.watch(apiClientProvider)),
);

final emailRepositoryProvider = Provider<EmailRepository>(
  (ref) => EmailRepositoryRemote(
    ref.watch(emailApiServiceProvider),
    ref.watch(loggerProvider),
  ),
);

final listEmailsUseCaseProvider = Provider<ListEmailsUseCase>(
  (ref) => ListEmailsUseCase(ref.watch(emailRepositoryProvider)),
);

final toggleEmailReadUseCaseProvider = Provider<ToggleEmailReadUseCase>(
  (ref) => ToggleEmailReadUseCase(ref.watch(emailRepositoryProvider)),
);

final deleteEmailUseCaseProvider = Provider<DeleteEmailUseCase>(
  (ref) => DeleteEmailUseCase(ref.watch(emailRepositoryProvider)),
);
