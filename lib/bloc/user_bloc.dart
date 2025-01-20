import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bwa_flutix/models/models.dart';
import 'package:bwa_flutix/services/services.dart';
import 'package:equatable/equatable.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<LoadUser>(_onLoadUser);
    on<SignOut>(_onSignOut);
    on<UpdateData>(_onUpdateData);
    on<TopUp>(_onTopUp);
    on<Purchase>(_onPurchase);
  }

  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    try {
      User? user = await UserServices.getUser(event.id);
      if (user != null) {
        emit(UserLoaded(user));
      } else {
        emit(UserInitial());
      }
    } catch (e) {
      emit(UserInitial());
      print('Error loading user: $e');
    }
  }

  void _onSignOut(SignOut event, Emitter<UserState> emit) {
    emit(UserInitial());
  }

  Future<void> _onUpdateData(UpdateData event, Emitter<UserState> emit) async {
    if (state is UserLoaded) {
      User updatedUser = (state as UserLoaded)
          .user
          .copyWith(name: event.name, profilePicture: event.profileImage);

      await UserServices.updateUser(updatedUser);

      emit(UserLoaded(updatedUser));
    }
  }

  Future<void> _onTopUp(TopUp event, Emitter<UserState> emit) async {
    if (state is UserLoaded) {
      try {
        User updatedUser = (state as UserLoaded).user.copyWith(
            balance: ((state as UserLoaded).user.balance ?? 0) + event.amount);

        await UserServices.updateUser(updatedUser);

        emit(UserLoaded(updatedUser));
      } catch (e) {
        print('Error during top-up: $e');
      }
    }
  }

  Future<void> _onPurchase(Purchase event, Emitter<UserState> emit) async {
    if (state is UserLoaded) {
      try {
        User updatedUser = (state as UserLoaded).user.copyWith(
            balance: ((state as UserLoaded).user.balance ?? 0) - event.amount);

        await UserServices.updateUser(updatedUser);

        emit(UserLoaded(updatedUser));
      } catch (e) {
        print('Error during purchase: $e');
      }
    }
  }
}
