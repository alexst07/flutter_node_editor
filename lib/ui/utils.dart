import 'package:flutter/material.dart';

String idGenerator() {
  final now = DateTime.now();
  return now.microsecondsSinceEpoch.toString();
}

Widget showError(BuildContext context, List<String> errors, {double? height}) {
  return Dialog(
    child: Container(
      width: MediaQuery.of(context).size.width / 3,
      height: height ?? 270,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.lightBlue.shade100, Colors.lightBlue.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade200,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: const Padding(
              padding:
                  EdgeInsets.only(left: 10.0, right: 10.0, top: 2, bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    child: Text(
                      "Error",
                      style: TextStyle(
                          color: Color.fromARGB(255, 35, 6, 80),
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                  ),
                ],
              ),
            ),
          ),
          DefaultTextStyle(
            style: const TextStyle(
              color: Color.fromARGB(255, 35, 6, 80),
            ),
            maxLines: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: SizedBox(
                  width: double.maxFinite,
                  height: height == null ? 208 : height - 62,
                  child: ListView.builder(
                      itemCount: errors.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: "[ERROR-${index + 1}] ",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              TextSpan(
                                  text: errors[index],
                                  style: TextStyle(color: Colors.red.shade400))
                            ])),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        );
                      }),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
