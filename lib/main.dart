import 'package:bwa_flutix/services/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'bloc/blocs.dart';
import 'ui/pages/pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<auth.User?>.value(
      // Use nullable auth.User
      value: AuthServices.userStream,
      initialData: null, // Provide a null initial value for the nullable stream
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => PageBloc()),
          BlocProvider(create: (_) => UserBloc()),
          BlocProvider(create: (_) => ThemeBloc()),
          BlocProvider(
            create: (_) => MovieBloc()..add(FetchMovies()),
          ),
          BlocProvider(create: (_) => TicketBloc()),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (_, themeState) => MaterialApp(
            theme: themeState.themeData,
            debugShowCheckedModeBanner: false,
            home:
                Wrapper(), // Ensure Wrapper properly handles nullable auth.User
          ),
        ),
      ),
    );
  }
}
