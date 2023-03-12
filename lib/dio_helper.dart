import 'package:dio/dio.dart';

class DioHelper{
  static  Dio? dio;

  static intDio(){
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.openai.com/v1/chat/',
        followRedirects: false,
        validateStatus: (status) { return status! < 500; },
        connectTimeout: const Duration(minutes: 2),
        receiveTimeout: const Duration(minutes: 2),
      )
    );
  }

  static Future<Response> postData({required String url,required Map<String,dynamic> data})async{
    dio!.options.headers = {
      'Content-Type':'application/json',
      'Authorization':"Bearer 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"
    };
    return dio!.post(url,
    data: data,);
  }

}
