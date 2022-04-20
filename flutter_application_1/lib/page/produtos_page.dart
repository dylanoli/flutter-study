import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/db.dart';
import 'package:flutter_application_1/model/Produto.dart';
import 'package:flutter_application_1/page/produto_action_page.dart';
import 'package:flutter_application_1/page/produto_edit_page.dart';

class ProdutosPage extends StatefulWidget {
  const ProdutosPage({Key? key}) : super(key: key);

  @override
  _ProdutosPageStates createState() => _ProdutosPageStates();
}

class _ProdutosPageStates extends State<ProdutosPage> {
  late List<Produto> produtos;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    refreshProdutos();
  }

  refreshProdutos() async {
    setState(() {
      isLoading = true;
    });

    produtos = await DB.instance.getAllProdutos();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Produtos',
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: Center(
          child:
              isLoading ? const CircularProgressIndicator() : buildProdutos()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const ProdutoActionPage()));
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  DataTable buildProdutos() {
    const columns = <DataColumn>[
      DataColumn(
        label: Text(
          'Produto',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      DataColumn(
        label: Text(
          'Preço',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      DataColumn(
        label: Text(
          'Ação',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
    ];

    List<DataRow> rows = produtos
        .map((el) => DataRow(cells: <DataCell>[
              DataCell(Text(el.nome)),
              DataCell(Text('R\$${el.valor}')),
              DataCell(Row(
                children: [
                  IconButton(
                    onPressed: () {
                      _edit(el.id);
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      _delete(el.id);
                    },
                    icon: const Icon(Icons.delete),
                  )
                ],
              ))
            ]))
        .toList();
    return DataTable(columns: columns, rows: rows);
  }

  _delete(int id) async {
    await DB.instance.deleteProduto(id);
    refreshProdutos();
  }

  _edit(int id) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ProdutoEditPage(
                  id: id,
                )));
  }
}
