import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/product.dart';
import '../services/cart_service.dart';
import '../services/user_service.dart';

class ProductScreen extends StatelessWidget {
  final Product product;

  const ProductScreen({
    super.key,
    required this.product,
  });

  Widget sectionTitle(
    BuildContext context,
    String title,
  ) {
    return Padding(
      padding:
          EdgeInsets.only(
        top: 20.h,
        bottom: 10.h,
      ),
      child: Text(
        title,
        style:
            TextStyle(
          fontFamily:
              "Poppins",
          fontSize:
              18.sp,
          fontWeight:
              FontWeight.bold,
          color:
              Theme.of(context)
                  .colorScheme
                  .onSurface,
        ),
      ),
    );
  }

  Widget detailRow(
    BuildContext context,
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding:
          EdgeInsets.symmetric(
        vertical:
            8.h,
      ),
      child:
          Row(
        children: [
          Icon(
            icon,
            size:
                22.sp,
            color:
                const Color(
              0xFF003566,
            ),
          ),
          SizedBox(
            width:
                12.w,
          ),
          Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      TextStyle(
                    fontFamily:
                        "Poppins",
                    fontSize:
                        12.sp,
                    color:
                        Colors.grey,
                  ),
                ),
                Text(
                  value.isEmpty
                      ? "Not available"
                      : value,
                  style:
                      TextStyle(
                    fontFamily:
                        "Poppins",
                    fontSize:
                        14.sp,
                    fontWeight:
                        FontWeight.w600,
                    color:
                        Theme.of(context)
                            .colorScheme
                            .onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget badge(
    String text,
    Color color,
  ) {
    return Container(
      padding:
          EdgeInsets.symmetric(
        horizontal:
            10.w,
        vertical:
            5.h,
      ),
      decoration:
          BoxDecoration(
        color:
            color,
        borderRadius:
            BorderRadius.circular(
          20.r,
        ),
      ),
      child:
          Text(
        text,
        style:
            const TextStyle(
          color:
              Colors.white,
          fontWeight:
              FontWeight.bold,
        ),
      ),
    );
  }

  // Lab Activity 4 - Enhancement 3: Uses the saved authenticated user's ID when sending the selected product to the Add Cart endpoint.
  Future<void> addProductToCart(
    BuildContext context,
  ) async {
    try {
      final UserService userService =
          UserService();

      final currentUser =
          await userService.getUser();

      if (currentUser.id <= 0) {
        throw Exception(
          "No saved user ID found",
        );
      }

      final CartService cartService =
          CartService();

      final newCart =
          await cartService.addToCart(
        userId:
            currentUser.id,
        productId:
            product.id,
        quantity:
            1,
      );

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content:
              Text(
            "${product.title} added to cart successfully. Returned Cart ID: ${newCart.id}",
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content:
              Text(
            "Failed to add product: $e",
          ),
        ),
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar:
          AppBar(
        title:
            const Text(
          "Product Details",
        ),
      ),
      body:
          SingleChildScrollView(
        padding:
            EdgeInsets.all(
          16.w,
        ),
        child:
            Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
              decoration:
                  BoxDecoration(
                borderRadius:
                    BorderRadius.circular(
                  20.r,
                ),
                boxShadow:
                    const [
                  BoxShadow(
                    blurRadius:
                        8,
                    offset:
                        Offset(
                      0,
                      4,
                    ),
                    color:
                        Colors.black26,
                  ),
                ],
              ),
              child:
                  ClipRRect(
                borderRadius:
                    BorderRadius.circular(
                  20.r,
                ),
                child:
                    Image.network(
                  product.thumbnail,
                  height:
                      280.h,
                  width:
                      double.infinity,
                  fit:
                      BoxFit.cover,
                  errorBuilder:
                      (
                    context,
                    error,
                    stackTrace,
                  ) {
                    return Container(
                      height:
                          280.h,
                      width:
                          double.infinity,
                      color:
                          Colors.grey.shade200,
                      child:
                          const Icon(
                        Icons.image_not_supported,
                        size:
                            60,
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height:
                  20.h,
            ),
            Text(
              product.title,
              style:
                  TextStyle(
                fontFamily:
                    "Poppins",
                fontSize:
                    25.sp,
                fontWeight:
                    FontWeight.bold,
                color:
                    Theme.of(context)
                        .colorScheme
                        .onSurface,
              ),
            ),
            SizedBox(
              height:
                  10.h,
            ),
            Wrap(
              spacing:
                  10.w,
              runSpacing:
                  8.h,
              children: [
                badge(
                  product.category.toUpperCase(),
                  const Color(
                    0xFF003566,
                  ),
                ),
                badge(
                  product.stock > 0
                      ? "IN STOCK"
                      : "OUT OF STOCK",
                  product.stock > 0
                      ? const Color(
                          0xFFCCA000,
                        )
                      : Colors.red,
                ),
              ],
            ),
            SizedBox(
              height:
                  15.h,
            ),
            Text(
              "\$${product.price.toStringAsFixed(2)}",
              style:
                  TextStyle(
                fontFamily:
                    "Poppins",
                fontSize:
                    28.sp,
                fontWeight:
                    FontWeight.bold,
                color:
                    const Color(
                  0xFFCCA000,
                ),
              ),
            ),
            SizedBox(
              height:
                  15.h,
            ),
            Row(
              children: [
                const Icon(
                  Icons.star,
                  color:
                      Color(
                    0xFFF0CB46,
                  ),
                ),
                SizedBox(
                  width:
                      5.w,
                ),
                Text(
                  "${product.rating} Rating",
                  style:
                      TextStyle(
                    fontFamily:
                        "Poppins",
                    fontSize:
                        15.sp,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(
              height:
                  20.h,
            ),
            SizedBox(
              width:
                  double.infinity,
              child:
                  ElevatedButton.icon(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(
                    0xFFF0CB46,
                  ),
                  foregroundColor:
                      const Color(
                    0xFF001D3D,
                  ),
                  padding:
                      EdgeInsets.symmetric(
                    vertical:
                        15.h,
                  ),
                ),
                onPressed:
                    product.stock > 0
                        ? () {
                            addProductToCart(
                              context,
                            );
                          }
                        : null,
                icon:
                    const Icon(
                  Icons.add_shopping_cart,
                ),
                label:
                    const Text(
                  "Add to Cart",
                  style:
                      TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),
            sectionTitle(
              context,
              "Description",
            ),
            Text(
              product.description,
              style:
                  TextStyle(
                fontFamily:
                    "Poppins",
                fontSize:
                    15.sp,
              ),
            ),
            sectionTitle(
              context,
              "Product Details",
            ),
            detailRow(
              context,
              Icons.category,
              "Category",
              product.category,
            ),
            detailRow(
              context,
              Icons.business,
              "Brand",
              product.brand,
            ),
            detailRow(
              context,
              Icons.inventory,
              "Available Stock",
              "${product.stock} items",
            ),
            detailRow(
              context,
              Icons.scale,
              "Weight",
              "${product.weight} g",
            ),
            sectionTitle(
              context,
              "Specifications",
            ),
            detailRow(
              context,
              Icons.straighten,
              "Dimensions",
              product.dimensions,
            ),
            detailRow(
              context,
              Icons.security,
              "Warranty",
              product.warrantyInformation,
            ),
            detailRow(
              context,
              Icons.local_shipping,
              "Shipping",
              product.shippingInformation,
            ),
            detailRow(
              context,
              Icons.assignment_return,
              "Return Policy",
              product.returnPolicy,
            ),
            SizedBox(
              height:
                  20.h,
            ),
          ],
        ),
      ),
    );
  }
}