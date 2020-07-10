import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:tareas/constants/translation_keys.dart';
import 'package:tareas/models/abstract.dart';

class FetcherList<T extends ParsableObject> extends StatefulWidget {

  final Future Function() downloadFutureBuilder;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function(BuildContext context) loadingBackgroundBuilder;
  final Function(BuildContext context) noResultsBackgroundBuilder;
  final Function(BuildContext context) errorBackgroundBuilder;
  final Function itemBuilder;

  FetcherList ({
    @required this.downloadFutureBuilder,
    @required this.scaffoldKey,
    @required this.loadingBackgroundBuilder,
    @required this.errorBackgroundBuilder,
    @required this.noResultsBackgroundBuilder,
    @required this.itemBuilder
  });

  @override
  State<StatefulWidget> createState() {
    return FetcherListState<T>();
  }

}


class DownloadState<T extends ParsableObject> {

  List<T> objects = [];

  bool hasError;

  bool isLoading;

  bool get isEmpty {
    if (objects == null) {
      return true;
    }
    return objects.length == 0;
  }

  int get objectsCount {
    return isEmpty ? 0 : objects.length;
  }

  DownloadState ({ this.hasError = false, this.isLoading = false, this.objects });

  factory DownloadState.error() {
    return DownloadState(hasError: true);
  }

  factory DownloadState.loading() {
    return DownloadState(isLoading: true);
  }


}

class FetcherListState<T extends ParsableObject> extends State<FetcherList> {

  DownloadState<T> _downloadState = DownloadState.loading();

  set downloadState (DownloadState<T> downloadState) {
    setState(() {
      this._downloadState = downloadState;
    });
  }

  DownloadState<T> get downloadState {
    return _downloadState;
  }

  Future refreshData() async {
    return await widget.downloadFutureBuilder().then((value) {
      downloadState = DownloadState<T>(objects: value);
    }).catchError((e) {
      if (!downloadState.isEmpty) {
        this.widget.scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(
              FlutterI18n.translate(context, TranslationKeys.couldNotRefresh)
            ),
          )
        );
      } else {
        downloadState = DownloadState<T>.error();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshData,
      child: Stack(
        children: [
          () {
            if (downloadState.isLoading) {
              return widget.loadingBackgroundBuilder(context);
            } else if (downloadState.hasError) {
              return widget.errorBackgroundBuilder(context);
            } else if (downloadState.isEmpty) {
              return widget.noResultsBackgroundBuilder(context);
            }
            return Container();
          }(),
          ListView.builder(itemBuilder: (BuildContext context, int position) {
            var obj = downloadState.objects[position];
            return widget.itemBuilder(context, obj);
          }, itemCount: downloadState.objectsCount)
        ],
      ),
    );
  }

}