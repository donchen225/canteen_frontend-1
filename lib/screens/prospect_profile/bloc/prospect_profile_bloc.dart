import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/prospect_profile/bloc/prospect_profile_event.dart';
import 'package:canteen_frontend/screens/prospect_profile/bloc/prospect_profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProspectProfileBloc
    extends Bloc<ProspectProfileEvent, ProspectProfileState> {
  ProspectProfileBloc() {
    print('PROSPECT PROFILE BLOC CONSTRUCTOR');
  }

  @override
  ProspectProfileState get initialState => ProspectProfileLoading();

  @override
  Stream<ProspectProfileState> mapEventToState(
      ProspectProfileEvent event) async* {
    if (event is LoadProspectProfile) {
      yield* _mapLoadProspectProfileToState(event.user);
    } else if (event is ConfirmProspectProfile) {
      yield* _mapConfirmProspectProfileToState(event.user);
    }
  }

  Stream<ProspectProfileState> _mapLoadProspectProfileToState(
      User user) async* {
    yield ProspectProfileLoaded(user);
  }

  Stream<ProspectProfileState> _mapConfirmProspectProfileToState(
      User user) async* {
    yield ProspectProfileConfirmation(user);
  }
}
