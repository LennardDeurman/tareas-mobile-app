import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tareas/constants/brand_colors.dart';
import 'package:tareas/constants/translation_keys.dart';
import 'package:tareas/managers/extensions.dart';
import 'package:tareas/network/auth/service.dart';
import 'package:tareas/pages/startup.dart';
import 'package:tareas/ui/extensions/buttons.dart';
import 'package:tareas/ui/extensions/headers.dart';
import 'package:tareas/ui/extensions/dates.dart';
import 'package:tareas/ui/social_point.dart';

class ProfilePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }

}

class ProfilePageUI {



  Widget textCell({@required String label, @required String text}) {
    return cell(
        label: label,
        child: Container(
          child: Text(text,
              style: TextStyle(
                  fontSize: 16
              )
          ),
          margin: EdgeInsets.symmetric(
              vertical: 8
          ),
        )
    );
  }

  Widget cell({@required String label, @required Widget child}) {
    return Container(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 16,
              color: BrandColors.textLabelColor
          ),
        ),
        child
      ],
    ), padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 20
    ));

  }



}

class _ProfilePageState extends State<ProfilePage> with ProfilePageUI {

  //TODO: Delete button
  //TODO: Sign out button
  //TODO:

  LoadingDelegate _loadingDelegate = LoadingDelegate();

  void _signOut() {
    Future future = AuthService().logout().then((value) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return StartupPage();
          }
      ), (route) => false);
    });
    _loadingDelegate.attachFuture(future);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: RefreshIndicator(
          onRefresh: () {
            return AuthService().performIdentityFetch();
          },
          child: ListView(
            children: () {
              List<Widget> widgets = [];
              var pageHeader = PageHeader(
                title: FlutterI18n.translate(context, TranslationKeys.profile),
              );

              widgets.add(pageHeader);
              var activeMember = AuthService().identityResult.activeMember;
              var nameCell = textCell(
                  label: FlutterI18n.translate(context, TranslationKeys.name),
                  text: activeMember.fullName
              );
              widgets.add(nameCell);

              var dateOfBirthCell = textCell(
                  label: FlutterI18n.translate(context, TranslationKeys.dateOfBirth),
                  text: DateString(activeMember.birthDay).value
              );
              widgets.add(dateOfBirthCell);

              String certificationsAsString = activeMember.certifications.map((e) => e.certificate.name).join(", ");
              if (activeMember.certifications.length > 0) {
                var certificatesCell = textCell(
                    label: FlutterI18n.translate(context, TranslationKeys.certificates),
                    text: certificationsAsString
                );
                widgets.add(certificatesCell);
              }

              var addressCell = textCell(
                  label: FlutterI18n.translate(context, TranslationKeys.address),
                  text: activeMember.addresses.map((e) => e.toString()).join(", ")
              );
              widgets.add(addressCell);

              var phoneNumberCell = textCell(
                  label: FlutterI18n.translate(context, TranslationKeys.phoneNumber),
                  text: activeMember.contactInfo.phoneNumbers.map((e) => e.number).join(", ")
              );
              widgets.add(phoneNumberCell);

              var emailAddressesCell = textCell(
                  label: FlutterI18n.translate(context, TranslationKeys.emailAddress),
                  text: activeMember.contactInfo.emailAddresses.map((e) => e.address).join(", ")
              );
              widgets.add(emailAddressesCell);

              var socialPointCell = cell(
                label: FlutterI18n.translate(context, TranslationKeys.socialPoint),
                child: Container(
                  child: SocialPoint(
                    points: activeMember.socialPoint,
                  ),
                  margin: EdgeInsets.symmetric(
                    vertical: 15
                  ),
                )
              );

              widgets.add(socialPointCell);

              widgets.add(Container(
                margin: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 0,
                  bottom: 40
                ),
                child: ScopedModel(
                  model: this._loadingDelegate,
                  child: ScopedModelDescendant<LoadingDelegate>(
                    builder: (BuildContext context, Widget widget, LoadingDelegate manager) {

                      return PrimaryButton(
                        iconData: FontAwesomeIcons.signOutAlt,
                        text: FlutterI18n.translate(context, TranslationKeys.signOut),
                        color: Colors.red,
                        onPressed: _signOut,
                      );
                    }
                  ),
                ),
              ));

              return widgets;

            }(),
          ),
        ),
      )
    );
  }




}