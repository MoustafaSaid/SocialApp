import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/firebase_options.dart';
import 'package:socialapp/layout/cubit/cubit.dart';
import 'package:socialapp/layout/social_layout.dart';
import 'package:socialapp/modules/social_login/login_screen.dart';
import 'package:socialapp/shared/bloc_observer.dart';
import 'package:socialapp/shared/components/components.dart';
import 'package:socialapp/shared/components/constants.dart';
import 'package:socialapp/shared/cubit/cubit.dart';
import 'package:socialapp/shared/cubit/states.dart';
import 'package:socialapp/shared/network/local/cache_helper.dart';
import 'package:socialapp/shared/network/remote/dio_helper.dart';
import 'package:socialapp/shared/styles/themes.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message)async{
  print('background  message  app');

  print(message.data.toString());
  showToast(text: 'background  message  app', state: ToastStates.SUCCESS);

}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await CacheHelper.init();
  DioHelper.init();
  await Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform,);
  // the 3 state of getting notification from console FCM
  var token=FirebaseMessaging.instance.getToken();
  print(token);

  FirebaseMessaging.onMessage.listen((event) {
    print('on message');
    print(event.data.toString());
    showToast(text: 'on message', state: ToastStates.SUCCESS);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print('on message opened app');

    print(event.data.toString());
    showToast(text: 'on message opened app', state: ToastStates.SUCCESS);


  });
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  BlocOverrides.runZoned(
        () {

      // Use cubits...

      bool? isDark  = CacheHelper.getData(key: 'isDark');
      Widget? widget;
      uId = CacheHelper.getData(key: 'uId');

      if(uId != null)
      {
        widget = SocialLayout();
      } else
      {
        widget = SocialLoginScreen();
      }

      runApp( MyApp( isDark: isDark,
        startWidget: widget, ));





    },
    blocObserver: MyBlocObserver(),

  );
  // runApp( MyApp());
}

class MyApp extends StatelessWidget {
  late final bool? isDark;
  late final Widget? startWidget;
  MyApp({
    this.isDark,
    this.startWidget,
  });


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
      BlocProvider(
        create: (context) => SocialCubit()..getUserData()..getPosts(),
     ),
          BlocProvider(create: (context) => AppCubit(),)
    ], child: BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {

      },
      builder: (context,state){
        return MaterialApp(
          theme: lightTheme,
darkTheme: darkTheme,
          themeMode: AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          // themeMode: ThemeMode.dark,
          home:startWidget ,
        );
      },
    ));
  }
}
