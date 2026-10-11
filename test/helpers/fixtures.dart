import 'package:my_car/features/auth/data/models/app_user_model.dart';
import 'package:my_car/features/auth/domain/entities/app_user.dart';

const tEmail = 'jessica@mail.com';
const tPassword = 'secret123';
const tName = 'Jessica';

const tUserModel = AppUserModel(id: '1', name: tName, email: tEmail);
const tUser = AppUser(id: '1', name: tName, email: tEmail);
