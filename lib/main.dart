import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/data/datasource/midtrans_remote_datasource.dart';
import 'package:pos_app/data/datasource/product_remote_datasource.dart';
import 'package:pos_app/presentation/auth/pages/login_page.dart';
import 'package:pos_app/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:pos_app/presentation/home/bloc/logout/logout_bloc.dart';
import 'package:pos_app/presentation/home/bloc/product/product_bloc.dart';
import 'package:pos_app/presentation/home/pages/dashboard_page.dart';
import 'package:pos_app/presentation/order/bloc/order/order_bloc.dart';
import 'package:pos_app/presentation/order/bloc/qris/qris_bloc.dart';

import 'core/constants/colors.dart';
import 'data/datasource/auth_local_datasource.dart';
import 'data/datasource/auth_remote_datasource.dart';
import 'presentation/auth/bloc/login/login_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => ProductBloc(ProductRemoteDatasource())
            ..add(const ProductEvent.fetchLocal()),
        ),
        BlocProvider(create: (context) => CheckoutBloc()),
        BlocProvider(create: (context) => OrderBloc()),
        BlocProvider(create: (context) => QrisBloc(MidtransRemoteDatasource())),

      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          useMaterial3: true,
          textTheme: GoogleFonts.quicksandTextTheme(
            Theme.of(context).textTheme,
          ),
          appBarTheme: AppBarTheme(
            color: AppColors.white,
            elevation: 0,
            titleTextStyle: GoogleFonts.quicksand(
              color: AppColors.primary,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
            iconTheme: const IconThemeData(
              color: AppColors.primary,
            ),
          ),
        ),
        home: FutureBuilder<bool>(
            future: AuthLocalDatasource().isAuth(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data == true) {
                return const DashboardPage();
              } else {
                return const LoginPage();
              }
            }),
      ),
    );
  }
}
