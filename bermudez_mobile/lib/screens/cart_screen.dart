import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/cart.dart';
import '../services/cart_service.dart';
import '../services/product_service.dart';
import '../services/user_service.dart';
import 'product_screen.dart';
import 'settings_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({
    super.key,
  });

  @override
  State<CartScreen> createState() =>
      _CartScreenState();
}

class _CartScreenState
    extends State<CartScreen> {
  final CartService _cartService =
      CartService();

  final ProductService _productService =
      ProductService();

  final UserService _userService =
      UserService();

  Future<Cart>? cart;

  final Map<int, int> _quantities = {};

  bool _quantitiesInitialized = false;

  @override
  void initState() {
    super.initState();

    // Lab Activity 4 - Enhancement 3: Loads the saved authenticated user's ID and renders that user's cart.
    cart = _loadSavedUserCart();
  }

  Future<Cart> _loadSavedUserCart() async {
    final currentUser =
        await _userService.getUser();

    if (currentUser.id <= 0) {
      throw Exception(
        "No saved user ID found",
      );
    }

    return _cartService.getCartByUserId(
      currentUser.id,
    );
  }

  void initializeQuantities(
    Cart userCart,
  ) {
    if (_quantitiesInitialized) {
      return;
    }

    for (final product
        in userCart.products) {
      _quantities[product.id] =
          product.quantity;
    }

    _quantitiesInitialized = true;
  }

  void increaseQuantity(
    CartProduct product,
  ) {
    setState(() {
      final currentQuantity =
          _quantities[product.id] ??
              product.quantity;

      _quantities[product.id] =
          currentQuantity + 1;
    });
  }

  void decreaseQuantity(
    CartProduct product,
  ) {
    final currentQuantity =
        _quantities[product.id] ??
            product.quantity;

    if (currentQuantity <= 1) {
      return;
    }

    setState(() {
      _quantities[product.id] =
          currentQuantity - 1;
    });
  }

  double calculateSubtotal(
    Cart userCart,
  ) {
    double subtotal = 0;

    for (final product
        in userCart.products) {
      final quantity =
          _quantities[product.id] ??
              product.quantity;

      subtotal +=
          product.price * quantity;
    }

    return subtotal;
  }

  double calculateDiscountedTotal(
    Cart userCart,
  ) {
    double discountedTotal = 0;

    for (final product
        in userCart.products) {
      final quantity =
          _quantities[product.id] ??
              product.quantity;

      final discount =
          product.discountPercentage /
              100;

      final discountedPrice =
          product.price *
              (1 - discount);

      discountedTotal +=
          discountedPrice *
              quantity;
    }

    return discountedTotal;
  }

  Future<void> openProduct(
    CartProduct cartProduct,
  ) async {
    try {
      final product =
          await _productService
              .getProductById(
        cartProduct.id,
      );

      if (!mounted) {
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ProductScreen(
            product: product,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Error loading product: $e",
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
      backgroundColor:
          Theme.of(context)
              .scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor:
            const Color(
          0xFF001D3D,
        ),

        elevation: 0,

        title: const Text(
          "Cart",
          style: TextStyle(
            fontWeight:
                FontWeight.w600,
          ),
        ),

        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Color(
                0xFFF0CB46,
              ),
            ),

            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const SettingsScreen(),
                ),
              );
            },
          ),

          SizedBox(
            width: 5.w,
          ),
        ],
      ),

      body: FutureBuilder<Cart>(
        future: cart,

        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(
                  0xFFCCA000,
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding:
                    EdgeInsets.all(
                  20.w,
                ),

                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 50,
                      color: Colors.red,
                    ),

                    SizedBox(
                      height: 12.h,
                    ),

                    Text(
                      "Error loading cart",
                      style: TextStyle(
                        fontFamily:
                            "Poppins",
                        fontSize:
                            18.sp,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    SizedBox(
                      height: 8.h,
                    ),

                    Text(
                      "${snapshot.error}",
                      textAlign:
                          TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                "No cart available",
              ),
            );
          }

          final Cart userCart =
              snapshot.data!;

          initializeQuantities(
            userCart,
          );

          final double subtotal =
              calculateSubtotal(
            userCart,
          );

          final double discountedTotal =
              calculateDiscountedTotal(
            userCart,
          );

          final double savings =
              subtotal -
                  discountedTotal;

          return Column(
            children: [
              Expanded(
                child:
                    ListView.builder(
                  padding:
                      EdgeInsets.fromLTRB(
                    14.w,
                    16.h,
                    14.w,
                    10.h,
                  ),

                  itemCount:
                      userCart
                          .products.length,

                  itemBuilder:
                      (
                    context,
                    index,
                  ) {
                    final CartProduct product =
                        userCart
                            .products[index];

                    final int quantity =
                        _quantities[
                                product.id] ??
                            product.quantity;

                    return Container(
                      margin:
                          EdgeInsets.only(
                        bottom:
                            13.h,
                      ),

                      decoration:
                          BoxDecoration(
                        color:
                            Theme.of(
                          context,
                        ).cardColor,

                        borderRadius:
                            BorderRadius.circular(
                          18.r,
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors
                                .black
                                .withValues(
                              alpha:
                                  0.06,
                            ),
                            blurRadius:
                                10,
                            offset:
                                const Offset(
                              0,
                              3,
                            ),
                          ),
                        ],
                      ),

                      child: InkWell(
                        borderRadius:
                            BorderRadius.circular(
                          18.r,
                        ),

                        onTap: () {
                          openProduct(
                            product,
                          );
                        },

                        child: Padding(
                          padding:
                              EdgeInsets.all(
                            13.w,
                          ),

                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .center,

                            children: [
                              Container(
                                width: 76.w,
                                height: 76.w,

                                padding:
                                    EdgeInsets.all(
                                  5.w,
                                ),

                                decoration:
                                    BoxDecoration(
                                  color: Colors
                                      .grey
                                      .shade50,

                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    14.r,
                                  ),
                                ),

                                child:
                                    ClipRRect(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    12.r,
                                  ),

                                  child:
                                      Image.network(
                                    product
                                        .thumbnail,

                                    fit:
                                        BoxFit.contain,

                                    errorBuilder:
                                        (
                                      context,
                                      error,
                                      stackTrace,
                                    ) {
                                      return Icon(
                                        Icons
                                            .image_not_supported_outlined,
                                        color:
                                            Colors.grey,
                                        size:
                                            30.sp,
                                      );
                                    },
                                  ),
                                ),
                              ),

                              SizedBox(
                                width: 12.w,
                              ),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,

                                  children: [
                                    Text(
                                      product
                                          .title,

                                      maxLines: 2,

                                      overflow:
                                          TextOverflow
                                              .ellipsis,

                                      style:
                                          TextStyle(
                                        fontFamily:
                                            "Poppins",
                                        fontSize:
                                            13.sp,
                                        fontWeight:
                                            FontWeight
                                                .w600,
                                      ),
                                    ),

                                    SizedBox(
                                      height: 5.h,
                                    ),

                                    Text(
                                      "\$${product.price.toStringAsFixed(2)}",

                                      style:
                                          TextStyle(
                                        fontFamily:
                                            "Poppins",
                                        fontSize:
                                            15.sp,
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                        color:
                                            const Color(
                                          0xFFCCA000,
                                        ),
                                      ),
                                    ),

                                    SizedBox(
                                      height: 3.h,
                                    ),

                                    Text(
                                      "${product.discountPercentage.toStringAsFixed(0)}% off",

                                      style:
                                          TextStyle(
                                        fontFamily:
                                            "Poppins",
                                        fontSize:
                                            10.sp,
                                        color:
                                            Colors
                                                .grey
                                                .shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(
                                width: 10.w,
                              ),

                              Container(
                                height: 42.h,

                                padding:
                                    EdgeInsets.symmetric(
                                  horizontal:
                                      5.w,
                                  vertical:
                                      4.h,
                                ),

                                decoration:
                                    BoxDecoration(
                                  color: Colors
                                      .grey
                                      .shade100,

                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    12.r,
                                  ),
                                ),

                                child: Row(
                                  mainAxisSize:
                                      MainAxisSize
                                          .min,

                                  children: [
                                    SizedBox(
                                      width: 30.w,
                                      height:
                                          30.w,

                                      child:
                                          Material(
                                        color:
                                            Colors.white,

                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                          8.r,
                                        ),

                                        child:
                                            InkWell(
                                          borderRadius:
                                              BorderRadius
                                                  .circular(
                                            8.r,
                                          ),

                                          onTap:
                                              () {
                                            decreaseQuantity(
                                              product,
                                            );
                                          },

                                          child:
                                              Icon(
                                            Icons
                                                .remove,
                                            size:
                                                17.sp,
                                            color:
                                                const Color(
                                              0xFF001D3D,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(
                                      width: 7.w,
                                    ),

                                    SizedBox(
                                      width: 26.w,

                                      child: Text(
                                        "$quantity",
                                        textAlign:
                                            TextAlign
                                                .center,

                                        style:
                                            TextStyle(
                                          fontFamily:
                                              "Poppins",
                                          fontSize:
                                              13.sp,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                          color:
                                              const Color(
                                            0xFF001D3D,
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(
                                      width: 7.w,
                                    ),

                                    SizedBox(
                                      width: 30.w,
                                      height:
                                          30.w,

                                      child:
                                          Material(
                                        color:
                                            const Color(
                                          0xFFF0CB46,
                                        ),

                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                          8.r,
                                        ),

                                        child:
                                            InkWell(
                                          borderRadius:
                                              BorderRadius
                                                  .circular(
                                            8.r,
                                          ),

                                          onTap:
                                              () {
                                            increaseQuantity(
                                              product,
                                            );
                                          },

                                          child:
                                              Icon(
                                            Icons.add,
                                            size:
                                                17.sp,
                                            color:
                                                const Color(
                                              0xFF001D3D,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              Container(
                width:
                    double.infinity,

                padding:
                    EdgeInsets.fromLTRB(
                  18.w,
                  15.h,
                  18.w,
                  18.h,
                ),

                decoration:
                    BoxDecoration(
                  color:
                      Theme.of(context)
                          .cardColor,

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withValues(
                        alpha: 0.07,
                      ),
                      blurRadius: 10,
                      offset:
                          const Offset(
                        0,
                        -3,
                      ),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                      children: [
                        Text(
                          "Subtotal",
                          style: TextStyle(
                            fontFamily:
                                "Poppins",
                            fontSize: 13.sp,
                            color: Colors
                                .grey
                                .shade700,
                          ),
                        ),

                        Text(
                          "\$${subtotal.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontFamily:
                                "Poppins",
                            fontSize: 14.sp,
                            fontWeight:
                                FontWeight
                                    .w600,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 7.h,
                    ),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                      children: [
                        Text(
                          "Discount",
                          style: TextStyle(
                            fontFamily:
                                "Poppins",
                            fontSize: 13.sp,
                            color: Colors
                                .grey
                                .shade700,
                          ),
                        ),

                        Text(
                          "-\$${savings.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontFamily:
                                "Poppins",
                            fontSize: 13.sp,
                            fontWeight:
                                FontWeight
                                    .w600,
                            color:
                                Colors.green,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 9.h,
                    ),

                    Divider(
                      color:
                          Colors.grey.shade300,
                    ),

                    SizedBox(
                      height: 4.h,
                    ),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                      children: [
                        Text(
                          "Total",
                          style: TextStyle(
                            fontFamily:
                                "Poppins",
                            fontSize: 15.sp,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),

                        Text(
                          "\$${discountedTotal.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontFamily:
                                "Poppins",
                            fontSize: 19.sp,
                            fontWeight:
                                FontWeight
                                    .bold,
                            color:
                                const Color(
                              0xFFCCA000,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 15.h,
                    ),

                    SizedBox(
                      width:
                          double.infinity,

                      child:
                          ElevatedButton(
                        style:
                            ElevatedButton
                                .styleFrom(
                          backgroundColor:
                              const Color(
                            0xFFF0CB46,
                          ),
                          foregroundColor:
                              const Color(
                            0xFF001D3D,
                          ),
                          elevation: 0,
                          padding:
                              EdgeInsets
                                  .symmetric(
                            vertical:
                                15.h,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              12.r,
                            ),
                          ),
                        ),

                        onPressed: () {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                            const SnackBar(
                              content:
                                  Text(
                                "Order confirmed",
                              ),
                            ),
                          );
                        },

                        child: const Text(
                          "Confirm Order",
                          style: TextStyle(
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),

      // Lab Activity 3 - Enhancement 2: Chat remains hidden specifically while the user is on CartScreen.
      bottomNavigationBar:
          BottomNavigationBar(
        currentIndex: 1,

        type:
            BottomNavigationBarType.fixed,

        selectedItemColor:
            const Color(
          0xFFCCA000,
        ),

        unselectedItemColor:
            Colors.grey,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart,
            ),
            label: "Cart",
          ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: "Profile",
          ),
        ],

        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(
              context,
              '/home',
            );
          }

          if (index == 2) {
            Navigator.pushReplacementNamed(
              context,
              '/profile',
            );
          }
        },
      ),
    );
  }
}