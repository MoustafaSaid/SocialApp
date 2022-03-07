import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialapp/layout/cubit/states.dart';
import 'package:socialapp/models/message_model.dart';
import 'package:socialapp/models/post_model.dart';
import 'package:socialapp/models/social_users_model.dart';
import 'package:socialapp/modules/chats/chats_screen.dart';
import 'package:socialapp/modules/feeds/feeds_screen.dart';
import 'package:socialapp/modules/post/add_post_screen.dart';
import 'package:socialapp/modules/settings/settings_screen.dart';

import '../../modules/users/users_screen.dart';
import '../../shared/components/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());
  static SocialCubit get(context) => BlocProvider.of(context);
  SocialUserModel? userModel;
  void getUserData() {
    emit(SocialGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      // print(value.data());
      userModel = SocialUserModel.fromJson(value.data()!);
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  int currentIndex = 0;
  List<Widget> screens = [
    FeedsScreen(),
    ChatsScreen(),
    NewPostScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];
  List<String> titles = [
    'Home',
    'Chats',
    'Post',
    'Users',
    'Settings',
  ];

  void ChangeBottomNavScreen(index) {
    // if(index==0){
    //   posts=[];
    //   getPosts();
    // }
    if(index==1) {
      getUsers();
    }
    if (index == 2) {
      emit(SocialNewPostState());
    } else {
      currentIndex = index;
      emit(SocialChangeBottomNavState());
    }
  }

  File? profileImage;

  var picker = ImagePicker();
  Future<void> getprofileImage() async {
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SocialProfileImageSuccessState());
    } else {
      print('No image selected');
      emit(SocialProfileImageErrorState());
    }
  }

  File? coverImage;

  Future<void> getCoverImage() async {
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    // File pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery) as File;

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImageSuccessState());
    } else {
      print('No image selected');
      emit(SocialCoverImageErrorState());
    }
  }
  // String profileImageUrl='';


  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
}){
    emit(SocialUserUpdateLoadingState());

    firebase_storage.FirebaseStorage
        .instance.ref().
    child('users/${Uri.file(profileImage!.path).pathSegments.last}').putFile(profileImage! ).then((value){
          value.ref.getDownloadURL().then((value) {
            // emit(SocialUploadProfileImageSuccessState());
            // profileImageUrl=value;
            updateUser(name: name, phone: phone, bio: bio,image: value);
          }).catchError((error){
            print(error.toString());

            emit(SocialUploadProfileImageErrorState());
          });
    } ).catchError((error){
      print(error.toString());
      emit(SocialUploadProfileImageErrorState());
    });
  }
  // String coverImageUrl='';

  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
}){
    emit(SocialUserUpdateLoadingState());

    firebase_storage.FirebaseStorage
        .instance.ref().
    child('users/${Uri.file(coverImage!.path).pathSegments.last}').putFile(coverImage! ).then((value){
      value.ref.getDownloadURL().then((value) {
        // emit(SocialUploadCoverImageSuccessState());
        // coverImageUrl=value;
        updateUser(name: name, phone: phone, bio: bio,cover: value);
      }).catchError((error){
        print(error.toString());

        emit(SocialUploadCoverImageErrorState());
      });
    } ).catchError((error){
      print(error.toString());

      emit(SocialUploadCoverImageErrorState());
    });
  }
  //
  // void updateUserImages({
  //
  // required String name,
  //   required String phone,
  //   required String bio,
  //   // String? image,
  //   // String? cover,
  //
  // })
  //
  //
  // {
  //   emit(SocialUserUpdateLoadingState());
  //   if(coverImage != null ){
  //     uploadCoverImage();
  //   }else if(profileImage != null){
  //     uploadProfileImage();
  //   }
  //   else if(coverImage != null && profileImage != null  ){}
  //
  //   else
  //     {
  //       updateUser(bio: bio,name: name,phone: phone);
  //
  //     }
  //
  //
  // }
  //
void updateUser({

  required String name,
  required String phone,
  required String bio,
  String? image,
  String? cover,
}){

  SocialUserModel model=SocialUserModel(
    name: name,
    phone: phone,
    isEmailVerified: false,
    bio: bio,
    image:image??userModel!.image! ,
    cover:cover??userModel!.cover! ,
    email:userModel!.email! ,
    uId: userModel!.uId!,

  );
  FirebaseFirestore.
  instance.
  collection('users').
  doc(userModel!.uId)
      .update(model.toMap()).then((value) {
    getUserData();
  }).catchError((error){
    emit(SocialUserUpdateErrorState());
  });
}




  File? postImage;

  Future<void> getPostImage() async {
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    // File pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery) as File;

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    } else {
      print('No image selected');
      emit(SocialPostImagePickedErrorState());
    }
  }
