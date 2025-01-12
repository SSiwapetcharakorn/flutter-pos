import 'package:flutter/foundation.dart';

/// Represents a storage engine, like "localstorage", "sqlite", or "aws-s3"...
typedef DatabaseConnectionInterface = Control;

/// Readable & Insertable
// abstract class RIRepository<T> = Readable<T> with Insertable<T>;
// abstract class RIDRepository<T> = RIRepository<T> with Deletable<T>;
// abstract class RIUDRepository<T> = RIDRepository<T> with Updatable<T>;

abstract class RIRepository<T> implements Readable<T>, Insertable<T> {
  // ... implement your read and write methods using the Readable and Writable classes
}

abstract class RIDRepository<T> implements RIRepository<T>, Deletable<T> {
  // ... implement your read, write, and delete methods
}

abstract class RIUDRepository<T> implements RIDRepository<T>, Updatable<T> {
  // ... implement your read, write, delete, and update methods
}

/// Operations on a more generic/global level
class Control {
  Future<dynamic> open() => Future.value();

  Future<void> close() => Future.value();

  /// Removes all items from database, should be wrapped in try/catch block
  Future<void> destroy() => Future.value();

  @visibleForTesting
  Future<void> truncate() => Future.value();
}

typedef QueryKey<C> = Comparable<C>;

abstract class Readable<T> {
  Future<List<T>> get([QueryKey? from, QueryKey? to]);
}

abstract class Insertable<T> {
  Future<T> insert(T value);
}

abstract class Deletable<T> {
  Future<void> delete(T value);
}

abstract class Updatable<T> {
  Future<void> update(T value);
  Future<void> upsert(T value) => throw UnimplementedError();
}
