import 'package:cheese_client/src/components/layout/scaffold_with_navigation_bar.dart';
import 'package:cheese_client/src/pages/map/map_page.dart';
import 'package:cheese_client/src/pages/profile/profile_page.dart';
import 'package:cheese_client/src/pages/profile_register/profile_registration_page.dart';
import 'package:cheese_client/src/pages/profile_snap_post_detail/prolie_snap_post_detail_page.dart';
import 'package:cheese_client/src/pages/route/route_page.dart';
import 'package:cheese_client/src/pages/sign_in/sign_in_page.dart';
import 'package:cheese_client/src/pages/sing_up/sing_up_page.dart';
import 'package:cheese_client/src/pages/snap_post_detail/prolie_snap_post_detail_page.dart';
import 'package:cheese_client/src/pages/snap_post_submit/snap_post_submit_page.dart';
import 'package:cheese_client/src/pages/snap_route_detail/snap_route_detail_page.dart';
import 'package:cheese_client/src/pages/snap_route_submit/snap_route_submit.page.dart';
import 'package:cheese_client/src/providers/auth_provider.dart';
import 'package:cheese_client/src/providers/page_provider.dart';
import 'package:cheese_client/src/providers/profile_provider.dart';
import 'package:cheese_client/src/repositories/auth/auth_repository_provider.dart';
import 'package:cheese_client/src/router/page_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../pages/home/home_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  final userState = ref.watch(userProvider);

  // NOTE: うまくいかに時はここをコメントアウトして、強制ログアウトしてください
  // final rpo = ref.watch(authRepositoryProvider);
  // rpo.signOut();

  final goRouter = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: PageRoutes.home,
      routes: [
        GoRoute(
            path: PageRoutes.singIn,
            builder: (context, state) => const SignInPage()),
        GoRoute(
            path: PageRoutes.singUp,
            builder: (context, state) => const SignUpPage()),
        GoRoute(
            path: PageRoutes.profileRegistration,
            builder: (context, state) => const ProfileRegistrationPage()),
        GoRoute(
            path: PageRoutes.routeSubmit,
            builder: (context, state) => const SnapRouteSubmitPage()),
        GoRoute(
            path: '${PageRoutes.routeDetail}/:snapRouteId',
            builder: (context, state) => SnapRouteDetailPage(
                snapRouteId: state.pathParameters['snapRouteId']!)),
        GoRoute(
            path: '${PageRoutes.profilePostDetail}/:snapPostId',
            builder: (context, state) => ProfileSnapPostDetailPage(
                snapPostId: state.pathParameters['snapPostId']!)),
        GoRoute(
            path: '${PageRoutes.snapPostDetail}/:snapPostId',
            builder: (context, state) => SnapPostDetailPage(
                snapPostId: state.pathParameters['snapPostId']!)),
        ShellRoute(
          // navigatorKey: _shellNavigatorKey,
          builder: (BuildContext context, GoRouterState state, Widget child) {
            return ScaffoldWithNavigationBar(body: child);
          },
          routes: [
            GoRoute(
                path: PageRoutes.home,
                builder: (context, state) => const HomePage()),
            GoRoute(
                path: PageRoutes.map,
                builder: (context, state) => const MapPage()),
            GoRoute(
                path: PageRoutes.submit,
                builder: (context, state) => const SnapPostSubmitPage()),
            GoRoute(
                path: PageRoutes.route,
                builder: (context, state) => const RoutePage()),
            GoRoute(
                path: PageRoutes.profile,
                builder: (context, state) => const ProfilePage()),
          ],
        )
      ],

      // NOTE: リダイレクトの処理
      redirect: (BuildContext context, GoRouterState state) {
        final isLoading = authState.isLoading;

        if (isLoading) return null;

        final isLoggedIn = authState.value != null;

        final isSignInPage = state.location == PageRoutes.singIn;
        final isSingUpPage = state.location == PageRoutes.singUp;

        final isProfileRegistrationPage =
            state.location == PageRoutes.profileRegistration;

        final isAuthPage =
            isSignInPage || isSingUpPage || isProfileRegistrationPage;

        if (!isLoggedIn && !isAuthPage) {
          return PageRoutes.singIn;
        }

        final isExistProfile = userState != null;

        if (isLoggedIn && !isExistProfile && !isProfileRegistrationPage) {
          return PageRoutes.profileRegistration;
        }

        return null;
      });
  return goRouter;
});
