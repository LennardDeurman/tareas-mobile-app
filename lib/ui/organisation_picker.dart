import 'package:flutter/material.dart';
import 'package:tareas/models/member.dart';
import 'package:tareas/network/auth/service.dart';
class OrganisationPicker {

  final Function(Member) onPressed;

  OrganisationPicker ({ @required this.onPressed });

  void show(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ListView.builder(
            itemCount: AuthService().identityResult.account.members.length,
            itemBuilder: (BuildContext context, int position) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    onPressed(AuthService().identityResult.account.members[position]);
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.black12
                            )
                        )
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            AuthService().identityResult.account.members[position].organisation.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 10
                          ),
                          child: Visibility(
                              child: Icon(Icons.check),
                              visible: AuthService().identityResult.activeMember.id == AuthService().identityResult.account.members[position].id
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
    );
  }

}