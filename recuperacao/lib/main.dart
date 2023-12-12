import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PatientForm(),
    );
  }
}

class PatientForm extends StatefulWidget {
  @override
  _PatientFormState createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController leukocytesController = TextEditingController();
  final TextEditingController glucoseController = TextEditingController();
  final TextEditingController astController = TextEditingController();
  final TextEditingController ldhController = TextEditingController();
  bool hasBiliaryLithiasis = false;
  double score = 0.0;
  String mortalityCategory = "Baixa";

  void calculateMortality() {
    int ageThreshold = hasBiliaryLithiasis ? 70 : 55;
    int leukocytesThreshold = hasBiliaryLithiasis ? 18000 : 16000;
    double glucoseThreshold = hasBiliaryLithiasis ? 12.2 : 11.0;
    int astThreshold = 250;
    int ldhThreshold = hasBiliaryLithiasis ? 400 : 350;

    int age = int.tryParse(ageController.text) ?? 0;
    int leukocytes = int.tryParse(leukocytesController.text) ?? 0;
    double glucose = double.tryParse(glucoseController.text) ?? 0.0;
    int ast = int.tryParse(astController.text) ?? 0;
    int ldh = int.tryParse(ldhController.text) ?? 0;

    // Lógica para calcular o escore de mortalidade aqui
    int patientScore = 0;

    if (age > ageThreshold) patientScore++;
    if (leukocytes > leukocytesThreshold) patientScore++;
    if (glucose > glucoseThreshold) patientScore++;
    if (ast > astThreshold) patientScore++;
    if (ldh > ldhThreshold) patientScore++;

    score = patientScore.toDouble();

    // Lógica para determinar a categoria de mortalidade aqui
    if (score >= 7) {
      mortalityCategory = "100%";
    } else if (score >= 5) {
      mortalityCategory = "40%";
    } else if (score >= 3) {
      mortalityCategory = "15%";
    } else {
      mortalityCategory = "2%";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Novo paciente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o nome do paciente.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: ageController,
                decoration: InputDecoration(labelText: 'Idade'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira a idade do paciente.';
                  }
                  return null;
                },
              ),
              CheckboxListTile(
                title: Text('Litíase Biliar?'),
                value: hasBiliaryLithiasis,
                onChanged: (value) {
                  setState(() {
                    hasBiliaryLithiasis = value!;
                  });
                },
              ),
              TextFormField(
                controller: leukocytesController,
                decoration: InputDecoration(
                  labelText: 'Leucócitos',
                  suffixText: 'cél./mm3',
                ),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: glucoseController,
                decoration: InputDecoration(
                  labelText: 'Glicemia',
                  suffixText: 'mmol/L',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              TextFormField(
                controller: astController,
                decoration: InputDecoration(
                  labelText: 'AST/TGO',
                  suffixText: 'UI/L',
                ),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: ldhController,
                decoration: InputDecoration(
                  labelText: 'LDH',
                  suffixText: 'UI/L',
                ),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    calculateMortality();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Resultado'),
                          content: Column(
                            children: [
                              Text('Pontuação: $score'),
                              Text('Mortalidade: $mortalityCategory'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Fechar'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text('ADICIONAR PACIENTE'),
              ),
              if (score != 0.0)
                Column(
                  children: [
                    Text('Pontuação: $score'),
                    Text('Mortalidade: $mortalityCategory'),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
