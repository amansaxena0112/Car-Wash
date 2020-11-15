import 'package:autobuff/src/blocs/service_bloc.dart';
import 'package:autobuff/src/models/service_model.dart';
import 'package:autobuff/src/providers/service_bloc_provider.dart';
import 'package:autobuff/src/utils/navigator_util.dart';
import 'package:autobuff/src/widgets/service_card.dart';
import 'package:flutter/material.dart';

class ServiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ServiceBlocProvider(
      child: ServiceDetailsBase(),
    );
  }
}

class ServiceDetailsBase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 1.0,
        title: Text(
          'Select Service',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ServiceDetails(),
    );
  }
}

class ServiceDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ServiceBloc _serviceBloc = ServiceBlocProvider.getServiceBloc(context);
    _serviceBloc.getServices(context);
    return ListView(
      children: <Widget>[
        StreamBuilder(
            stream: _serviceBloc.servicesList,
            builder: (BuildContext context,
                AsyncSnapshot<List<ServiceModel>> servicesList) {
              return Container(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      servicesList.hasData && servicesList.data.length > 0
                          ? servicesList.data.length
                          : 0,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return ServiceCard(
                        _serviceBloc, servicesList.data[index], ctxt, index);
                  },
                ),
              );
            }),
        nextButton(context, _serviceBloc),
      ],
    );
  }

  Widget nextButton(BuildContext context, ServiceBloc serviceBloc) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 40.0,
          bottom: 30.0,
          left: 20.0,
          right: 20.0,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 80.0),
          decoration: BoxDecoration(
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'NEXT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () async {
        await serviceBloc.updateBookingModel();
        NavigatorUtil navigatorUtil = NavigatorUtil();
        if (serviceBloc.isNowValue) {
          navigatorUtil.navigateToScreen(context, '/booking-confirmation');
        } else {
          navigatorUtil.navigateToScreen(context, '/date-time');
        }
      },
    );
  }
}
