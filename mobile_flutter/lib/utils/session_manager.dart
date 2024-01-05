import 'dart:async' show Future;
import 'dart:convert';

import 'package:g_json/g_json.dart';
import 'package:firefly/data/model/branch_office_model.dart';
import 'package:firefly/data/model/department_model.dart';
import 'package:firefly/data/model/organization_model.dart';
import 'package:firefly/data/model/team_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/user_model.dart';

// - Key for Shared Preferences
class SessionManagerKey {
  static const String TOKEN = 'TOKEN';
  static const String USER_PROFILE = 'USER_PROFILE';

  static const String FIREBASE_TOKEN = 'FIREBASE_TOKEN';

  static const String ORGANIZATION = 'ORGANIZATION';
  static const String BRANCH_OFFICE = 'BRANCH_OFFICE';
  static const String DEPARTMENT = 'DEPARTMENT';
  static const String TEAM = 'TEAM';

  // static const String IS_FIRST_OPEN_APP = 'IS_FIRST_OPEN_APP';
  // static const String REGIONS = 'REGIONS';
  // static const String ADDRESS = 'ADDRESS';

  // static const String MY_LOCATION = 'MY_LOCATION';
  // static const String KEY_COUNTRY = 'KEY_COUNTRY';
  // static const String LAST_SENT = 'LAST_SENT';
  // static const String LAST_SESSION = 'LAST_SESSION';
  // static const String ORGANIZATION = 'ORGANIZATION';
  // static const String ID_BRANCH_OFFICE = 'ID_BRANCH_OFFICE';
  // static const String ACCESS_TOKEN_GOOGLE_CALENDAR =
  //     'ACCESS_TOKEN_GOOGLE_CALENDAR';
  // static const String LANGUAGE_LOCAL = 'LANGUAGE_LOCAL';
}

class SessionManager {
  SessionManager._privateConstructor();

  static final SessionManager share = SessionManager._privateConstructor();

  Future<bool> removeAll() async {
    final myPrefs = await SharedPreferences.getInstance();
    return myPrefs.clear();
  }

  // Check authentication
  Future<bool> isAuthentication() async {
    return await getToken() != null;
  }

  // Save Token
  Future<bool> saveToken({required String token}) async {
    final myPrefs = await SharedPreferences.getInstance();
    return myPrefs.setString(SessionManagerKey.TOKEN, token);
  }

  Future<String?> getToken() async {
    final myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString(SessionManagerKey.TOKEN);
  }

  Future<bool> removeToken() async {
    final myPrefs = await SharedPreferences.getInstance();
    return myPrefs.remove(SessionManagerKey.TOKEN);
  }

  // Save User profile
  Future<bool> saveUserProfile({UserModel? userProfile}) async {
    final myPrefs = await SharedPreferences.getInstance();
    final userEncode = jsonEncode(userProfile);
    return myPrefs.setString(
      SessionManagerKey.USER_PROFILE,
      userEncode,
    );
  }

  Future<UserModel?> getUserProfile() async {
    dynamic userModel;

    final myPrefs = await SharedPreferences.getInstance();
    final userString = myPrefs.getString(SessionManagerKey.USER_PROFILE);
    if (userString != null) {
      userModel = UserModel.fromJson(JSON(jsonDecode(userString)));
    }
    return userModel;
  }

  Future<bool> removeProfile() async {
    final myPrefs = await SharedPreferences.getInstance();
    return myPrefs.remove(SessionManagerKey.USER_PROFILE);
  }

  // Save Token
  Future<bool> saveFirebaseToken({required String firebaseToken}) async {
    final myPrefs = await SharedPreferences.getInstance();
    return myPrefs.setString(SessionManagerKey.FIREBASE_TOKEN, firebaseToken);
  }

  Future<String?> getFirebaseToken() async {
    final myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString(SessionManagerKey.FIREBASE_TOKEN);
  }

  Future<bool> removeFirebaseToken() async {
    final myPrefs = await SharedPreferences.getInstance();
    return myPrefs.remove(SessionManagerKey.FIREBASE_TOKEN);
  }

  // Is first open App
  // Future<bool> saveIsFirstOpenApp() async {
  //   final myPrefs = await SharedPreferences.getInstance();
  //   return myPrefs.setBool(SessionManagerKey.IS_FIRST_OPEN_APP, false);
  // }

  // Future<bool> getIsFirstOpenApp() async {
  //   final myPrefs = await SharedPreferences.getInstance();
  //   return myPrefs.getBool(SessionManagerKey.IS_FIRST_OPEN_APP) ?? true;
  // }

  // Future<bool> removeIsFirstOpenApp() async {
  //   final myPrefs = await SharedPreferences.getInstance();
  //   return myPrefs.remove(SessionManagerKey.IS_FIRST_OPEN_APP);
  // }

  // // Remove all data save local
  // Future<bool> removeAll() async {
  //   final myPrefs = await SharedPreferences.getInstance();
  //   return myPrefs.clear();
  // }

  // // Save Token
  // Future<bool> saveGoogleToken({required String token}) async {
  //   final myPrefs = await SharedPreferences.getInstance();
  //   return myPrefs.setString(
  //       SessionManagerKey.ACCESS_TOKEN_GOOGLE_CALENDAR, token);
  // }

  // Future<String?> getGoogleToken() async {
  //   final myPrefs = await SharedPreferences.getInstance();
  //   return myPrefs.getString(SessionManagerKey.ACCESS_TOKEN_GOOGLE_CALENDAR);
  // }

  // Future<bool> removeGoogleToken() async {
  //   final myPrefs = await SharedPreferences.getInstance();
  //   return myPrefs.remove(SessionManagerKey.ACCESS_TOKEN_GOOGLE_CALENDAR);
  // }

