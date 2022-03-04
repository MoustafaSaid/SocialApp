import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/layout/cubit/cubit.dart';
import 'package:socialapp/layout/cubit/states.dart';
import 'package:socialapp/models/social_users_model.dart';
import 'package:socialapp/modules/post/add_post_screen.dart';
import 'package:socialapp/shared/components/components.dart';
import 'package:socialapp/shared/styles/icon_broken.dart';

class SocialLayout extends StatelessWidget {
SocialUserModel? model;

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if(state is SocialNewPostState){
          navigateTo(context, NewPostScreen());
        }
      },
      builder: (context, state) {
        var cubit=SocialCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(cubit.titles[cubit.currentIndex],
          ),
          actions: [
            IconButton(onPressed: (){}, icon: Icon(IconBroken.Notification)),
            IconButton(onPressed: (){}, icon: Icon(IconBroken.Search)),


          ],

          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index){
              cubit.ChangeBottomNavScreen(index);
            },
            currentIndex: cubit.currentIndex,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Home),label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Chat),label: 'Chats'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.post_add_sharp),label: 'Post'),

              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Location),label: 'Users'),
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Setting),label: 'Settings'),

            ],
          ),
          // body: ConditionalBuilder(
          //   condition: SocialCubit.get(context).model != null,
          //   builder: (context) {
          //     // var model=FirebaseAuth.instance.currentUser!.emailVerified;
          //     return Column(
          //       children: [
          //         // if(!model)
          //         // Container(
          //         //   color: Colors.amber,
          //         //   child: Padding(
          //         //     padding: const EdgeInsets.symmetric(
          //         //       horizontal: 15.0,
          //         //     ),
          //         //     child: Row(
          //         //       children: [
          //         //         Icon(Icons.info_outline),
          //         //         SizedBox(
          //         //           width: 15,
          //         //         ),
          //         //         Expanded(child: Text('please verify your email')),
          //         //         // Spacer(),
          //         //         // SizedBox(width: 20.0,),
          //         //         defaultTextButton(
          //         //           function: () {
          //         //             FirebaseAuth.instance.currentUser?.sendEmailVerification().then((value) {
          //         //               showToast(text: 'show your mail', state: ToastStates.SUCCESS);
          //         //             }).catchError((error){});
          //         //           },
          //         //           text: 'send ',
          //         //         ),
          //         //       ],
          //         //     ),
          //         //   ),
          //         // )
          //       ],
          //     );
          //   },
          //   fallback: (context) => Center(child: CircularProgressIndicator()),
          // ),
        );
      },
    );
  }
}
