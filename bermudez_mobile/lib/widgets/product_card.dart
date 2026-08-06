import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/product.dart';



class ProductCard extends StatelessWidget {


  final Product product;

  final VoidCallback onTap;



  const ProductCard({

    super.key,

    required this.product,

    required this.onTap,

  });



  @override
  Widget build(BuildContext context) {


    return GestureDetector(

      onTap: onTap,


      child: Card(


        elevation: 4,


        color: Theme.of(context).cardColor,



        shape: RoundedRectangleBorder(


          borderRadius:

          BorderRadius.circular(16),


        ),



        child: Padding(


          padding:

          EdgeInsets.all(10.w),



          child: Column(


            crossAxisAlignment:

            CrossAxisAlignment.start,



            children: [



              // Product Image

              ClipRRect(


                borderRadius:

                BorderRadius.circular(12),



                child: Image.network(


                  product.thumbnail,



                  height: 120.h,



                  width:

                  double.infinity,



                  fit:

                  BoxFit.cover,



                  errorBuilder:

                      (context, error, stackTrace) {



                    return Container(


                      height: 120.h,


                      width:

                      double.infinity,



                      color:

                      const Color(0xFF003566),



                      child:

                      const Icon(


                        Icons.image_not_supported,


                        color: Colors.white,


                      ),



                    );


                  },


                ),



              ),




              SizedBox(height: 10.h),






              // Product Title

              Text(


                product.title,



                maxLines: 2,



                overflow:

                TextOverflow.ellipsis,



                style:

                TextStyle(


                  fontFamily:

                  "Poppins",



                  fontSize:

                  14.sp,



                  fontWeight:

                  FontWeight.bold,



                  color:

                  Theme.of(context)

                      .brightness == Brightness.dark

                      ? Colors.white

                      : const Color(0xFF000814),



                ),



              ),





              SizedBox(height: 6.h),






              // Category

              Text(


                product.category.toUpperCase(),



                style:

                TextStyle(



                  fontFamily:

                  "Poppins",



                  fontSize:

                  11.sp,



                  color:

                  const Color(0xFF003566),



                  fontWeight:

                  FontWeight.w600,



                ),



              ),






              const Spacer(),






              // Price

              Text(



                "\$${product.price}",



                style:

                TextStyle(



                  fontFamily:

                  "Poppins",



                  fontSize:

                  16.sp,



                  fontWeight:

                  FontWeight.bold,



                  color:

                  const Color(0xFFCCA000),



                ),



              ),



            ],



          ),



        ),



      ),



    );


  }


}