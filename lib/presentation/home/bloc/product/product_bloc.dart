import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_app/data/datasource/product_local_datasource.dart';

import '../../../../data/datasource/product_remote_datasource.dart';
import '../../../../data/model/request/product_request_model.dart';
import '../../../../data/model/respponse/product_response_model.dart';

part 'product_event.dart';
part 'product_state.dart';
part 'product_bloc.freezed.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRemoteDatasource _productRemoteDatasource;
  List<Product> products = [];
  ProductBloc(
    this._productRemoteDatasource,
  ) : super(const _Initial()) {
    on<_Fetch>((event, emit) async {
      emit(const ProductState.loading());
      final response = await _productRemoteDatasource.getProducts();
      response.fold(
        (l) => emit(ProductState.error(l)),
        (r) {
          products = r.data;
          emit(ProductState.success(r.data));
        },
      );
    });

    on<_FetchLocal>((event, emit) async {
      emit(const ProductState.loading());
      final localPproducts =
          await ProductLocalDatasource.instance.getAllProduct();
      products = localPproducts;

      emit(ProductState.success(products));
    });

    on<_FetchByCategory>((event, emit) async {
      emit(const ProductState.loading());

      final newProducts = event.category == 'all'
          ? products
          : products
              .where((element) => element.category == event.category)
              .toList();

      emit(ProductState.success(newProducts));
    });

    on<_AddProduct>((event, emit) async {
      emit(const ProductState.loading());
      final requestData = ProductRequestModel(
        name: event.product.name,
        price: event.product.price,
        stock: event.product.stock,
        category: event.product.category,
        isBestSeller: event.product.isBestSeller ? 1 : 0,
        image: event.image,
      );
      final response =
          await _productRemoteDatasource.addProduct(requestData);
      // products.add(newProduct);

      emit(ProductState.success(products));
    });
  }
}
