import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart';

import '../screens/product_screen.dart';
import 'settings_screen.dart';



class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});


  @override
  State<HomeScreen> createState() => _HomeScreenState();

}



class _HomeScreenState extends State<HomeScreen> {


  final ProductService _productService =
  ProductService();



  late Future<List<Product>> products;



  // Enhancement 1: Search functionality

  final TextEditingController _searchController =
  TextEditingController();



  List<Product> filteredProducts = [];



  @override
  void initState() {

    super.initState();

    products = _productService.getAllProducts();

  }



  void searchProducts(

      String query,

      List<Product> productList

      ) {


    setState(() {


      if(query.isEmpty) {


        filteredProducts = productList;


      }

      else {


        filteredProducts =

            productList.where((product) {


              return product.title

                  .toLowerCase()

                  .contains(

                  query.toLowerCase()

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
  Widget build(BuildContext context) {


    return Scaffold(



      appBar: AppBar(


        backgroundColor:

        const Color(0xFF001D3D),



        title: Image.asset(


          "assets/images/nubdexchange_logo.png",



          height: 45.h,



        ),




        actions: [



          // Enhancement 3: Settings page


          IconButton(



            icon: const Icon(

              Icons.settings,

              color: Color(0xFFF0CB46),

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


        ],



      ),





      body: FutureBuilder<List<Product>>(



        future: products,




        builder: (context, snapshot) {



          if(snapshot.connectionState ==

              ConnectionState.waiting) {



            return const Center(

              child: CircularProgressIndicator(

                color: Color(0xFFCCA000),

              ),

            );


          }




          if(snapshot.hasError) {


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




          final productList =

          snapshot.data ?? [];




          if(filteredProducts.isEmpty) {


            filteredProducts = productList;


          }




          return Column(



            children: [




              // Enhancement 1: Search bar


              Padding(


                padding:

                EdgeInsets.all(12.w),



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


                      color:

                      Color(0xFF003566),


                    ),





                    filled:

                    true,





                    fillColor:

                    Colors.white,





                    border:

                    OutlineInputBorder(



                      borderRadius:

                      BorderRadius.circular(16),



                      borderSide:

                      BorderSide.none,



                    ),



                  ),



                ),



              ),






              Expanded(



                child:

                GridView.builder(




                  padding:

                  EdgeInsets.all(12.w),




                  gridDelegate:

                  const SliverGridDelegateWithFixedCrossAxisCount(



                    crossAxisCount: 2,



                    crossAxisSpacing: 12,



                    mainAxisSpacing: 12,



                    childAspectRatio: 0.65,



                  ),






                  itemCount:

                  filteredProducts.length,







                  itemBuilder:

                      (context, index) {



                    final product =

                    filteredProducts[index];






// Enhancement 2: Navigate to product details page
                    return ProductCard(



                      product:

                      product,





                      onTap: () {



                        Navigator.push(



                          context,



                          MaterialPageRoute(



                            builder: (_) =>

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



    );


  }


}