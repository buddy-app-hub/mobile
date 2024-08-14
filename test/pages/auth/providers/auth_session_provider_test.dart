import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/models/buddy.dart';
import 'package:mobile/models/user_data.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/services/auth_service.dart';

import 'auth_session_provider_test.mocks.dart';

@GenerateMocks([AuthService, User, UserData, Buddy])
void main() {
  late MockAuthService mockAuthService;
  late MockUser mockUser;
  late MockUserData mockUserData;
  late AuthSessionProvider authSessionProvider;

  setUp(() {
    mockAuthService = MockAuthService();
    mockUser = MockUser();
    mockUserData = MockUserData();
  });

  group('init when currentUser is null', () {
    setUp(() {
      when(mockAuthService.currentUser).thenReturn(null);
      authSessionProvider = AuthSessionProvider(mockAuthService);
    });

    test('must not be authenticated', () {
      expect(authSessionProvider.isAuthenticated, isFalse);
    });

    test('should initialize with null user and not fetch user data', () {
      expect(authSessionProvider.user, null);
      verify(mockAuthService.currentUser).called(1);
      verifyNever(mockAuthService.fetchUserData());
      expect(authSessionProvider.user, null);
    });
  });

  group('Initialization with Buddy as currentUser', () {
    setUp(() {
      when(mockAuthService.currentUser).thenReturn(mockUser);
      when(mockAuthService.fetchUserData())
          .thenAnswer((_) async => mockUserData);
      when(mockUserData.buddy).thenReturn(MockBuddy());
      authSessionProvider = AuthSessionProvider(mockAuthService);
    });

    test('should return true for isAuthenticated when Buddy is present', () {
      expect(authSessionProvider.isAuthenticated, isTrue);
    });

    test('userData should not be null when Buddy is present', () {
      expect(authSessionProvider.userData, isNotNull);
    });

    test('should initialize with Buddy and fetch user data', () {
      expect(authSessionProvider.user, mockUser);
      verify(mockAuthService.currentUser).called(1);
      verify(mockAuthService.fetchUserData()).called(1);
      expect(authSessionProvider.userData, mockUserData);
    });

    test('should call fetchUserData only once during initialization', () {
      verify(mockAuthService.currentUser).called(1);
      verify(mockAuthService.fetchUserData()).called(1);
      verifyNoMoreInteractions(mockAuthService);
    });
  });

  group('signOut user session', () {
    setUp(() {
      when(mockAuthService.currentUser).thenReturn(mockUser);
      when(mockAuthService.fetchUserData())
          .thenAnswer((_) async => mockUserData);
      when(mockUserData.buddy).thenReturn(MockBuddy());
      when(mockAuthService.signOut()).thenAnswer((_) async => null);
      authSessionProvider = AuthSessionProvider(mockAuthService);
    });

    test('should sign out user and clear state', () async {
      expect(authSessionProvider.user, mockUser);
      expect(authSessionProvider.userData, mockUserData);
      verify(mockAuthService.fetchUserData()).called(1);

      await authSessionProvider.signOut();

      expect(authSessionProvider.user, isNull);
      expect(authSessionProvider.userData, isNull);
      verify(mockAuthService.signOut()).called(1);
      verifyNever(mockAuthService.fetchUserData());
      // verify(authSessionProvider.notifyListeners()).called(1);
    });
  });
}