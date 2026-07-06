import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_ageformfield.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_button.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_textformfield.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
import 'package:mindsense_app/features/profile/edit%20user%20information/logic/edit_user_information_provider.dart';
import 'package:mindsense_app/features/profile/logic/profile_screen_provider.dart';
import 'package:provider/provider.dart';

class EditinformationScreen extends StatelessWidget {
  const EditinformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;        
        if (context.mounted) {
          Navigator.pop(context, true);        
        }
        await context.read<ProfileScreenProvider>().init();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Edit Your Information",
            style: TextStyle(
              fontSize: 21.sp,
              color: Theme.of(context).colorScheme.onSecondary
            ),
          ),
          
        ),
        
        body: GestureDetector(
          onTap: (){
              FocusScope.of(context).unfocus();
            },
          child: SingleChildScrollView(
            child: SizedBox(
              height: 650.h,
              child: Padding(
                padding:  EdgeInsets.all(20.w),
                child: Consumer<EditUserInformationProvider>(
                  builder: (context,provider,child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Form(
                          key: provider.formKey,
                          child:
                          Padding(
                            padding:  EdgeInsets.all(0.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                      
                                Text("Name",style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.onSecondary,
                                ),),   
                                SizedBox(height: 4.h,),
                                      
                                CustomTextFormField(
                                  controller: provider.editNameController, 
                                  hintText: SharedPreferencesitem.getString("userName")??"Edit Your Name",
                                  //Icon: Icon(Icons.person_2_outlined),
                                  Icon: Padding(
                                    padding: const EdgeInsets.all(11.0),
                                    child: SvgPicture.asset(
                                      "assets/images/user-icon.svg",
                                      width: 21.5.w,
                                      height: 18.5.h,
                                    ),
                                  ),
                                  validator: provider.editFormValidator,
                                  
                                ),
                                SizedBox(height: 14.h,),
                                Text("Age",style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.onSecondary,
                                ),),   
                                SizedBox(height: 4.h,),
                                      
                                CustomAgeformfield(
                                  controller: provider.editAgeController, 
                                  hintText:SharedPreferencesitem.getInt("userAge").toString(),
                                  icon: Icon(Icons.email_outlined),
                                  validator: provider.editFormValidator,                                
                                ),
                                SizedBox(height: 14.h,),
                                      
                                      
                                
                                
                                SizedBox(height: 25.h,),
                                //login button
                                Column(
                                  children: [
                                    provider.editbuttonisloading==false?
                                    Center(
                                      child: CustomButton(text:"Save",
                                      onPressed: () {
                                        provider.editInfoButton(context);
                                      },
                                      ),
                                    ):
                                    Center(child: CircularProgressIndicator())
                                  ],
                                )
                                
                              ],
                                      
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


}