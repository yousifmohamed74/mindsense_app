import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_snackbar.dart';
import 'package:mindsense_app/features/drive%20mode/logic/drivemode_provider.dart';
import 'package:mindsense_app/features/main_nav/ui/main_screen.dart';
import 'package:provider/provider.dart';

class DrivemodeScreen extends StatefulWidget {
  const DrivemodeScreen({super.key});

  @override
  State<DrivemodeScreen> createState() => _DrivemodeScreenState();
}

class _DrivemodeScreenState extends State<DrivemodeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DrivemodeProvider>().startFetching();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          context.read<DrivemodeProvider>().stopFetching(context);
          customSnackbar(context, true, "Drive mode closed");
          
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Drive Mode",
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
      
        body: Padding(
          padding:  EdgeInsets.symmetric(horizontal:  15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 35.h,),
              Text(
                textAlign:TextAlign.center, 
                "Ensure that you are connected \nto board wifi",style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),),
              SizedBox(height: 150.h,),
              Consumer<DrivemodeProvider>(
                builder: (context, provider, _) {
                  return
                   provider.isLoading?
                   CircularProgressIndicator()
                   :
                   Container(
                    width: double.infinity,
                    height: 250.h,
                    color: Colors.transparent,
                    child: ListView.separated(
                      itemCount: provider.showedData.length,
                      separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.white12),
                      itemBuilder: (context, index) {
                        final item = provider.showedData[index] as Map<String, dynamic>;
                        final label = (item['label'] ?? '').toString();
                        final Color color = label.contains('No face')
                            ? Colors.yellow
                            : label.contains('drowsy')
                                ? Colors.red
                                : label.contains('awake')
                                    ? Colors.green
                                    : Colors.white;
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
                          child: Row(
                            children: [
                              Text(
                                '[${item['timestamp'] ?? ''}]  ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  label.toUpperCase(),
                                  style: TextStyle(
                                    color: color,
                                    fontSize: 13.sp,
                                    fontFamily: 'monospace',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              Spacer(),
              Consumer<DrivemodeProvider>(
                builder: (context, provider, _) {
                  return Column(
                    children: [
                      if (provider.isAlerting) ...[
                        Container(
                          width: double.infinity,
                          decoration:BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(20.r),
                          ), 
                          child: MaterialButton( 
                            padding: EdgeInsets.all(8),
                            onPressed:(){
                              provider.stopAlert();
                            },
                            child: Text("Stop Alert",style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color:Theme.of(context).colorScheme.onSecondary
                            ),),                    
                          ),
                        ),
                        SizedBox(height: 15.h,),
                      ],
                      Container(
                        width: double.infinity,
                        decoration:BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20.r),
                        ), 
                        child: MaterialButton( 
                          padding: EdgeInsets.all(8),
                          onPressed:(){
                            provider.stopFetching(context);
                            Navigator.pop(context);                   
                          },
                          child: Text("Exit drive mode",style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color:Theme.of(context).colorScheme.onSecondary
                          ),),                    
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 50.h,)
              
            ],
          ),
        )
      ),
    );
  }
}