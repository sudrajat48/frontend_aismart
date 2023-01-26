// This file contains the dependencies used in the available theme, helpers, utilities

import 'dart:convert';
import 'dart:io';

import 'package:ai_smart/models/global_model.dart';
import 'package:ai_smart/models/user_preference_model.dart';
import 'package:ai_smart/views/pages/pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

part 'app_config.dart';
part 'helpers.dart';
part 'utilities.dart';
