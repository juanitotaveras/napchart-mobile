import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/choose_template_view_model.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/view_model_provider.dart';
import 'package:polysleep/injection_container.dart';

class ChooseTemplatePage extends StatelessWidget {
  final _viewModel = sl<ChooseTemplateViewModel>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Choose a template')),
      body: ViewModelProvider(
          bloc: this._viewModel,
          child: Container(
              width: double.infinity,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Sleep time')),
                  DataColumn(label: Text('Difficulty')),
                  // DataColumn(label: Text('Info'))
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('hi')),
                    DataCell(Text('hi2')),
                    DataCell(Text('hi3')),
                    // DataCell(Text('info'))
                  ])
                ],
              ))),
    );
  }
}
