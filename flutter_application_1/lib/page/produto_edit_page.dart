import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/page/produtos_page.dart';

import '../database/db.dart';
import '../model/Produto.dart';

class ProdutoEditPage extends StatefulWidget {
  int id;
  ProdutoEditPage({Key? key, required this.id}) : super(key: key);

  @override
  _ProdutoEditPageStates createState() => _ProdutoEditPageStates(id: id);
}

class _ProdutoEditPageStates extends State<ProdutoEditPage> {
  final GlobalKey<FormState> _key = GlobalKey();
  int id;
  _ProdutoEditPageStates({required this.id});
  late Produto produto;
  String nome = '';
  num valor = 0;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _getProduto();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Editar Produtos',
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
              initialValue: produto.nome,
              decoration: const InputDecoration(hintText: 'Nome do produto'),
              keyboardType: TextInputType.name,
              onSaved: (val) {
                setState(() {
                  nome = val.toString();
                });
              },
            ),
            TextFormField(
              initialValue: produto.valor.toString(),
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
      produto = Produto(id: id, nome: nome, valor: valor);
      await DB.instance.updateProduto(produto);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const ProdutosPage()));
    }
  }

  void _getProduto() async {
    setState(() {
      isLoading = true;
    });

    produto = await DB.instance.getById(id);

    setState(() {
      isLoading = false;
    });
  }
}
