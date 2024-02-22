import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/variables.dart';
import '../model/request/product_request_model.dart';
import '../model/respponse/add_product_response_model.dart';
import '../model/respponse/product_response_model.dart';
import 'auth_local_datasource.dart';

class ProductRemoteDatasource {
  Future<Either<String, ProductResponseModel>> getProducts() async {
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.get(
      Uri.parse('${Variables.baseUrl}products'),
      headers: {
        'Authorization': 'Bearer ${authData.token}',
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      return right(ProductResponseModel.fromJson(response.body));
    } else {
      return left(response.body);
    }
  }

  Future<Either<String, AddProductResponseModel>> addProduct(
      ProductRequestModel productRequestModel) async {
    final authData = await AuthLocalDatasource().getAuthData();
    final Map<String, String> headers = {
      'Authorization': 'Bearer ${authData.token}',
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${Variables.baseUrl}products'));
    request.fields.addAll(productRequestModel.toMap());
    request.files.add(await http.MultipartFile.fromPath(
        'image', productRequestModel.image.path));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    final String body = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      return right(AddProductResponseModel.fromJson(body));
    } else {
      return left(body);
    }
  }
}
