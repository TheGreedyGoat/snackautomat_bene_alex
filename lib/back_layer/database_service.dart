import 'dart:math';
import 'package:path/path.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin_stack.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack_stack.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/number_pad_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/manual/idle_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/manual/no_selection_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/manual/pay_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/vending_state.dart';
import 'package:sqflite/sqflite.dart';

const snackSlotCount = 24;

/// Singleton to communicate with the database.
///
/// No public constructor -> access via [instance]
class DataBaseService {
  static Database? _db;

  /// The active instance
  static final DataBaseService instance = DataBaseService._();
  static const Map<String, dynamic> _defaultVendingState = {
    _vendingStateIDColumnName: 0,
    _vendingStateTypeColumnName: 'IdleState',
    _vendingStateSelectedSlotColumnName: null,
    _vendingStateCreditColumnName: 0,
    _digit0ColumnName: 0,
    _digit1ColumnName: 0,
    _digit2ColumnName: 0,
  };

  static const _dataBaseName = 'vending_machine.db';

  static const _vendingStateTableName = 'VENDINGSTATES';
  static const _vendingStateIDColumnName = 'vending_id';
  static const _vendingStateTypeColumnName = 'vending_type';
  static const _vendingStateSelectedSlotColumnName = 'vending_slot';
  static const _vendingStateCreditColumnName = 'vending_credit';
  static const _digit0ColumnName = 'digit0';
  static const _digit1ColumnName = 'digit1';
  static const _digit2ColumnName = 'digit2';

  static const _snackStackTableName = 'SNACK_STACKS';
  static const _snackStackIDColumnName = 'stack_id';
  static const _snackStackTypeIndexColumnName = 'snack_index';
  static const _snackStackCountColumnName = 'snack_count';

  static const _coinEntryTableName = 'COIN_ENTRIES';
  static const _coinStackIDColumnName = 'coin_stack_id';
  static const _coinEntryTypeColumnName = 'coin_type';
  static const _coinEntryCountColumnName = 'coin_count';
  DataBaseService._();

  Future<Database> get _database async {
    _db ??= await _getDataBase();
    return _db!;
  }

  /// deletes the whole database
  Future<void> removeDatabase() async {
    final path = join(await getDatabasesPath(), _dataBaseName);
    await deleteDatabase(path);
  }

