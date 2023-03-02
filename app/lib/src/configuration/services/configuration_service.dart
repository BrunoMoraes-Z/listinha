import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:listinha/src/shared/services/realm/models/configuration_model.dart';
import 'package:listinha/src/shared/stores/app_store.dart';
import 'package:realm/realm.dart';
import 'package:rx_notifier/rx_notifier.dart';

abstract class ConfigurationService {
  void init();
  void deleteAll();
}

class ConfigurationServiceImpl implements ConfigurationService, Disposable {
  final Realm realm;
  final AppStore store;
  late final RxDisposer disposer;
  ConfigurationServiceImpl(this.realm, this.store);

  @override
  void init() {
    final model = _getConfiguration();
    store
      ..themeMode = _getThemeModeByName(model.themeModeName)
      ..syncDate = model.syncDate;

    disposer = rxObserver(() {
      final themeMode = store.themeMode;
      final syncDate = store.syncDate;

      _saveConfiguration(themeMode.name, syncDate);
    });
  }

  @override
  void dispose() {
    disposer();
  }

  @override
  void deleteAll() {
    realm.deleteAll();
  }

  ConfigurationModel _getConfiguration() {
    return realm.all<ConfigurationModel>().first;
  }

  void _saveConfiguration(String themeModeName, DateTime? syncDate) {
    final model = _getConfiguration();
    realm.write(() {
      model
        ..themeModeName = themeModeName
        ..syncDate = syncDate;
    });
  }

  ThemeMode _getThemeModeByName(String name) {
    return ThemeMode.values.firstWhere((mode) => mode.name == name);
  }
}
