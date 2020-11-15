import 'package:autobuff/src/blocs/service_bloc.dart';
import 'package:autobuff/src/models/service_model.dart';
import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final ServiceBloc serviceBloc;
  final ServiceModel service;
  final BuildContext context;
  final int index;

  ServiceCard(
    this.serviceBloc,
    this.service,
    this.context,
    this.index,
  );

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        child: Card(
          elevation: 0.0,
          margin: EdgeInsets.symmetric(vertical: 3.0, horizontal: 1.0),
          child: Container(
            padding: EdgeInsets.only(
              left: 10.0,
              top: 10.0,
              bottom: 15.0,
              right: 10.0,
            ),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _getChildren(),
              ),
            ),
          ),
        ),
        onTap: () {
          serviceBloc.updateServiceindex(index);
        },
      ),
    );
  }

  List<Widget> _getChildren() {
    List<Widget> children = [
      Expanded(child: firstColumn()),
      //secondColumn(),
    ];
    return children;
  }

  Widget firstColumn() {
    return StreamBuilder(
        stream: serviceBloc.serviceIndex,
        builder: (BuildContext context, AsyncSnapshot<int> serviceIndex) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      service.service.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Radio(
                    value: serviceIndex.hasData ? serviceIndex.data : 0,
                    groupValue: index,
                    onChanged: (val) {
                      serviceBloc.updateServiceindex(index);
                    },
                    activeColor: Colors.lightBlueAccent,
                  ),
                ],
              ),
              Text(
                '(Rs.${service.price})',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        });
  }

  secondColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[Radio(value: 0, groupValue: 0, onChanged: null)],
    );
  }

  thirdRow() {
    return Row(
      children: <Widget>[
        Text(
          '25/2/2020 | 4:00 PM',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
