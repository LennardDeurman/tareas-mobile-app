import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tareas/constants/brand_colors.dart';
import 'package:tareas/constants/icons.dart';
import 'package:tareas/models/activity.dart';
import 'package:tareas/ui/extensions/buttons.dart';
import 'package:tareas/ui/extensions/dates.dart';
import 'package:tareas/ui/extensions/labels.dart';

class ActivityDetailPage extends StatefulWidget {

  final Activity activity;

  ActivityDetailPage (this.activity);

  @override
  State<StatefulWidget> createState() {
    return _ActivityDetailPageState();
  }

}

class _ActivityDetailPageState extends State<ActivityDetailPage> {

  /*



   */

  Widget buildActions() {
    return PrimaryButton(
      color: BrandColors.primaryColor,
      iconData: FontAwesomeIcons.check,
      text: "Accepteren",
      onPressed: () {

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.7),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(child: Stack(
              children: <Widget>[
                Container(child: Image(
                  image: NetworkImage(
                      "https://singularityhub.com/wp-content/uploads/2018/10/abstract-blurred-background-casino_shutterstock_1126650161.jpg" //TODO: Replace!!
                  ),
                  fit: BoxFit.cover,
                ), constraints: BoxConstraints(
                    minHeight: 300
                )),
                Positioned.fill(
                  child: Container(
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 6
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(7)
                            ),
                            child: TextWithIcon(
                              iconData: FontAwesomeIcons.clock,
                              textMargin: EdgeInsets.symmetric(
                                  horizontal: 5
                              ),
                              iconMargin: EdgeInsets.symmetric(
                                  horizontal: 3
                              ),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: widget.activity.isSoon ? BrandColors.errorColor : Colors.black,
                              text: FriendlyDateFormat.format(widget.activity.time),
                            ),
                          )
                        )
                      ],
                    ),
                    margin: EdgeInsets.all(20),
                  ),
                )
              ],
            )),
            Expanded(child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 6
                    ),
                    child: Row(
                      children: <Widget>[
                        FaIcon(
                          TareasIcons.categoryIcons[this.widget.activity.task.category.name],
                          color: BrandColors.iconColor,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          this.widget.activity.name,
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 12
                    ),
                    child: Text(
                      widget.activity.shortDescription,
                      style: TextStyle(
                        fontSize: 16
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 15
                    ),
                    child: Text(
                      widget.activity.description,
                      style: TextStyle(
                          fontSize: 16
                      ),
                    ),
                  ),
                  Spacer(),
                  buildActions()
                ],
              ),
            )),

          ],
        ),
      ),
    );
  }

}