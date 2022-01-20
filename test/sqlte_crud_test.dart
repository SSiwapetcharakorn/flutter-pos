import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:posapp/provider/src.dart';
import 'package:posapp/storage_engines/sqlite.dart';

void main() {
  SQLite sqlite = SQLite('test');
  final checkOutTime = DateTime(2017, 9, 7, 17, 30);
  final checkOutTime2 = DateTime(2017, 9, 7, 19, 30);
  late Order order;
  late Order order2;

  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized(); // must have this line for sqlite to work
    expect(await sqlite.open(), true);
  });

  tearDownAll(() async {
    await sqlite.destroy();
    await sqlite.close();
  });

  order = Order.create(
    tableID: 0,
    checkoutTime: checkOutTime,
    lineItems: LineItemList([
      LineItem(
        associatedDish: Dish(0, 'Test Dish 0', 5000),
        quantity: 1,
      ),
      LineItem(
        associatedDish: Dish(1, 'Test Dish 1', 6000),
        quantity: 2,
      ),
    ]),
  );

  order2 = Order.create(
    tableID: 0,
    checkoutTime: checkOutTime2,
    lineItems: LineItemList([
      LineItem(
        associatedDish: Dish(3, 'Test Dish 3', 5000),
        quantity: 1,
      ),
      LineItem(
        associatedDish: Dish(4, 'Test Dish 4', 6000),
        quantity: 2,
      ),
    ]),
  );

  group('Insert', () {
    setUp(() async {
      await sqlite.truncateTables();
    });

    test('Should insert a row', () async {
      await sqlite.insert(order);

      final result = (await sqlite.get(checkOutTime));
      expect(result, isNotEmpty);
      expect(result.length, 1);
      expect(result[0].toJson(), {...order.toJson(), 'orderID': 1});
    });

    test('Should insert 2 rows', () async {
      await sqlite.insert(order);
      await sqlite.insert(order2);

      final result = (await sqlite.get(checkOutTime));
      expect(result, isNotEmpty);
      expect(result.length, 2);
      expect(result[0].toJson(), {...order.toJson(), 'orderID': 1});
      expect(result[1].toJson(), {...order2.toJson(), 'orderID': 2});
    });
  });

  group('Delete', () {
    setUp(() async {
      await sqlite.truncateTables();
    });

    test('Should soft-delete a row', () async {
      await sqlite.insert(order);
      expect(await sqlite.delete(checkOutTime, 1), 1);

      final result = (await sqlite.get(checkOutTime));
      expect(result.length, 1);
      expect(result[0].toJson(), {...order.toJson(), 'orderID': 1, 'isDeleted': true});
    });
  });
}
