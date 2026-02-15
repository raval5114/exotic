import 'package:exotic/data/blocs/splashScreen/bloc/splash_screen_bloc.dart';
import 'package:exotic/data/providers/brands_provider.dart';
import 'package:exotic/data/providers/categories_provider.dart';
import 'package:exotic/data/providers/user_provider.dart';
import 'package:exotic/utils/categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SplashscreenComponent());
  }
}

class SplashscreenComponent extends StatefulWidget {
  const SplashscreenComponent({super.key});

  @override
  State<SplashscreenComponent> createState() => _SplashscreenComponentState();
}

class _SplashscreenComponentState extends State<SplashscreenComponent> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    context.read<SplashScreenBloc>().add(SplashScreenInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashScreenBloc, SplashScreenState>(
      listener: (context, state) {
        if (state is SplashScreenLoadingState) {
          setState(() {
            isLoading = true;
          });
        }
        if (state is SplashScreenSuccessedState) {
          bool ssState = state.islogged;
          if (ssState == true) {
            context.read<CategoriesProvider>().setCategories(state.data);
            context.read<UserProvider>().setUser(state.user);
            debugPrint("User:${context.read<UserProvider>().user!.customerId}");
            context.go('/home');
          } else {
            context.go('/auth');
          }
        }
        if (state is SplashScrennErrorState) {
          context.go('/auth');
        }
      },
      builder: (context, state) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage('assets/logo/logo.png'),
                height: 100,
              ),
              const SizedBox(height: 40),
              if (isLoading) const CircularProgressIndicator(),
            ],
          ),
        );
      },
    );
  }
}
