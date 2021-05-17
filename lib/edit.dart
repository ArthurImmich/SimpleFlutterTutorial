import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/contact.dart';

import 'database.dart';
import 'image_assist.dart';

class Edit extends StatefulWidget {
  final Contact contato;
  Edit(this.contato);
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _instagramController = TextEditingController();
  final _facebookController = TextEditingController();
  final _linkedinController = TextEditingController();
  File? _fileImage;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.contato.name!;
    _emailController.text = widget.contato.email ?? '';
    _phoneController.text = widget.contato.phone ?? '';
    _instagramController.text = widget.contato.instagram ?? '';
    _facebookController.text = widget.contato.facebook ?? '';
    _linkedinController.text = widget.contato.linkedin ?? '';
    _fileImage =
        widget.contato.image != null ? File(widget.contato.image!) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _fileImage != null
                          ? CircleAvatar(
                              radius: 30,
                              backgroundImage: FileImage(_fileImage!),
                            )
                          : CircleAvatar(
                              radius: 30,
                              child: Icon(Icons.person, color: Colors.black),
                              backgroundColor: Colors.amber),
                      ElevatedButton(
                        onPressed: () => ImageAssist()
                            .pickFile()
                            .then((file) => setState(() => _fileImage = file)),
                        child: Text('Selecionar Imagem'),
                      ),
                    ],
                  ),
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  //the post fix exclamation mark is a 'casting away nullability'
                  //meaning that it will take the value of null and cast it to a string
                  //and then check if it is empty avoiding calling .isEmpty on null
                  validator: (value) =>
                      value!.isEmpty ? 'Campo Obrigatório' : null,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Telefone'),
                ),
                TextFormField(
                  controller: _instagramController,
                  decoration: const InputDecoration(labelText: 'Instagram'),
                ),
                TextFormField(
                  controller: _facebookController,
                  decoration: const InputDecoration(labelText: 'Facebook'),
                ),
                TextFormField(
                  controller: _linkedinController,
                  decoration: const InputDecoration(labelText: 'LinkedIn'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints.tightFor(width: 140, height: 35),
                      child: ElevatedButton(
                          onPressed: () async {
                            // The FormState class contains the validate() method. When the validate()
                            //  method is called, it runs the validator() function for each text field
                            //  in the form. If everything looks good, the validate() method returns true.
                            //  If any text field contains errors, the validate() method rebuilds the
                            //  form to display any error messages and returns false.
                            if (_formKey.currentState!.validate()) {
                              try {
                                widget.contato.name = _nameController.text;
                                widget.contato.email = _emailController.text;
                                widget.contato.phone = _phoneController.text;
                                widget.contato.instagram =
                                    _instagramController.text;
                                widget.contato.facebook =
                                    _facebookController.text;
                                widget.contato.linkedin =
                                    _linkedinController.text;
                                if (_fileImage != null) {
                                  if (widget.contato.image != _fileImage!.path)
                                    File(widget.contato.image!).delete();
                                  ImageAssist().saveImage(_fileImage!).then(
                                      (path) => widget.contato.image = path);
                                }
                                DatabaseConnection().update(widget.contato);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Editado!')));
                                Navigator.of(context).pop();
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Erro ao editar!')));
                              }
                            }
                          },
                          child: Text('Editar')),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
