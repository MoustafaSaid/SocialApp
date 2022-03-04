import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/models/social_users_model.dart';
import 'package:socialapp/modules/social_register/cubit/states.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterStates> {
  SocialRegisterCubit() : super(SocialRegisterInitialState());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({
     String? name,
     String? email,
     String? password,
     String? phone,
  }) {
    print('hello');

    emit(SocialRegisterLoadingState());

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email!,
      password: password!,
    )
        .then((value) {
          // print(value.user!.email);
          // print(value.user!.uid);

      userCreate(
        uId: value.user!.uid,
        phone: phone,
        email: email,
        name: name,
      );
    }).catchError((error) {
      emit(SocialRegisterErrorState(error.toString()));
    });
  }

  void userCreate({
     String? name,
     String? email,
     String? phone,
     String? uId,
  }) {
    SocialUserModel userModel = SocialUserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      isEmailVerified: false,
      bio: 'Write your bio ...',
      cover: 'https://img.freepik.com/free-photo/close-up-pleasant-curly-dark-hair-female-customer-support-manager-smiling-broadly-ready-help-express-interest-happiness-grinning-white-teeth-delighted-have-positive-conversation-studio-background_176420-34934.jpg?size=626&ext=jpg&ga=GA1.2.366148094.1646149201',
      image: 'https://img.freepik.com/free-photo/portrait-beautiful-cheerful-redhead-woman-with-flying-curly-hair-smiling-laughing_176420-14462.jpg?size=626&ext=jpg&ga=GA1.2.366148094.1646149201',
    );

      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .set(userModel.toMap())
          .then((value)
      {
            emit(SocialCreateUserSuccessState());
      })
          .catchError((error) {
            print(error.toString());
        emit(SocialCreateUserErrorState(error.toString()));
      });
    }

    IconData suffix = Icons.visibility_outlined;
    bool isPassword = true;

    void changePasswordVisibility() {
      isPassword = !isPassword;
      suffix =
      isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

      emit(SocialRegisterChangePasswordVisibilityState());
    }
  }