import 'package:flutter/material.dart';

class MySwitchFormField extends FormField<bool> {
  MySwitchFormField({
    Key key,
    bool initialValue, // Initial field value
    this.decoration =
        const InputDecoration(), // A BoxDecoration to style the field FormFieldSetter

    onSaved, // Method called when when the form is saved FormFieldValidator

    validator, // Method called for validation

    this.onChanged, // Method called whenever the value changes

    this.constraints =
        const BoxConstraints(), // A BoxConstraints to set the switch size
  })  : assert(decoration != null),
        assert(initialValue != null),
        assert(constraints != null),
        // assert(activeColor != null),
        super(
          key: key,
          onSaved: onSaved,
          initialValue: initialValue,
          validator: validator,
          builder: (FormFieldState field) {
            final InputDecoration effectiveDecoration =
                decoration.applyDefaults(
              Theme.of(field.context).inputDecorationTheme,
            );
            return InputDecorator(
              decoration:
                  effectiveDecoration.copyWith(errorText: field.errorText),
              isEmpty: field.value == null,
              child: Row(
                children: [
                  ConstrainedBox(
                    constraints: constraints,
                    child: Switch(
                      value: field.value,
                      onChanged: field.didChange,
                    ),
                  ),
                ],
              ),
            );
          },
        );
  final ValueChanged onChanged;
  final InputDecoration decoration;
  final BoxConstraints constraints;
  // final Colors activeColor;
  @override
  FormFieldState<bool> createState() => _MySwitchFormFieldState();
}

class _MySwitchFormFieldState extends FormFieldState<bool> {
  @override
  MySwitchFormField get widget => super.widget;
  @override
  void didChange(bool value) {
    super.didChange(value);
    if (widget.onChanged != null) {
      widget.onChanged(value);
    }
  }
}

class MyDateField extends StatelessWidget {
  const MyDateField({
    Key key,
    this.formattedDate,
    this.timeagoTime,
    this.selectDate,
  }) : super(key: key);

  final String formattedDate;
  final String timeagoTime;
  final Function selectDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        margin: EdgeInsets.fromLTRB(2, 10, 0, 0),

        // padding: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(Icons.calendar_today),
            SizedBox(
              width: 14,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "Payment Date",
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  // mainAxisAlignment:
                  //     MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      formattedDate,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      timeagoTime,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            RaisedButton(
              child: Text("Select Date"),
              onPressed: () => selectDate(context),
              color: Color(0xff8dbdff),
            )
          ],
        ),
      ),
    );
  }
}
