import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart';
import 'product_screen.dart';
import 'settings_screen.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _productService =
      ProductService();

  late Future<List<Product>> products;

  final TextEditingController _searchController =
      TextEditingController();

  List<Product> filteredProducts = [];

  bool _productsInitialized = false;

  @override
  void initState() {
    super.initState();

    products = _productService.getAllProducts();
  }

  void searchProducts(
    String query,
    List<Product> productList,
  ) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts =
            List.from(productList);
      } else {
        filteredProducts =
            productList.where((product) {
          return product.title
              .toLowerCase()
              .contains(
                query.toLowerCase(),
              );
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
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
            const Color(0xFF001D3D),

        elevation: 0,

        title: Image.asset(
          "assets/images/nubdexchange_logo.png",
          height: 45.h,
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

      body: FutureBuilder<List<Product>>(
        future: products,

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
              child: Text(
                "Error loading products",
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: Theme.of(context)
                      .colorScheme
                      .primary,
                ),
              ),
            );
          }

          final List<Product> productList =
              snapshot.data ?? [];

          if (!_productsInitialized) {
            filteredProducts =
                List.from(productList);

            _productsInitialized = true;
          }

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(
                  12.w,
                ),
                child: TextField(
                  controller:
                      _searchController,

                  onChanged: (value) {
                    searchProducts(
                      value,
                      productList,
                    );
                  },

                  decoration: InputDecoration(
                    hintText:
                        "Search products",

                    prefixIcon:
                        const Icon(
                      Icons.search,
                      color: Color(
                        0xFF003566,
                      ),
                    ),

                    filled: true,
                    fillColor:
                        Colors.white,

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        16.r,
                      ),
                      borderSide:
                          BorderSide.none,
                    ),
                  ),
                ),
              ),

              Expanded(
                child:
                    filteredProducts.isEmpty
                        ? Center(
                            child: Text(
                              "No products found",
                              style: TextStyle(
                                fontFamily:
                                    "Poppins",
                                fontSize:
                                    14.sp,
                              ),
                            ),
                          )
                        : GridView.builder(
                            padding:
                                EdgeInsets.all(
                              12.w,
                            ),

                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  2,
                              crossAxisSpacing:
                                  12,
                              mainAxisSpacing:
                                  12,
                              childAspectRatio:
                                  0.65,
                            ),

                            itemCount:
                                filteredProducts
                                    .length,

                            itemBuilder:
                                (
                              context,
                              index,
                            ) {
                              final product =
                                  filteredProducts[
                                      index];

                              // Lab Activity 2 - Enhancement 2: Opens the existing ProductScreen.
                              return ProductCard(
                                product:
                                    product,
                                onTap:
                                    () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) =>
                                              ProductScreen(
                                        product:
                                            product,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
              ),
            ],
          );
        },
      ),

      // Lab Activity 3 - Enhancement 2:
      // Chat FloatingActionButton
      floatingActionButton:
          FloatingActionButton(
        backgroundColor:
            const Color(
          0xFFF0CB46,
        ),

        foregroundColor:
            const Color(
          0xFF001D3D,
        ),

        elevation: 5,

        tooltip: "Chat",

        onPressed: () {
          ScaffoldMessenger.of(context)
              .showSnackBar(
            const SnackBar(
              content: Text(
                "Chat selected",
              ),
            ),
          );
        },

        child: const Icon(
          Icons.chat,
        ),
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation
              .endFloat,

      bottomNavigationBar:
          BottomNavigationBar(
        currentIndex: 0,

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
        ],

        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const CartScreen(),
              ),
            );
          }
        },
      ),
    );
  }
}