void removePostImage(){
    postImage=null;
    emit(SocialRemovePostImageState());
}
  void uploadPostImage({
    required String dateTime,
    required String text,


  }){
    emit(SocialCreatePostLoadingState());

    firebase_storage.FirebaseStorage
        .instance.ref().
    child('posts/${Uri.file(postImage!.path).pathSegments.last}').putFile(postImage! ).then((value){
      value.ref.getDownloadURL().then((value) {
        createPost(dateTime: dateTime, text: text,postImage: value);
      }).catchError((error){
        print(error.toString());

        emit(SocialCreatePostErrorState());
      });
    } ).catchError((error){
      print(error.toString());
      emit(SocialCreatePostErrorState());
      print(error.toString());

    });
  }





  void createPost({

    required String dateTime,
    required String text,
    String? postImage,
  }){
    emit(SocialCreatePostLoadingState());


    postModel model=postModel(
      name: userModel!.name,
      image:userModel!.image,
      uId:userModel!.uId,
      dateTime:dateTime ,
      postImage: postImage??'',
      text:text ,

    );
    FirebaseFirestore.
    instance.
    collection('posts').
        add(model.toMap()).then((value) {
          emit(SocialCreatePostSuccessState());
      // getUserData();
    }).catchError((error){
      emit(SocialCreatePostErrorState());
      print(error.toString());

    });
  }

List<postModel> posts=[];
List<String>postsId=[];
List<int> likes=[];
  void getPosts(){
    // if(likes[postsId]==null){
    //   likes[0]=0;
    // }
    // emit(SocialGetPostsLoadingState());
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        element.reference.collection('likes').get().then((value) {
          likes.add(value.docs.length);
          postsId.add(element.id);
          posts.add(postModel.fromJson(element.data()));
          // emit(SocialGetPostsSuccessState());

        }).catchError((error){});
        // postsId.add(element.id);
        // posts.add(postModel.fromJson(element.data()));


      });

      emit(SocialGetPostsSuccessState());
    }).catchError((error){
      emit(SocialGetPostsErrorState(error));
      print(error.toString());

    });
  }

void likePosts(String postId){
    FirebaseFirestore
        .instance.
    collection('posts').doc(postId).collection('likes').doc(userModel!.uId).set({'like':true,}).then((value) {
      emit(SocialLikePostsSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(SocialLikePostsErrorState(error));
      print(error.toString());


    });

}

List<SocialUserModel> users=[];
  void getUsers(){
     if(users.length==0)
    emit(SocialGetAllUsersLoadingState());
    FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach((element) {
      if(element.data()['uId'] != userModel!.uId)
        users.add(SocialUserModel.fromJson(element.data()));
      });

      emit(SocialGetAllUsersSuccessState());
    }).catchError((error){
      emit(SocialGetAllUsersErrorState(error));
      print(error.toString());

    });


  }


  void sendMessage({
  required String receiverId,
    required String datetime,
    required String text

  }){
    MessageModel model=MessageModel(text: text,dateTime:datetime ,receiverId: receiverId,senderId: userModel!.uId);
    FirebaseFirestore.
    instance.
    collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(model.receiverId)
        .collection('messages')
        .add(model.toMap()).then((value){
          emit(SocialSendMessageSuccessState());
    }).catchError((error){
      emit(SocialSendMessageErrorState(error));
      print(error.toString());

    });

    FirebaseFirestore.
    instance.
    collection('users')
        .doc(model.receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(model.toMap()).then((value){
      emit(SocialSendMessageSuccessState());
    }).catchError((error){
      emit(SocialSendMessageErrorState(error));
      print(error.toString());

    });


  }

  List<MessageModel> message=[];
  void getMessages({
    required String receiverId,

  }){
    FirebaseFirestore.instance.collection('users')
        .doc(userModel!.uId).collection('chats')
        .doc(receiverId).collection('messages').orderBy('dateTime')
        .snapshots()
        .listen((event) {
          message=[];
          event.docs.forEach((element) {
            message.add(MessageModel.fromJson(element.data()));
          });
          emit(SocialGetMessageSuccessState());

    });
  }

}
