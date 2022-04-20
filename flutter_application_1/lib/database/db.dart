import 'dart:convert';

import 'package:flutter_application_1/model/Produto.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  DB._();

  static final DB instance = DB._();

  static Database? _database;

  get database async {
    if (_database != null) return _database;
    return await _initDatabase();
  }

  close() async {
    final db = await instance.database;
    db.close();
  }

  _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = '${dbPath}loja.db';
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  _onCreate(db, version) async {
    await db.execute(_produto);
  }

  String get _produto => '''
  create table $tableProdutos (
    ${ProdutoFields.id} integer primary key autoincrement,
    ${ProdutoFields.nome} text,
    ${ProdutoFields.valor} real
  );
  ''';

  Future<List<Produto>> getAllProdutos() async {
    final db = await instance.database;
    List<Map<String, Object?>> produtos = await db.query(tableProdutos);
    return produtos.map((json) => Produto.fromJson(json)).toList();
  }

  Future<Produto> getById(int id) async {
    final db = await instance.database;
    List<Map<String, Object?>> produtos = await db.query(tableProdutos,
        where: '${ProdutoFields.id} = ?', whereArgs: [id]);
    return produtos.map((json) => Produto.fromJson(json)).toList().first;
  }

  insertProduto(Produto produto) async {
    final db = await instance.database;
    await db.insert(tableProdutos,
        {ProdutoFields.nome: produto.nome, ProdutoFields.valor: produto.valor});
  }

  deleteProduto(int id) async {
    final db = await instance.database;
    db.delete(tableProdutos, where: '${ProdutoFields.id} = ?', whereArgs: [id]);
  }

  updateProduto(Produto produto) async {
    final db = await instance.database;
    db.update(tableProdutos, produto.toJson(),
        where: '${ProdutoFields.id} = ?', whereArgs: [produto.id]);
  }
}
