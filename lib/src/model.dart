library model.model;

import 'dart:async';
import 'package:model/src/params.dart';
import 'package:model/src/request.dart';
import 'package:model/src/storage.dart';
import 'package:model/src/map_dirty.dart';

abstract class Model {
  MapDirty attributes;
  Future<Model> _loadFuture;
  Storage _storage;
  bool isLoaded = false;
  bool isLoading = false;
  bool isAutosaveEnabled = false;
  bool get isNewRecord => id == null;
  int get id => attributes["id"] == null ? null : int.parse(attributes["id"].toString());
  Timer autosaveTimer;

  Model(Storage storage, [Params params]) {
    this._storage = storage;
    if (params != null) {
      attributes = new MapDirty.from(params);
    }
    if (_isParamsForLoaded(params)) {
      isLoaded = true;
      _loadFuture = new Future<bool>(() => true);
    } else {
      isLoaded = false;
    };
  }

  Future<bool> load() {
    if (!isLoaded && !isLoading) {
      isLoading = true;
      _loadFuture = _storage.find(attributes["id"]).then((params) {
        attributes.addAll(params);
        isLoaded = true;
        isLoading = false;
        return true;
      });
    }
    return _loadFuture;
  }

  Future<bool> save() {
    return _storage.save(this).then((params) {
      attributes = new MapDirty.from(params);
      return params["errors"] == null || params["errors"].isEmpty;
    });
  }

  Future<bool> delete() {
    return _storage.delete(this).then((params) {
      return params["errors"] == null || params["errors"].isEmpty;
    });
  }

  void startAutosave(Duration duration) {
    if (!isAutosaveEnabled) {
      isAutosaveEnabled = true;
      _autosave(duration);
    }
  }

  void stopAutosave() {
    isAutosaveEnabled = false;
    if (autosaveTimer != null) {
      autosaveTimer.cancel();
      autosaveTimer = null;
    }
  }

  Params toParams([String type]) {
    if (type == "update") {
      return {"id": attributes["id"]}..addAll(attributes.summaryChanges);
    } else {
      return new Map.from(attributes);
    }
  }

  void _isParamsForLoaded(Params params) {
    return !(params.length == 1 && params.keys.toList()[0] == "id");
  }

  void _autosave(Duration duration) {
    if (isAutosaveEnabled) {
      autosaveTimer = new Timer(duration, () {
        save().then(() => _autosave(duration));
      });
    }
  }
}