  Future<Database> _getDataBase() async {
    final databaseDirPath = getDatabasesPath();
    final dataBasePath = join(await databaseDirPath, _dataBaseName);

    final database = await openDatabase(
      dataBasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_vendingStateTableName(
            $_vendingStateIDColumnName INT PRIMARY KEY CHECK($_vendingStateIDColumnName = 0),
            $_vendingStateTypeColumnName TEXT NOT NULL,
            $_vendingStateSelectedSlotColumnName INT,
            $_vendingStateCreditColumnName INT NOT NULL CHECK($_vendingStateCreditColumnName >= 0),
            $_digit0ColumnName INT CHECK($_digit0ColumnName BETWEEN 0 AND 9),
            $_digit1ColumnName INT CHECK($_digit1ColumnName BETWEEN 0 AND 9),
            $_digit2ColumnName INT CHECK($_digit2ColumnName BETWEEN 0 AND 9)
          );
          ''');

        await db.execute('''

          CREATE TABLE $_snackStackTableName(
            $_snackStackIDColumnName INT NOT NULL PRIMARY KEY CHECK($_snackStackIDColumnName >= 0),
            $_snackStackTypeIndexColumnName INT,
            $_snackStackCountColumnName INT NOT NULL CHECK($_snackStackCountColumnName >= 0)
          );
          ''');

        await db.execute('''

          CREATE TABLE $_coinEntryTableName(
            $_coinEntryTypeColumnName INT NOT NULL,
            $_coinStackIDColumnName INT NOT NULL,
            $_coinEntryCountColumnName INT NOT NULL CHECK($_coinEntryCountColumnName >= 0)
          );
          ''');
        await db.insert(_vendingStateTableName, _defaultVendingState);

        for (int i = 0; i < snackSlotCount; i++) {
          await db.insert(_snackStackTableName, {
            _snackStackIDColumnName: i,
            _snackStackTypeIndexColumnName: null,
            _snackStackCountColumnName: 0,
          });
        }

        for (int s = 0; s < 2; s++) {
          for (int c = 0; c < Coin.values.length; c++) {
            await db.insert(_coinEntryTableName, {
              _coinEntryTypeColumnName: c,
              _coinStackIDColumnName: s,
              _coinEntryCountColumnName: 0,
            });
          }
        }
      },
    );
    return database;
  }

  Future<void> showDataBase() async {
    final db = await _database;
    for (final table in [
      _vendingStateTableName,
      _snackStackTableName,
      _coinEntryTableName,
    ]) {
      print('=========================================\n$table:\n');
      final qu = await db.query(table);
      for (final e in qu) {
        print(e);
      }
    }
  }

  //                     dP
  //                     88
  // .d8888b. .d8888b. d8888P
  // 88'  `88 88ooood8   88
  // 88.  .88 88.  ...   88
  // `8888P88 `88888P'   dP
  //      .88
  //  d8888P
  /// loads the currently saved vendingState
  ///

  Future<VendingState> get vendingState async {
    final db = await _database;
    var stateList = await db.query(_vendingStateTableName);
    if (stateList.isEmpty) {
      stateList = [_defaultVendingState];
      await db.insert(_vendingStateTableName, stateList[0]);
    }
    return _createVendingState(stateList[0]);
  }

  VendingState _createVendingState(Map<String, dynamic> json) {
    final int? selectedSlot = json[_vendingStateSelectedSlotColumnName];
    final int credit = json[_vendingStateCreditColumnName] ?? 0;
    final String? type = json[_vendingStateTypeColumnName];
    final numberPadState = NumberPadState(
      digit0: json[_digit0ColumnName] as int?,
      digit1: json[_digit1ColumnName] as int?,
      digit2: json[_digit2ColumnName] as int?,
    );
    switch (type) {
      case 'ErrorState':
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

  /// prints the whole table of all saved SnackStacks
  Future<void> showSnackStacks() async {
    final db = await _database;
    print(await db.query(_snackStackTableName));
  }

  /// Returns a list off all saved SnackStacks
  Future<List<SnackStack>> get snackStacks async {
    final db = await _database;
    final jsonStacks = await db.query(
      _snackStackTableName,
      orderBy: _snackStackIDColumnName,
    );
    List<SnackStack> stacks = List.empty(growable: true);
    for (final json in jsonStacks) {
      final stackID = json[_snackStackIDColumnName];
      final snackIndex = json[_snackStackTypeIndexColumnName];
      final count = json[_snackStackCountColumnName];
      assert(
        (snackIndex is int?) && count != null && count is int,
        '===DATABASE ERROR===\n\nInvalid values or types in snackstack tables:\n snackID: $snackIndex\n count: $count',
      );
      stacks.add(
        SnackStack(
          id: stackID as int,
          snackIndex: snackIndex as int?,
          count: count as int,
        ),
      );
    }
    return stacks.toList();
  }

  /// prints the whole table of all saved CoinStacks
  Future<void> showCoinStacks() async {
    final db = await _database;
    print(await db.query(_coinEntryTableName));
  }

  /// Returns the coinstack with the given [coinStackID] if it exists
  ///
  /// if not entry is found and [createOnMissing] is true, the entry is created with an empty coinstack
  Future<CoinStack?> getCoinStack(int coinStackID) async {
    final db = await _database;

    var stackList = await db.query(
      _coinEntryTableName,
      where: '$_coinStackIDColumnName = ?',
      whereArgs: [coinStackID],
    );

    if (stackList.isEmpty) {
      return null;
    }

    Map<Coin, int> coins = {};
    for (final coin in Coin.values) {
      var query = await db.query(
        _coinEntryTableName,
        where: '$_coinStackIDColumnName = ? AND $_coinEntryTypeColumnName = ?',
        whereArgs: [
          coinStackID,
          coin.index,
        ],
      );
      if (query.isEmpty) {
        continue;
      }
      final count = query[0][_coinEntryCountColumnName];
      if (count is! int) continue;
      coins[coin] = count;
    }
    (coins);
    return CoinStack.withCoins(coins);
  }

  Future<CoinStack> get coinStorage async => (await getCoinStack(0))!;
  set coinStorage(CoinStack newStack) => updateCoinstack(newStack, 0);
  Future<CoinStack> get coinChange async => (await getCoinStack(1))!;
  set coinChange(CoinStack newStack) => updateCoinstack(newStack, 1);

  //                         dP            dP
  //                         88            88
  // dP    dP 88d888b. .d888b88 .d8888b. d8888P .d8888b.
  // 88    88 88'  `88 88'  `88 88'  `88   88   88ooood8
  // 88.  .88 88.  .88 88.  .88 88.  .88   88   88.  ...
  // `88888P' 88Y888P' `88888P8 `88888P8   dP   `88888P'
  //          88
  //          dP

  Future<bool> _checkExist(
    String table,
    String where,
    List<dynamic> whereArgs,
  ) async {
    try {
      final db = await _database;
      return (await db.query(
        table,
        where: where,
        whereArgs: whereArgs,
      )).isNotEmpty;
    } on Exception catch (e) {
      return false;
    }
  }

  /// Sets the count value for the given SNackStack [stackID] to [newCount]
  Future<void> updateSnackStackCount(int stackID, int newCount) async {
    if (!(await _checkExist(
      _snackStackTableName,
      '$_snackStackIDColumnName = ?',
      [stackID.toString()],
    ))) {
      return;
    }

    final db = await _database;
    final map = {_snackStackCountColumnName: max(newCount, 0)};
    int numchanges = await db.update(
      _snackStackTableName,
      map,
      where: '$_snackStackIDColumnName = ?',
      whereArgs: [stackID],
    );
  }

  Future<bool> changeSnackStack(int stackID, int snackIndex, int count) async {
    if (!(await _checkExist(
      _snackStackTableName,
      '$_snackStackIDColumnName = ?',
      [stackID.toString()],
    ))) {
      return false;
    }
    final db = await _database;
    final map = {
      _snackStackTypeIndexColumnName: snackIndex,
      _snackStackCountColumnName: count,
    };
    await db.update(
      _snackStackTableName,
      map,
      where: '$_snackStackIDColumnName = ?',
      whereArgs: [stackID],
    );

    return true;
  }

  /// Save the current vendingState
  Future<void> updateVendingState(VendingState newState) async {
    final db = await _database;
    final numberPadState = newState.numberPadState;
    final map = <String, dynamic>{
      _vendingStateTypeColumnName: newState.runtimeType.toString(),
      _vendingStateSelectedSlotColumnName: newState.selectedSlot,
      _vendingStateCreditColumnName: newState.credit,
      _digit0ColumnName: numberPadState.digit0,
      _digit1ColumnName: numberPadState.digit1,
      _digit2ColumnName: numberPadState.digit2,
    };
    await db.update(
      _vendingStateTableName,
      map,
      where: '$_vendingStateIDColumnName = ?',
      whereArgs: [0],
    );
  }

  /// Overrides the CoinStack with the id [coinStackIndex] to [stack]
  Future<void> updateCoinstack(CoinStack stack, int coinStackIndex) async {
    final db = await _database;
    for (final coin in Coin.values) {
      // print(
      //   'Updating coinstack $index, coin $coin, count: ${stack.getCoinCount(coin)}',
      // );
      await db.update(
        _coinEntryTableName,
        {
          _coinEntryCountColumnName: stack.getCoinCount(coin),
        },
        where: '$_coinStackIDColumnName = ? AND $_coinEntryTypeColumnName = ?',
        whereArgs: [
          coinStackIndex,
          coin.index,
        ],
      );
    }
  }
}
