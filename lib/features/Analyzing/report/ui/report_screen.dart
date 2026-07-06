import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/Analyzing/chossen_screen.dart';
import 'package:mindsense_app/features/Analyzing/logic/analyzing_provider.dart';
import 'package:mindsense_app/features/Analyzing/photo%20analysis/logic/photo_analysis_provider.dart';
import 'package:mindsense_app/features/Analyzing/report/ui/widgets/imageanalysis_report_wid.dart';
import 'package:mindsense_app/features/Analyzing/report/ui/widgets/overallstate_wid.dart';
import 'package:mindsense_app/features/Analyzing/report/ui/widgets/voiceanalysis_report_wid.dart';
import 'package:mindsense_app/features/Analyzing/voice%20analysis/logic/voice_analysis_provider.dart';
import 'package:mindsense_app/features/doctors/ui/doctors_screen.dart';
import 'package:mindsense_app/features/games/logic/gamification_provider.dart';
import 'package:mindsense_app/features/games/ui/games_hub_screen.dart';
import 'package:mindsense_app/features/games/ui/widgets/game_recommendation_card.dart';
import 'package:mindsense_app/features/home/logic/homescreenprovider.dart';
import 'package:mindsense_app/features/main_nav/logic/mainscreenprovider.dart';
import 'package:mindsense_app/features/main_nav/ui/main_screen.dart';
import 'package:provider/provider.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Analysis Report",style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSecondary
        ),),
        centerTitle: true,
      ),
    
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal:  12.0.w),
        child: SingleChildScrollView(
          child: Consumer<AnalyzingProvider>(
            builder: (context,analyzingProvider,child) {
              return Column(
                children: [
                  analyzingProvider.analysistype=="all"?
                  Column(
                    children: [
                      SizedBox(height: 20.h,),
                      OverallstateWid(),
                    ],
                  ):SizedBox.shrink(),
                  
                  analyzingProvider.analysistype=="face"?
                  Column(
                    children: [
                      SizedBox(height: 20.h,),
                      ImageanalysisReportWid(),
                    ],
                  ):SizedBox.shrink(),
                  analyzingProvider.analysistype=="voice"?
                  Column(
                    children: [
                      SizedBox(height: 20.h,),
                      VoiceanalysisReportWid(),
                    ],
                  ):SizedBox.shrink(),
                  
                  
                  SizedBox(height: 32.h,),
                  
                  Consumer<GamificationProvider>(
                    builder: (context, gp, _) {
                      if (gp.activeSpec != null) {
                        return GameRecommendationCard(
                          spec: gp.activeSpec!,
                          onPlayNow: () {                                                
                            
                            Navigator.push(context, MaterialPageRoute(builder: (context) => GamesHubScreen(),));
                          },
                        );
                      }
              
                      return Container(      
                        width: double.infinity,
                        height: 51.h,       
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: AppColers.primaryColor,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: MaterialButton( 
                          padding: EdgeInsets.all(8),
                          onPressed:(){
                            WidgetsBinding.instance.addPostFrameCallback((_) {        
                              context.read<Homescreenprovider>().fetchEmotionHistory();
                            });
                            final analyzingProvider = context.read<AnalyzingProvider>();
                            String emotion = 'neutral';
                            final condition = analyzingProvider.detectedEmotion!.toLowerCase();
                            if (condition.contains('positive') || condition.contains('happy')) {
                              emotion = 'happy';
                            } else if (condition.contains('negative') || condition.contains('sad')) {
                              emotion = 'sad';
                            } else if (condition.contains('anxious') || condition.contains('stress')) {
                              emotion = 'anxious';
                            } else if (condition.contains('angry')) {
                              emotion = 'angry';
                            }
                            
                            double confidence = analyzingProvider.finalScore * 100;
                            gp.generateRecommendation(emotion, confidence);
                          },
                          child: Text("Get Recommendation",style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black
                          ),),                    
                        ),
                      );
                    }
                  ),
                  
                  analyzingProvider.detectedEmotion=="Sad"||analyzingProvider.detectedEmotion=="Angry"?
                  Column(
                    children: [
                      SizedBox(height: 20.h,),
                      Container(      
                        width: double.infinity,
                            height: 51.h,       
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: AppColers.primaryColor,
                              borderRadius: BorderRadius.circular(10)
                            ),
                          child: MaterialButton( 
                            padding: EdgeInsets.all(8),
                            onPressed: () {
                              WidgetsBinding.instance.addPostFrameCallback((_) {        
                              context.read<Homescreenprovider>().fetchEmotionHistory();
                            });
                              Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorsScreen(),));
                            },
                            child:Text("Meet A Doctor →",style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black
                            ),),
                        )
                      )
                    ],
                  )
                  
                  :SizedBox.shrink(),
                  SizedBox(height: 20.h,),
                  Consumer<AnalyzingProvider>(
                    builder: (context,val,child) {
                      return Container(      
                        width: double.infinity,
                        height: 51.h,       
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColers.primaryColor,
                            width: 2.w
                          )
                        ),
                         child: Consumer<VoiceAnalysisProvider>(
                          builder: (context,val2,child) {
                             return Consumer<PhotoAnalysisProvider>(
                              builder: (context,val3,child) {
                                return MaterialButton( 
                                  padding: EdgeInsets.all(8),
                                  onPressed:(){
                                    WidgetsBinding.instance.addPostFrameCallback((_) {        
                                      context.read<Homescreenprovider>().fetchEmotionHistory();
                                    });
                                    Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => MainScreen(),),(route) => false,);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChossenScreen(),));
                                    PaintingBinding.instance.imageCache.clear();
                                                val.selctedimage=null;
                                                val.selectedaudio=null;
                                                val2.cancelRecording();
                                                val3.clearSelectedImage();
                                  },
                                  child:Text("Restart Analysis",style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).colorScheme.onSecondary
                                  ),),                    
                                );
                              }
                            );
                          }
                        ),
                      );
                    }
                  ),
                  SizedBox(height: 20.h,),
                  Consumer<AnalyzingProvider>(
                    builder: (context,val,child) {
                      return Container(      
                        width: double.infinity,
                        height: 51.h,       
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Consumer<VoiceAnalysisProvider>(
                          builder: (context,val2,child) {
                            return Consumer<PhotoAnalysisProvider>(
                              builder: (context,val3,child) {
                                return MaterialButton( 
                                  padding: EdgeInsets.all(8),
                                  onPressed:(){
                                    WidgetsBinding.instance.addPostFrameCallback((_) {        
                                      context.read<Homescreenprovider>().fetchEmotionHistory();
                                    });
                                    Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => MainScreen(),),(route) => false,);
                                    PaintingBinding.instance.imageCache.clear();
                                    val.selctedimage=null;
                                    val.selectedaudio=null;
                                    val2.cancelRecording();
                                    val3.clearSelectedImage();
                                  },
                                  child: Text("End Analysis",style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color:Theme.of(context).colorScheme.onSecondary
                                  ),),                    
                                );
                              }
                            );
                          }
                        ),
                      );
                    }
                  ),
                  SizedBox(height: 23.h,),
              
                  
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}