import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/product.dart';



class ProductScreen extends StatelessWidget {

  final Product product;


  const ProductScreen({

    super.key,

    required this.product,

  });



  Widget sectionTitle(String title) {

    return Padding(

      padding: EdgeInsets.only(

        top: 20.h,

        bottom: 10.h,

      ),

      child: Text(

        title,

        style: TextStyle(

          fontFamily: "Poppins",

          fontSize: 18.sp,

          fontWeight: FontWeight.bold,

          color: const Color(0xFF001D3D),

        ),

      ),

    );

  }




  Widget detailRow(

      IconData icon,

      String title,

      String value,

      ) {


    return Padding(

      padding: EdgeInsets.symmetric(

        vertical: 8.h,

      ),

      child: Row(

        children: [


          Icon(

            icon,

            size: 22.sp,

            color: const Color(0xFF003566),

          ),



          SizedBox(width: 12.w),



          Expanded(

            child: Column(

              crossAxisAlignment:

              CrossAxisAlignment.start,


              children: [


                Text(

                  title,

                  style: TextStyle(

                    fontFamily: "Poppins",

                    fontSize: 12.sp,

                    color: Colors.grey,

                  ),

                ),



                Text(

                  value,

                  style: TextStyle(

                    fontFamily: "Poppins",

                    fontSize: 14.sp,

                    fontWeight: FontWeight.w600,

                    color: const Color(0xFF000814),

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

      padding: EdgeInsets.symmetric(

        horizontal: 10.w,

        vertical: 5.h,

      ),


      decoration: BoxDecoration(

        color: color,

        borderRadius:

        BorderRadius.circular(20),

      ),


      child: Text(

        text,

        style: const TextStyle(

          color: Colors.white,

          fontWeight: FontWeight.bold,

        ),

      ),

    );

  }





  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar: AppBar(

        title: const Text(

          "Product Details",

        ),

      ),




      body: SingleChildScrollView(



        padding: EdgeInsets.all(16.w),



        child: Column(



          crossAxisAlignment:

          CrossAxisAlignment.start,



          children: [




            // PRODUCT IMAGE


            Container(

              decoration: BoxDecoration(

                borderRadius:

                BorderRadius.circular(20),


                boxShadow: const [

                  BoxShadow(

                    blurRadius: 8,

                    offset: Offset(0,4),

                    color: Colors.black26,

                  ),

                ],

              ),



              child: ClipRRect(

                borderRadius:

                BorderRadius.circular(20),



                child: Image.network(

                  product.thumbnail,


                  height: 280.h,


                  width: double.infinity,


                  fit: BoxFit.cover,


                ),

              ),


            ),




            SizedBox(height:20.h),




            // PRODUCT TITLE


            Text(

              product.title,


              style: TextStyle(

                fontFamily: "Poppins",

                fontSize: 25.sp,

                fontWeight: FontWeight.bold,

                color: const Color(0xFF000814),

              ),

            ),




            SizedBox(height:10.h),




            // CATEGORY + STOCK


            Row(

              children: [


                badge(

                  product.category.toUpperCase(),

                  const Color(0xFF003566),

                ),



                SizedBox(width:10.w),



                badge(

                  product.stock > 0

                      ? "IN STOCK"

                      : "OUT OF STOCK",

                  product.stock > 0

                      ? const Color(0xFFCCA000)

                      : Colors.red,

                ),


              ],

            ),




            SizedBox(height:15.h),




            // PRICE


            Text(

              "\$${product.price}",


              style: TextStyle(

                fontFamily: "Poppins",

                fontSize: 28.sp,

                fontWeight: FontWeight.bold,

                color: const Color(0xFFCCA000),

              ),

            ),




            SizedBox(height:15.h),




            // RATING


            Row(

              children: [


                const Icon(

                  Icons.star,

                  color: Color(0xFFF0CB46),

                ),



                SizedBox(width:5.w),



                Text(

                  "${product.rating} Rating",

                  style: TextStyle(

                    fontFamily: "Poppins",

                    fontSize: 15.sp,

                    fontWeight: FontWeight.w600,

                  ),

                ),


              ],

            ),




            // DESCRIPTION


            sectionTitle(

              "Description",

            ),



            Text(

              product.description,


              style: TextStyle(

                fontFamily: "Poppins",

                fontSize: 15.sp,

              ),

            ),





            // PRODUCT DETAILS


            sectionTitle(

              "Product Details",

            ),



            detailRow(

              Icons.category,

              "Category",

              product.category,

            ),



            detailRow(

              Icons.business,

              "Brand",

              product.brand,

            ),



            detailRow(

              Icons.inventory,

              "Available Stock",

              "${product.stock} items",

            ),



            detailRow(

              Icons.scale,

              "Weight",

              "${product.weight} g",

            ),





            // SPECIFICATIONS


            sectionTitle(

              "Specifications",

            ),



            detailRow(

              Icons.straighten,

              "Dimensions",

              product.dimensions,

            ),



            detailRow(

              Icons.security,

              "Warranty",

              product.warrantyInformation,

            ),



            detailRow(

              Icons.local_shipping,

              "Shipping",

              product.shippingInformation,

            ),



            detailRow(

              Icons.assignment_return,

              "Return Policy",

              product.returnPolicy,

            ),



          ],



        ),



      ),



    );


  }


}