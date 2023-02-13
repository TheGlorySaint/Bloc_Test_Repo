import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/api_client.dart';
import 'package:test_app/api_errors.dart';
import 'package:test_app/api_response.dart';
import 'package:test_app/auth_repo.dart';
import 'package:test_app/cubit/intro_cubit_cubit.dart';
import 'package:test_app/device_model.dart';
import 'package:test_app/device_repo.dart';
import 'package:test_app/sign_in_enum.dart';
import 'package:test_app/token_errors.dart';
import 'package:test_app/token_model.dart';

DeviceModel tDeviceDetails = DeviceModel(
  name: 'unit_test_device_name',
  systemName: 'unit_test_system_name',
  systemVersion: 'unit_test_system_version',
  model: 'unit_test_device_model',
  localizedModel: 'unit_test_device_localizely_model',
  identifierForVendor: 'unit_test_device_identifier_for_vendor',
  isPhysicalDevice: false,
  appVersionNumber: 'unit_test_app_version_number',
  appBuildNumer: 'unit_test_app_build_number',
  os: 'unit_test_device_os',
);
const String tDeviceIP = 'unit_test_device_ip';
const String tToken = 'unit_test_long';
const String tFbToken = 'unit_test_long';
const int tUserID = 12345;
const successMessage = {
  'success': true,
  'message': 'Register done.',
  'access_token': 'asd',
};
const errorMessage = {'message': 'error'};

ApiResponse<TokenModel, TokenErrors> tResponseSuccess = ApiResponse(
  (data) => TokenModel.fromMap({
    'access_token': tToken,
    'fb_token': tFbToken,
    'userId': tUserID,
    'success': true,
    'message': tFbToken,
  }),
  (error) => TokenErrors.fromMap({
    'access_token': tToken,
    'fb_token': tFbToken,
    'userId': tUserID,
    'success': true,
    'message': tFbToken,
  }),
);

class MockApiResponse extends Mock implements ApiResponse {}

class MockApiErrorField extends Mock implements ApiErrorFields {}

class MockApiClient extends Mock implements APIClient {}

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {
  // @override
  // Future<ApiResponse<TokenModel, TokenErrors>> login({
  //   required String email,
  //   required String pin,
  //   required String deviceID,
  //   String? deviceOS,
  //   String? deviceModel,
  //   dynamic deviceDetails,
  //   String? deviceIP,
  //   String? lat,
  //   String? long,
  // }) {
  //   return Future.value(tResponseSuccess);
  // }
}

class MockDeviceRepository extends Mock implements DeviceRepository {
  @override
  Future<DeviceModel?> getDevice() async {
    return Future.value(tDeviceDetails);
  }

  @override
  Future<String?> getIP() async {
    return Future.delayed(const Duration(seconds: 2), () => tDeviceIP);
  }

  @override
  Future<Position?> getCurrentPosition() async {
    return Future.value(
      Position(
        longitude: 12.02,
        latitude: 13.02,
        timestamp: DateTime.now(),
        accuracy: 1.0,
        altitude: 1.0,
        heading: 1.0,
        speed: 1.0,
        speedAccuracy: 1.0,
      ),
    );
  }
}

