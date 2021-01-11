import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctors_prescription/components/detail_row.dart';
import 'package:doctors_prescription/components/patient/add_medicine/medicine_detail_card.dart';
import 'package:doctors_prescription/models/medicine.dart';
import 'package:doctors_prescription/pages/patient/components/app_bar.dart';
import 'package:flutter/material.dart';

class AddMedicineArguments {
  final List<Medicine> medicines;

  AddMedicineArguments({this.medicines});
}

class PatientAddMedicine extends StatefulWidget {
  @override
  _PatientAddMedicineState createState() => _PatientAddMedicineState();
}

class _PatientAddMedicineState extends State<PatientAddMedicine> {
  double _daySliderValue = 1;
  double _dozesSliderValue = 1;

  addMedicineReminder(BuildContext context, Medicine medicine) {
    setState(() {
      _daySliderValue = 1;
      _dozesSliderValue = 1;
    });
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          color: Color(0xFF737373),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0),
              ),
            ),
            child: StatefulBuilder(builder: (context, setState) {
              return Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 30.0),
                          child: CachedNetworkImage(
                            imageUrl: medicine.image,
                            placeholder: (context, url) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DetailRow(
                                title: 'Name',
                                data: medicine.name,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              DetailRow(
                                title: 'Category',
                                data: medicine.category,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              DetailRow(
                                title: 'Weight',
                                data: medicine.weight,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Text(
                    'Number of days',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35.0),
                    child: Row(
                      children: [
                        Text(
                          '1',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        Expanded(
                          child: Slider(
                            value: _daySliderValue,
                            min: 1,
                            max: 7,
                            divisions: 6,
                            label: _daySliderValue.round().toString(),
                            activeColor: Colors.green,
                            onChanged: (double newSliderValue) {
                              setState(() {
                                _daySliderValue = newSliderValue;
                              });
                            },
                          ),
                        ),
                        Text(
                          '7',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Number of dozes per day',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35.0),
                    child: Row(
                      children: [
                        Text(
                          '1',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        Expanded(
                          child: Slider(
                            value: _dozesSliderValue,
                            min: 1,
                            max: 4,
                            divisions: 3,
                            label: _dozesSliderValue.round().toString(),
                            activeColor: Colors.green,
                            onChanged: (double newSliderValue) {
                              setState(() {
                                _dozesSliderValue = newSliderValue;
                              });
                            },
                          ),
                        ),
                        Text(
                          '4',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35.0),
                      child: ListView.builder(
                        itemCount: _dozesSliderValue.toInt(),
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text('Dose number => ${index + 1}'),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Center(
                    child: RaisedButton.icon(
                      color: Colors.green,
                      textColor: Colors.white,
                      onPressed: () {},
                      icon: Icon(Icons.add),
                      label: Text(
                        'Add Reminder',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final AddMedicineArguments medicineArguments =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: PatientAppBar(title: 'Scanned Medicines'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: medicineArguments.medicines.length,
          itemBuilder: (BuildContext context, int index) {
            Medicine currentMedicine = medicineArguments.medicines[index];
            return MedicineDetailCard(
              name: currentMedicine.name,
              category: currentMedicine.category,
              weight: currentMedicine.weight,
              id: currentMedicine.id,
              image: currentMedicine.image,
              hasAddedReminder: currentMedicine.hasAddedReminder,
              showBottomSheet: () {
                this.addMedicineReminder(context, currentMedicine);
              },
            );
          },
        ),
      ),
    );
  }
}
