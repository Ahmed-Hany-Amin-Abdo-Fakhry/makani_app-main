part of 'personal_info_cubit.dart';

enum PersonalInfoSaveStatus {
  initial,
  saving,
  success,
  failure,
}

final class PersonalInfoState {
  const PersonalInfoState({
    required this.isEditing,
    required this.fullName,
    required this.email,
    required this.phoneCountry,
    required this.phoneNumber,
    required this.passwordMasked,
    required this.draftFullName,
    required this.draftEmail,
    required this.draftPhoneCountry,
    required this.draftPhoneNumber,
    required this.draftPassword,
    this.saveStatus = PersonalInfoSaveStatus.initial,
    this.errorMessage,
  });

  final bool isEditing;
  final String fullName;
  final String email;
  final String phoneCountry;
  final String phoneNumber;
  final String passwordMasked;

  final String draftFullName;
  final String draftEmail;
  final String draftPhoneCountry;
  final String draftPhoneNumber;
  final String draftPassword;

  final PersonalInfoSaveStatus saveStatus;
  final String? errorMessage;

  PersonalInfoState copyWith({
    bool? isEditing,
    String? fullName,
    String? email,
    String? phoneCountry,
    String? phoneNumber,
    String? passwordMasked,
    String? draftFullName,
    String? draftEmail,
    String? draftPhoneCountry,
    String? draftPhoneNumber,
    String? draftPassword,
    PersonalInfoSaveStatus? saveStatus,
    String? errorMessage,
  }) {
    return PersonalInfoState(
      isEditing: isEditing ?? this.isEditing,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneCountry: phoneCountry ?? this.phoneCountry,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      passwordMasked: passwordMasked ?? this.passwordMasked,
      draftFullName: draftFullName ?? this.draftFullName,
      draftEmail: draftEmail ?? this.draftEmail,
      draftPhoneCountry: draftPhoneCountry ?? this.draftPhoneCountry,
      draftPhoneNumber: draftPhoneNumber ?? this.draftPhoneNumber,
      draftPassword: draftPassword ?? this.draftPassword,
      saveStatus: saveStatus ?? this.saveStatus,
      errorMessage: errorMessage,
    );
  }
}

