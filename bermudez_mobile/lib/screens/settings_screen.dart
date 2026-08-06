import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';



class SettingsScreen extends StatelessWidget {


  const SettingsScreen({super.key});



  @override
  Widget build(BuildContext context) {


    final themeProvider =

    Provider.of<ThemeProvider>(context);



    return Scaffold(


      appBar: AppBar(

        title:

        const Text(

          "Settings",

        ),

      ),



      body:

      Card(

        margin:

        const EdgeInsets.all(16),


        child:

        ListTile(


          title:

          const Text(

            "Dark Mode",

          ),



          trailing:

          Switch(

            value:

            themeProvider.isDarkMode,



            activeThumbColor: const Color(0xFFCCA000),



            onChanged:

                (value){

              themeProvider.toggleTheme();

            },


          ),


        ),


      ),


    );


  }


}