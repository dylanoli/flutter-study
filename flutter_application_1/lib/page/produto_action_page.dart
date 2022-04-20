import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/page/produtos_page.dart';

import '../database/db.dart';
import '../model/Produto.dart';

class ProdutoActionPage extends StatefulWidget {
  const ProdutoActionPage({Key? key}) : super(key: key);

  @override
  _ProdutoActionPageStates createState() => _ProdutoActionPageStates();
}

class _ProdutoActionPageStates extends State<ProdutoActionPage> {
  GlobalKey<FormState> _key = GlobalKey();
  late Produto produto;
  String nome = '';
  num valor = 0;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Adicionar Produtos',
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: Center(
          child: isLoading ? const CircularProgressIndicator() : buildForm()),
    );
  }

  Widget buildForm() {
    return Form(
        key: _key,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            TextFormField(
              decoration: const InputDecoration(hintText: 'Nome do produto'),
              keyboardType: TextInputType.name,
              onSaved: (val) {
                setState(() {
                  nome = val.toString();
                });
              },
            ),
            TextFormField(
              decoration: const InputDecoration(hintText: 'Preço do produto'),
              keyboardType: TextInputType.number,
              onSaved: (val) {
                setState(() {
                  valor = num.parse(val.toString());
                });
              },
            ),
            ElevatedButton(
              onPressed: _saveProduto,
              child: const Text('Salvar'),
            )
          ]),
        ));
  }

  _saveProduto() async {
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      produto = Produto(id: 0, nome: nome, valor: valor);
      await DB.instance.insertProduto(produto);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const ProdutosPage()));
    }
  }
}
