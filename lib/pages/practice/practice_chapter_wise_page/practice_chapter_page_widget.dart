import 'dart:convert';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:confetti/confetti.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neetprep_essential/clevertap/clevertap_service.dart';
import 'package:neetprep_essential/custom_code/widgets/custom_banner.dart';
import 'package:neetprep_essential/flutter_flow/flutter_flow_util.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../components/drawer/darwer_widget.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../utlis/text.dart';
import 'package:neetprep_essential/pages/practice/practice_chapter_wise_page/practice_chapter_page_model.dart';

class PracticeChapterPageWidget extends StatefulWidget {
  const PracticeChapterPageWidget({super.key});

  @override
  State<PracticeChapterPageWidget> createState() =>
      _PracticeChapterPageWidgetState();
}

class _PracticeChapterPageWidgetState extends State<PracticeChapterPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoadingTopics = true; // State variable to track loading state
  late ConfettiController _controllerCenter;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
