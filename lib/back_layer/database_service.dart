import 'package:path/path.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin_stack.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/number_pad_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/automatic/dispense_snack_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/automatic/return_coins_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/manual/idle_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/manual/no_selection_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/manual/pay_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/vending_state.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseService {
  static Database? _db;
  static final DataBaseService instance = DataBaseService._();

  static const _dataBaseName = 'vending_machine.db';

  static const _vendingStateTableName = 'vending_state';
  static const _vendingStateIDColumnName = 'vending_id';
  static const _vendingStateTypeColumnName = 'vending_type';
  static const _vendingStateSelectedSlotColumnName = 'vending_slot';
  static const _vendingStateCreditColumnName = 'vending_credit';
  static const Map<String, dynamic> _defaultVendingState = {
    _vendingStateIDColumnName: 0,
    _vendingStateTypeColumnName: 'IdleState',
    _vendingStateSelectedSlotColumnName: null,
    _vendingStateCreditColumnName: 0,
  };
  static const _snackStackTableName = 'snack_stacks';
  static const _snackStackIDColumnName = 'snack_id';
  static const _snackStackCountColumnName = 'snack_count';
  static const _coinEntryTableName = 'coin_entries';
  static const _coinStackIDColumnName = 'coin_stack_id';
  static const _coinsEntryIDColumnName = 'coin_entry_id';
  static const _coinEntryTypeColumnName = '_coin_type';
  static const _coinEntryCountColumnName = '_coin_count';
  DataBaseService._();

  Future<Database> get database async {
    _db = _db ?? await getDataBase();
    return _db!;
  }

  Future<Database> getDataBase() async {
    final databaseDirPath = await getDatabasesPath();
    final dataBasePath = join(databaseDirPath, _dataBaseName);

    final dataBase = await openDatabase(
      dataBasePath,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_vendingStateTableName(
            $_vendingStateIDColumnName INT PRIMARY KEY CHECK($_vendingStateIDColumnName = 0),
            $_vendingStateTypeColumnName TEXT NOT NULL,
            $_vendingStateSelectedSlotColumnName INT REFERENCES ,
            $_vendingStateCreditColumnName INT NOT NULL CHECK($_vendingStateCreditColumnName >= 0),
          );
          ''');

        await db.execute('''

          CREATE TABLE $_snackStackTableName(
            $_vendingStateIDColumnName INT PRIMARY KEY
            $_snackStackCountColumnName INT NOT NULL CHECK($_snackStackCountColumnName >= 0)

          );
          ''');

        await db.execute('''

          CREATE TABLE $_coinEntryTableName(
            $_coinsEntryIDColumnName INT PRIMARY KEY,
            $_coinStackIDColumnName
            $_coinEntryTypeColumnName INT NOT NULL,
            $_coinEntryCountColumnName INT NOT NULL CHECK($_coinEntryCountColumnName >= 0)
          );
          ''');
      },
    );

    return dataBase;
  }

  Future<VendingState> get vendingState async {
    final db = await database;
    var stateList = await db.query(_vendingStateTableName);
    if (stateList.isEmpty) {
      stateList = [_defaultVendingState];
      await db.insert(_vendingStateTableName, stateList[0]);
    }
    return _createVendingState(stateList[0]);
  }

  VendingState _createVendingState(Map<String, dynamic> json) {
    final int? selectedSlot = json[_snackStackIDColumnName];
    final int credit = json[_vendingStateSelectedSlotColumnName];
    final String? type = json[_vendingStateTypeColumnName];
    final numberPadState = NumberPadState.init();
    switch (type) {
      case 'IdleState':
        return IdleState(numberPadState: numberPadState);
      case 'NoSelectionState':
      case 'ReturnCoinsState':
        return NoSelectionState(credit: credit, numberPadState: numberPadState);
      case 'PayState':
      case 'DispenseSnackState':
        return PayState(
          credit: credit,
          selectedSlot: selectedSlot,
          numberPadState: numberPadState,
        );
      default:
        throw ('VendingState type = null or invalid type name: $type');
    }
  }

  Future<CoinStack?> getCoinStack(int id) async {
    final db = await database;
    Map<Coin, int> coins = {};
    for (final coin in Coin.values) {
      var query = await db.query(
        _coinEntryTableName,
        where: '$_coinStackIDColumnName = ? AND $_coinEntryTypeColumnName = ?',
        whereArgs: [
          id,
          coin.name,
        ],
      );
      if (query.isEmpty) continue;
      final count = query[0][coin.name];
      if (count! is int) continue;
      coins[coin] = count as int;
    }
    return CoinStack.withCoins(coins);
  }
}
