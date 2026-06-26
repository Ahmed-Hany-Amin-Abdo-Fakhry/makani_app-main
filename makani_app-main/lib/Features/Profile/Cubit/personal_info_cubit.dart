import 'package:flutter_bloc/flutter_bloc.dart';

part 'personal_info_state.dart';

/// Handles edit mode and saving for the Personal Information screen.
class PersonalInfoCubit extends Cubit<PersonalInfoState> {
  PersonalInfoCubit({
    required String fullName,
    required String email,
    required String phoneCountry,
    required String phoneNumberMasked,
    required String passwordMasked,
  }) : super(
          PersonalInfoState(
            isEditing: false,
            fullName: fullName,
            email: email,
            phoneCountry: phoneCountry,
            phoneNumber: phoneNumberMasked,
            passwordMasked: passwordMasked,
            draftFullName: fullName,
            draftEmail: email,
            draftPhoneCountry: phoneCountry,
            draftPhoneNumber: phoneNumberMasked,
            draftPassword: '',
          ),
        );

  void startEditing() {
    emit(
      state.copyWith(
        isEditing: true,
        saveStatus: PersonalInfoSaveStatus.initial,
        errorMessage: null,
        draftFullName: state.fullName,
        draftEmail: state.email,
        draftPhoneCountry: state.phoneCountry,
        draftPhoneNumber: state.phoneNumber,
        draftPassword: '',
      ),
    );
  }

  void cancelEditing() {
    emit(
      state.copyWith(
        isEditing: false,
        saveStatus: PersonalInfoSaveStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void updateDraftFullName(String v) => emit(state.copyWith(draftFullName: v));
  void updateDraftEmail(String v) => emit(state.copyWith(draftEmail: v));
  void updateDraftPhoneCountry(String v) =>
      emit(state.copyWith(draftPhoneCountry: v));
  void updateDraftPhoneNumber(String v) =>
      emit(state.copyWith(draftPhoneNumber: v));
  void updateDraftPassword(String v) => emit(state.copyWith(draftPassword: v));

  Future<void> saveChanges() async {
    final draftFullName = state.draftFullName.trim();
    final draftEmail = state.draftEmail.trim();
    final draftPhoneCountry = state.draftPhoneCountry.trim();
    final draftPhoneNumber = state.draftPhoneNumber.trim();

    // Basic mock validation (no backend).
    if (draftFullName.isEmpty ||
        draftEmail.isEmpty ||
        draftPhoneCountry.isEmpty ||
        draftPhoneNumber.isEmpty) {
      emit(
        state.copyWith(
          saveStatus: PersonalInfoSaveStatus.failure,
          errorMessage: 'Please fill all fields.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        saveStatus: PersonalInfoSaveStatus.saving,
        errorMessage: null,
      ),
    );

    await Future.delayed(const Duration(milliseconds: 600));

    final updatedPasswordMasked = _maskPassword(state.draftPassword);

    emit(
      state.copyWith(
        isEditing: false,
        saveStatus: PersonalInfoSaveStatus.success,
        errorMessage: null,
        fullName: draftFullName,
        email: draftEmail,
        phoneCountry: draftPhoneCountry,
        phoneNumber: draftPhoneNumber,
        passwordMasked: updatedPasswordMasked,
      ),
    );

    // Reset status so UI doesn't react repeatedly.
    await Future.delayed(const Duration(milliseconds: 350));
    emit(state.copyWith(saveStatus: PersonalInfoSaveStatus.initial));
  }

  String _maskPassword(String password) {
    if (password.isEmpty) return state.passwordMasked;
    // The screenshot displays a fixed number of stars.
    return List.filled(7, '*').join();
  }
}

