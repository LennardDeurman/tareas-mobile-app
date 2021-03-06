import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:tareas/constants/brand_colors.dart';
import 'package:tareas/constants/asset_paths.dart';
import 'package:tareas/constants/translation_keys.dart';
import 'package:tareas/logic/delegates/loading.dart';
import 'package:tareas/logic/delegates/notification_center.dart';
import 'package:tareas/models/member.dart';
import 'package:tareas/network/auth/service.dart';
import 'package:tareas/ui/extensions/buttons.dart';
import 'package:tareas/ui/extensions/headers.dart';
import 'package:tareas/ui/extensions/dates.dart';
import 'package:tareas/ui/extensions/presentation.dart';
import 'package:tareas/ui/organisation_picker.dart';




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

class _ProfilePageState extends State<ProfilePage> with ProfilePageUI, AutomaticKeepAliveClientMixin {

  LoadingDelegate _loadingDelegate = LoadingDelegate();
  LogoutPresenter _logoutPresenter;

  @override
  void initState() {
    super.initState();

    _logoutPresenter = LogoutPresenter(
      context
    );
    _logoutPresenter.register();

  }

  void _signOut() {
    Future future = AuthService().logout();
    _loadingDelegate.attachFuture(future);
  }

  void _showOrganizationsPickers() {
    OrganisationPicker(
      onPressed: (Member member) {
        AuthService().identityResult.setPreferredMember(
          member.id,
          shouldSave: true
        );
        MemberChangeNotificationCenter().sendNotification(member);

        setState(() {});
      }
    ).show(context);
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
              if (AuthService().identityResult != null) {
                var activeMember = AuthService().identityResult.activeMember;

                var nameCell = textCell(
                    label: FlutterI18n.translate(context, TranslationKeys.name),
                    text: activeMember.fullName
                );
                widgets.add(nameCell);

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

                widgets.add(
                    cell(
                      label: FlutterI18n.translate(context, TranslationKeys.organisation),
                      child: Container(
                        child: GestureDetector(
                          child: Text(activeMember.organisation.name,
                              style: TextStyle(
                                  fontSize: 16,
                                  decoration: TextDecoration.underline
                              )
                          ),
                          onTap: () {
                            if (AuthService().identityResult.account.members.length > 1) {
                              _showOrganizationsPickers();
                            }
                          },
                        ),
                        margin: EdgeInsets.symmetric(
                            vertical: 8
                        ),
                      ),
                    )
                );
              }



              widgets.add(Container(
                margin: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 0,
                  bottom: 40
                ),
                child: ValueListenableBuilder(
                  valueListenable: _loadingDelegate.notifier,
                  builder: (BuildContext context, bool value, Widget widget) {
                    return PrimaryButton(
                      iconData: IconAssetPaths.signOutAlt,
                      text: FlutterI18n.translate(context, TranslationKeys.signOut),
                      color: Colors.red,
                      onPressed: _signOut,
                    );
                  },
                )
              ));

              return widgets;

            }(),
          ),
        ),
      )
    );
  }

  @override
  void dispose() {
    super.dispose();
    _logoutPresenter.unregister();
  }

  @override
  bool get wantKeepAlive => true;



}