Map<String, String> get _defaultHeaders => {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  late MockAuthenticationRepository mockAuthenticationRepository;
  late MockDeviceRepository mockDeviceRepository;
  late SigninCubit signinCubit;
  late MockApiResponse mockApiResponse;
  late MockApiClient mockApiClient;
  final dio = Dio();
  final dioAdapter = DioAdapter(dio: dio);
  var baseUrl;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    mockDeviceRepository = MockDeviceRepository();
    mockApiResponse = MockApiResponse();
    mockApiClient = MockApiClient();
    signinCubit = SigninCubit(
      deviceRepository: mockDeviceRepository,
      authenticationRepository: mockAuthenticationRepository,
    );
    dio.httpClientAdapter = dioAdapter;
    dio.options.headers = _defaultHeaders;
    baseUrl = 'www.example.com/api/v1/mobile/auth/register';
  });

  group('login()', () {
    const bool tBooleanTrue = true;
    const bool tBooleanFalse = false;
    const String tEmail = 'unit_test@test.de';
    const String tPin = '12345789';
    const String tDeviceID = 'unit_test_device_id';
    const String tDeviceOS = 'unit_test_os';
    const String tDeviceModel = 'unit_test_device_model';
    const String tLat = 'unit_test_lat';
    const String tLong = 'unit_test_long';
    const String tToken = 'unit_test_long';
    const String tFbToken = 'unit_test_long';
    const int tUserID = 12345;
    final Exception tException = Exception('Failed to save token');

    blocTest<SigninCubit, SigninState>(
      'emits [AuthenticationStatusEnum.initial, AuthenticationStatusEnum.loading, AuthenticationStatusEnum.successfullSavedToken] when saveToken() is called and true.',
      build: () => signinCubit,
      setUp: () async {
        signinCubit.emit(
          signinCubit.state.copyWith(
            email: tEmail,
            pin: tPin,
            deviceID: tDeviceID,
            deviceOS: tDeviceOS,
            deviceModel: tDeviceModel,
            deviceDetails: tDeviceDetails,
            deviceIP: tDeviceIP,
            lat: tLat,
            long: tLong,
            status: SigninStatusEnum.successSavedData,
          ),
        );

        final dynamic body = {
          'email': tEmail,
          'device_id': tDeviceID,
          'pin': tPin,
          'os': tDeviceOS,
          'model': tDeviceModel,
          //TODO
          // 'details': tDeviceDetails,
          'ip': tDeviceIP,
          'lat': tLat,
          'lng': tLong,
        };

        dioAdapter.onPost(
          '$baseUrl',
          (request) {
            return request.reply(200, successMessage, statusMessage: 'Register Done.');
          },
          data: body,
          queryParameters: {},
          headers: _defaultHeaders,
        );

        final httpResponse = await dio.post(baseUrl, data: body);
        final response = ApiResponse(
          (data) => TokenModel.fromMap(data!),
          (errors) => TokenErrors.fromMap(errors!),
        ).fromHttp(httpResponse);
        print(response.isOkay);
        print(response.data?.didRegistrationWork);
        print(response.data != null);
        print(response.data?.token);
        print(response.errors);
        print(response.isFailed);
        print(response.message);
        print(response.status);

        when(
          () => mockAuthenticationRepository.login(
            email: tEmail,
            pin: tPin,
            deviceID: tDeviceID,
            deviceOS: tDeviceOS,
            deviceModel: tDeviceModel,
            // deviceDetails: tDeviceDetails,
            deviceIP: tDeviceIP,
            lat: tLat,
            long: tLong,
          ),
        ).thenAnswer((_) async => response);
      },
      act: (cubit) => cubit.login(),
      expect: () => <SigninState>[
        const SigninState(status: SigninStatusEnum.initial),
        const SigninState(status: SigninStatusEnum.loading),
        SigninState(
          email: tEmail,
          pin: tPin,
          deviceID: tDeviceID,
          deviceOS: tDeviceOS,
          deviceModel: tDeviceModel,
          deviceDetails: tDeviceDetails,
          deviceIP: tDeviceIP,
          lat: tLat,
          long: tLong,
          status: SigninStatusEnum.successSavedData,
        ),
      ],
    );

    blocTest<SigninCubit, SigninState>(
      'emits [AuthenticationStatusEnum.initial, AuthenticationStatusEnum.loading, AuthenticationStatusEnum.failedToSaveToken] when saveToken() is called but false.',
      build: () => signinCubit,
      setUp: () => when(() => mockAuthenticationRepository.saveToken(tToken)).thenAnswer((_) async => tBooleanFalse),
      act: (cubit) => cubit.saveToken(tToken),
      expect: () => const <SigninState>[
        SigninState(status: SigninStatusEnum.initial),
        SigninState(status: SigninStatusEnum.loading),
        SigninState(
          status: SigninStatusEnum.failedToSaveToken,
        ),
      ],
    );
    blocTest<SigninCubit, SigninState>(
      'emits [AuthenticationStatusEnum.initial, AuthenticationStatusEnum.loading, AuthenticationStatusEnum.failure] when saveToken() failed.',
      setUp: () => when(() => mockAuthenticationRepository.saveToken(tToken)).thenThrow(tException),
      build: () => signinCubit,
      act: (cubit) => cubit.saveToken(tToken),
      expect: () => <SigninState>[
        const SigninState(status: SigninStatusEnum.initial),
        const SigninState(status: SigninStatusEnum.loading),
        SigninState(
          status: SigninStatusEnum.failure,
          exception: tException,
        ),
      ],
    );
  });

  group('saveToken()', () {
    const bool tBooleanTrue = true;
    const bool tBooleanFalse = false;
    const String tToken = 'token';
    final Exception tException = Exception('Failed to save token');

    blocTest<SigninCubit, SigninState>(
      'emits [AuthenticationStatusEnum.initial, AuthenticationStatusEnum.loading, AuthenticationStatusEnum.successfullSavedToken] when saveToken() is called and true.',
      build: () => signinCubit,
      setUp: () => when(() => mockAuthenticationRepository.saveToken(tToken)).thenAnswer((_) async => tBooleanTrue),
      act: (cubit) => cubit.saveToken(tToken),
      expect: () => const <SigninState>[
        SigninState(status: SigninStatusEnum.initial),
        SigninState(status: SigninStatusEnum.loading),
        SigninState(
          status: SigninStatusEnum.successfullSavedToken,
        ),
      ],
    );
    blocTest<SigninCubit, SigninState>(
      'emits [AuthenticationStatusEnum.initial, AuthenticationStatusEnum.loading, AuthenticationStatusEnum.failedToSaveToken] when saveToken() is called but false.',
      build: () => signinCubit,
      setUp: () => when(() => mockAuthenticationRepository.saveToken(tToken)).thenAnswer((_) async => tBooleanFalse),
      act: (cubit) => cubit.saveToken(tToken),
      expect: () => const <SigninState>[
        SigninState(status: SigninStatusEnum.initial),
        SigninState(status: SigninStatusEnum.loading),
        SigninState(
          status: SigninStatusEnum.failedToSaveToken,
        ),
      ],
    );
    blocTest<SigninCubit, SigninState>(
      'emits [AuthenticationStatusEnum.initial, AuthenticationStatusEnum.loading, AuthenticationStatusEnum.failure] when saveToken() failed.',
      setUp: () => when(() => mockAuthenticationRepository.saveToken(tToken)).thenThrow(tException),
      build: () => signinCubit,
      act: (cubit) => cubit.saveToken(tToken),
      expect: () => <SigninState>[
        const SigninState(status: SigninStatusEnum.initial),
        const SigninState(status: SigninStatusEnum.loading),
        SigninState(
          status: SigninStatusEnum.failure,
          exception: tException,
        ),
      ],
    );
  });
}
