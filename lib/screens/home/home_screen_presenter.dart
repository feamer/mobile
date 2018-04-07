import 'dart:io';

import 'package:mobile/data/rest_ds.dart';

abstract class HomeScreenContract {
  onUploadSuccess(String uuid);
  onUploadFailure(String error);
}

class HomeScreenPresenter {
  HomeScreenContract _view;
  var api = new RestDatasource();

  HomeScreenPresenter(this._view);

  doUpload(File file) {
    api.upload(file).then((uuid) {
      _view.onUploadSuccess(uuid);
    }).catchError((Exception error) => _view.onUploadFailure(error.toString()));
  }
}