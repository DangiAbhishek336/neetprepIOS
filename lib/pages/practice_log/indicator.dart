
import 'package:flutter/material.dart';
import 'package:neetprep_essential/flutter_flow/flutter_flow_theme.dart';

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.textValue,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });
  final Color color;
  final String text;
  final String textValue;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width:150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children:[
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                text,
                style:FlutterFlowTheme.of(context).bodyMedium,
              ),

            ]
          ),
          Text(
            textValue,
            style:FlutterFlowTheme.of(context).bodyMedium,
          )
        ],
      ),
    );
  }
}