  // // Save Key Country
  // Future<bool> saveKeyCountry({required String key}) async {
  //   final myPrefs = await SharedPreferences.getInstance();
  //   return myPrefs.setString(SessionManagerKey.KEY_COUNTRY, key);
  // }

  // Future<String?> getKeyCountry() async {
  //   final myPrefs = await SharedPreferences.getInstance();
  //   return myPrefs.getString(SessionManagerKey.KEY_COUNTRY);
  // }

  // // Save last sent code
  // Future<bool> saveLastSentCode(
  //     {required int timeStamp, required String phoneNumber}) async {
  //   final myPrefs = await SharedPreferences.getInstance();
  //   return myPrefs.setString(
  //     '${SessionManagerKey.LAST_SENT}_{$phoneNumber}',
  //     timeStamp.toString(),
  //   );
  // }

  // Future<String?> getLastSentCode({required String phoneNumber}) async {
  //   final myPrefs = await SharedPreferences.getInstance();
  //   return myPrefs.getString('${SessionManagerKey.LAST_SENT}_{$phoneNumber}');
  // }

  // // Save last session
  // Future<bool> saveLastSession(
  //     {required String verificationId, required String phoneNumber}) async {
  //   final myPrefs = await SharedPreferences.getInstance();
  //   return myPrefs.setString(
  //     '${SessionManagerKey.LAST_SESSION}_{$phoneNumber}',
  //     verificationId,
  //   );
  // }

  // Future<String?> getLastSession({required String phoneNumber}) async {
  //   final myPrefs = await SharedPreferences.getInstance();
  //   return myPrefs
  //       .getString('${SessionManagerKey.LAST_SESSION}_{$phoneNumber}');
  // }

  // Future<String?> getKeyLanguageSave() async {
  //   final myPrefs = await SharedPreferences.getInstance();
  //   return myPrefs.getString(SessionManagerKey.LANGUAGE_LOCAL);
  // }

  // Future<bool> saveKeyLanguageSave(String key) async {
  //   Singleton.instance.currentLanguageCode = key;
  //   final myPrefs = await SharedPreferences.getInstance();
  //   return myPrefs.setString(SessionManagerKey.LANGUAGE_LOCAL, key);
  // }

  Future<bool> saveOrganization({OrganizationModel? organizationModel}) async {
    final myPrefs = await SharedPreferences.getInstance();
    final userEncode = jsonEncode(organizationModel);
    return myPrefs.setString(
      SessionManagerKey.ORGANIZATION,
      userEncode,
    );
  }

  Future<OrganizationModel?> getOrganization() async {
    dynamic org;

    final myPrefs = await SharedPreferences.getInstance();
    final str = myPrefs.getString(SessionManagerKey.ORGANIZATION);
    if (str != null) {
      org = OrganizationModel.fromJson(JSON(jsonDecode(str)));
    }
    return org;
  }

  Future<bool> removeOrganization() async {
    final myPrefs = await SharedPreferences.getInstance();
    return myPrefs.remove(SessionManagerKey.ORGANIZATION);
  }

  Future<bool> saveBranchOffice({BranchOfficeModel? branchModel}) async {
    final myPrefs = await SharedPreferences.getInstance();
    final userEncode = jsonEncode(branchModel);
    return myPrefs.setString(
      SessionManagerKey.BRANCH_OFFICE,
      userEncode,
    );
  }

  Future<BranchOfficeModel?> getBranchOffice() async {
    dynamic org;

    final myPrefs = await SharedPreferences.getInstance();
    final str = myPrefs.getString(SessionManagerKey.BRANCH_OFFICE);
    if (str != null) {
      org = BranchOfficeModel.fromJson(JSON(jsonDecode(str)));
    }
    return org;
  }

  Future<bool> removeBranchOffice() async {
    final myPrefs = await SharedPreferences.getInstance();
    return myPrefs.remove(SessionManagerKey.BRANCH_OFFICE);
  }

  Future<bool> saveDepartment({DepartmentModel? departmentModel}) async {
    final myPrefs = await SharedPreferences.getInstance();
    final userEncode = jsonEncode(departmentModel);
    return myPrefs.setString(
      SessionManagerKey.DEPARTMENT,
      userEncode,
    );
  }

  Future<DepartmentModel?> getDepartment() async {
    dynamic org;

    final myPrefs = await SharedPreferences.getInstance();
    final str = myPrefs.getString(SessionManagerKey.DEPARTMENT);
    if (str != null) {
      org = DepartmentModel.fromJson(JSON(jsonDecode(str)));
    }
    return org;
  }

  Future<bool> removeDepartment() async {
    final myPrefs = await SharedPreferences.getInstance();
    return myPrefs.remove(SessionManagerKey.DEPARTMENT);
  }

  Future<bool> saveTeam({TeamModel? teamModel}) async {
    final myPrefs = await SharedPreferences.getInstance();
    final userEncode = jsonEncode(teamModel);
    return myPrefs.setString(
      SessionManagerKey.TEAM,
      userEncode,
    );
  }

  Future<TeamModel?> getTeam() async {
    dynamic org;

    final myPrefs = await SharedPreferences.getInstance();
    final str = myPrefs.getString(SessionManagerKey.TEAM);
    if (str != null) {
      org = TeamModel.fromJson(JSON(jsonDecode(str)));
    }
    return org;
  }

  Future<bool> removeTeam() async {
    final myPrefs = await SharedPreferences.getInstance();
    return myPrefs.remove(SessionManagerKey.TEAM);
  }
}
