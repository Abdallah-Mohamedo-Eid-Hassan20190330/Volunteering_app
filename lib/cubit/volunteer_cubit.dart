import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volunteer_app/cubit/volunteer_states.dart';

class VolunteerCubit extends Cubit<VolunteerState> {
  VolunteerCubit() : super(InitialState());
  static VolunteerCubit get(context) => BlocProvider.of(context);

  bool hidden = true;
  bool hiddenLogin = true;
  void changeVisibilty() {
    hidden = !hidden;
    emit(changeVisibiltyState());
  }

  void changeLoginVisiblity() {
    hiddenLogin = !hiddenLogin;
    emit(changeVisibiltyState());
  }
}
