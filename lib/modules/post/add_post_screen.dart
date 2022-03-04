import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/layout/cubit/cubit.dart';
import 'package:socialapp/layout/cubit/states.dart';
import 'package:socialapp/models/social_users_model.dart';
import 'package:socialapp/modules/feeds/feeds_screen.dart';
import 'package:socialapp/shared/components/components.dart';

class NewPostScreen extends StatelessWidget {
var textController=TextEditingController();
// var textController=TextEditingController();
// var textController=TextEditingController();
  SocialUserModel? model;
  // NewPostScreen({required this.model});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context, state) {

      },
      builder: (context,state){
        var userModel=SocialCubit.get(context).userModel;

        return Scaffold(
          appBar: defaultAppBar(
              context: context,
              title: 'Create Post',
            actions: [
              defaultTextButton(function: (){
                // var now=DateTime.now();
                // if(SocialCubit.get(context).postImage==null){
                //   SocialCubit.get(context).createPost(dateTime: now.toString(), text: textController.text);
                // }else{
                //   SocialCubit.get(context).uploadPostImage(dateTime: now.toString(), text: textController.text,);
                // }
                var now=DateTime.now();
                if(SocialCubit.get(context).postImage==null){
                  SocialCubit.get(context).createPost(dateTime: now.toString(), text: textController.text);
                }else {
                  SocialCubit.get(context).uploadPostImage(dateTime: now.toString(), text: textController.text,);
                }
                if(state is SocialCreatePostSuccessState){
                  navigateTo(context, FeedsScreen());
                }

              }, text: 'Post')
            ]
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
              if(state is SocialCreatePostLoadingState)
                LinearProgressIndicator(),
              if(state is SocialCreatePostLoadingState)
                  SizedBox(height: 10.0,),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25.0,
                      backgroundImage: NetworkImage(
                          '${userModel!.image}'),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Expanded(
                      child:Text(
                        '${userModel.name}',
                        style: TextStyle(
                          height: 1.4,
                        ),
                      ),

                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: 'what is in your mind ...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 20.0,),
                if(SocialCubit.get(context).postImage != null)
                Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 140.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          image: DecorationImage(
                            image:FileImage(SocialCubit.get(context).postImage!) as ImageProvider,
                            fit: BoxFit.cover,
                          )),
                    ),
                    IconButton(onPressed: (){
                      SocialCubit.get(context).removePostImage();

                    },
                        icon: CircleAvatar(
                        radius: 20.0,
                        child: Icon(Icons.close,size: 16.0,))),
                  ],
                ),
                SizedBox(height: 20.0,),

                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          SocialCubit.get(context).getPostImage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image,
                            ),
                            SizedBox(width: 5.0,),
                            Text('Add Photo'),
                            
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {  },
                        child:Text('# Tags'),
                      ),
                    ),

                  ],
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}
