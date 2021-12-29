import 'package:flutter/material.dart';
import 'package:kmp_petugas_app/features/dashboard/data/models/dashboard_model.dart';

class PCheckboxListTile extends StatefulWidget {
  final Base? data;
  final Function? onChange;
  final bool checked;

  PCheckboxListTile({
    this.data,
    this.onChange,
    this.checked = false,
  });
  @override
  _PCheckboxListTileState createState() => _PCheckboxListTileState();
}

class _PCheckboxListTileState extends State<PCheckboxListTile> {
  bool check = false;

  @override
  void initState() {
    super.initState();
    check = widget.checked;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      // padding: EdgeInsets.only(bottom: 10),
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: Color(0xff58C863),
        contentPadding: EdgeInsets.all(2),
        title: Text(
          widget.data!.name!,
          style: TextStyle(
              fontFamily: "Nunito",
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.black,
              fontStyle: FontStyle.normal),
        ),
        subtitle: Text(
          "Rp." + widget.data!.amount.toString(),
          style: TextStyle(
              fontFamily: "Nunito",
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Color(0xff121212),
              fontStyle: FontStyle.normal),
        ),
        value: check,
        onChanged: (newValue) {
          setState(() {
            check = newValue!;
            _add(widget.data!, check);
          });
        },
      ),
    );
  }

  void _add(Base data, bool checked) {
    widget.onChange!(data, checked);
  }
}
