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

class DataBaseService {
  static Database? _db;
  static final DataBaseService instance = DataBaseService._();

  static const _dataBaseName = 'vending_machine.db';

  static const _vendingStateTableName = 'VENDINGSTATES';
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
  static const _snackStackTableName = 'SNACK_STACKS';
  static const _snackStackIDColumnName = 'snack_id';
  static const _snackStackCountColumnName = 'snack_count';
  static const _coinEntryTableName = 'COIN_ENTRIES';
  static const _coinStackIDColumnName = 'coin_stack_id';
  static const _coinEntryTypeColumnName = 'coin_type';
  static const _coinEntryCountColumnName = 'coin_count';
  DataBaseService._();

  Future<Database> get database async {
    _db ??= await getDataBase();
    // await deleteDatabase(_db!.path);

    // _db = await getDataBase();
    return _db!;
  }

  Future<void> deletDatabase() async {
    await deleteDatabase((await database).path);
  }

  Future<Database> getDataBase() async {
    final databaseDirPath = getDatabasesPath();
    final dataBasePath = join(await databaseDirPath, _dataBaseName);

    final dataBase = await openDatabase(
      dataBasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_vendingStateTableName(
            $_vendingStateIDColumnName INT PRIMARY KEY CHECK($_vendingStateIDColumnName = 0),
            $_vendingStateTypeColumnName TEXT NOT NULL,
            $_vendingStateSelectedSlotColumnName INT,
            $_vendingStateCreditColumnName INT NOT NULL CHECK($_vendingStateCreditColumnName >= 0)
          );
          ''');

        await db.execute('''

          CREATE TABLE $_snackStackTableName(
            $_snackStackIDColumnName INT PRIMARY KEY,
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
      },
    );

    return dataBase;
  }

  //                     dP
  //                     88
  // .d8888b. .d8888b. d8888P
  // 88'  `88 88ooood8   88
  // 88.  .88 88.  ...   88
  // `8888P88 `88888P'   dP
  //      .88
  //  d8888P
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
    final int? selectedSlot = json[_vendingStateSelectedSlotColumnName];
    final int credit = json[_vendingStateCreditColumnName] ?? 0;
    final String? type = json[_vendingStateTypeColumnName];
    final numberPadState = NumberPadState.init();
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

  Future<void> showSnackStacks() async {
    final db = await database;
    print(await db.query(_snackStackTableName));
  }

  Future<List<SnackStack>> getSnackStacks() async {
    final db = await database;
    final jsonStacks = await db.query(_snackStackTableName);
    List<SnackStack> stacks = List.empty(growable: true);
    for (final json in jsonStacks) {
      final snackID = json[_snackStackIDColumnName];
      final count = json[_snackStackCountColumnName];
      assert(
        snackID != null && snackID is int && count != null && count is int,
        '===DATABASE ERROR===\n\nInvalid values or types in snackstack tables:\n snackID: $snackID\n count: $count',
      );
      stacks.add(SnackStack(snackID: snackID as int, count: count as int));
    }
    return stacks.toList(growable: false);
  }

  Future<void> showCoinStacks() async {
    final db = await database;
    print(await db.query(_coinEntryTableName));
  }

  Future<CoinStack> getCoinStack(int coinStackID, bool createOnMissing) async {
    final db = await database;

    var stackList = await db.query(
      _coinEntryTableName,
      where: '$_coinStackIDColumnName = ?',
      whereArgs: [coinStackID],
    );

    if (stackList.isEmpty && createOnMissing) {
      stackList = await insertCoinStack(coinStackID, CoinStack.empty());
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

  Future<List<Map<String, Object?>>> insertCoinStack(
    int id,
    CoinStack coinstack,
  ) async {
    final db = await database;
    List<Map<String, Object?>> inserted = List.empty(growable: true);
    for (final coin in Coin.values) {
      final map = {
        _coinStackIDColumnName: id,
        _coinEntryTypeColumnName: coin.index,
        _coinEntryCountColumnName: coinstack.getCoinCount(coin),
      };
      await db.insert(_coinEntryTableName, map);
      inserted.add(map);
      coinstack.getCoinCount(coin);
    }
    return inserted;
  }

  // oo                                       dP
  //                                          88
  // dP 88d888b. .d8888b. .d8888b. 88d888b. d8888P
  // 88 88'  `88 Y8ooooo. 88ooood8 88'  `88   88
  // 88 88    88       88 88.  ... 88         88
  // dP dP    dP `88888P' `88888P' dP         dP
  Future<void> insertSnackStack(SnackStack stack) async {
    final db = await database;
    db.insert(_snackStackTableName, {
      _snackStackIDColumnName: stack.snackID,
      _snackStackCountColumnName: stack.count,
    });
  }

  //                         dP            dP
  //                         88            88
  // dP    dP 88d888b. .d888b88 .d8888b. d8888P .d8888b.
  // 88    88 88'  `88 88'  `88 88'  `88   88   88ooood8
  // 88.  .88 88.  .88 88.  .88 88.  .88   88   88.  ...
  // `88888P' 88Y888P' `88888P8 `88888P8   dP   `88888P'
  //          88
  //          dP
  Future<void> updateSnackStack(int stackID, int newCount) async {
    final db = await database;
    final map = {_snackStackCountColumnName: max(newCount, 0)};
    await db.update(
      _snackStackTableName,
      map,
      where: '$_snackStackIDColumnName = ?',
      whereArgs: [stackID],
    );
  }

  Future<void> updateVendingState(VendingState newState) async {
    final db = await database;
    final map = <String, dynamic>{
      _vendingStateTypeColumnName: newState.runtimeType.toString(),
      _vendingStateSelectedSlotColumnName: newState.selectedSlot,
      _vendingStateCreditColumnName: newState.credit,
    };
    await db.update(
      _vendingStateTableName,
      map,
      where: '$_vendingStateIDColumnName = ?',
      whereArgs: [0],
    );
  }

  Future<void> updateCoinstack(CoinStack stack, int coinStackIndex) async {
    final db = await database;
    for (final coin in Coin.values) {
      // print(
      //   'Updating coinstack $index, coin $coin, count: ${stack.getCoinCount(coin)}',
      // );
      print(
        await db.update(
          _coinEntryTableName,
          {
            _coinEntryCountColumnName: stack.getCoinCount(coin),
          },
          where:
              '$_coinStackIDColumnName = ? AND $_coinEntryTypeColumnName = ?',
          whereArgs: [
            coinStackIndex,
            coin.index,
          ],
        ),
      );
    }
  }
}
