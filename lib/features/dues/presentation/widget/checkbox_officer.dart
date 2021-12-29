import 'package:flutter/material.dart';
import 'package:kmp_petugas_app/features/dashboard/data/models/dashboard_model.dart';

class OfficersPositionCheck extends StatefulWidget {
  final VillageRwRt? position;
  final Function? onChange;

  OfficersPositionCheck({
    this.position,
    this.onChange,
  });
  @override
  _OfficersPositionCheckState createState() => _OfficersPositionCheckState();
}

class _OfficersPositionCheckState extends State<OfficersPositionCheck> {
  bool check = false;
  void initState() {
    if (widget.position!.id != null) {
      // check = true;
      // print('haha');
      // print(check);
      // print(widget.onChange);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: Color(0xff58C863),
        contentPadding: EdgeInsets.all(2),
        title: Text(
          widget.position!.displayText!,
          style: TextStyle(
              fontFamily: "Nunito",
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.black,
              fontStyle: FontStyle.normal),
        ),
        value: check,
        onChanged: (newValue) {
          setState(() {
            check = newValue!;
            _add(
                Base(
                    id: widget.position!.id!,
                    name: widget.position!.displayText),
                check);
          });
        },
      ),
    );
  }

  void _add(Base data, bool checked) {
    widget.onChange!(data, checked);
  }
}
