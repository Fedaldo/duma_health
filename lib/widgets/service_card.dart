import 'package:duma_health/models/hospital_service.dart';
import 'package:duma_health/utils/data_manager.dart';
import 'package:duma_health/utils/enumeration.dart';
import 'package:duma_health/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:go_router/go_router.dart';

class ServiceCard extends StatefulWidget {
  final HospitalService service;

  const ServiceCard({super.key, required this.service});

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        DataManager.getInstance().service = widget.service;
        context.push('/${RouterPath.doctors}');
      },
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.withOpacity(0.06),
          ),
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        margin: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            FontAwesome.handshake_o,
                            size: 15,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              "${widget.service.name}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height:2,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                      ),
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color:Colors.white,
                          fontSize: 15,
                        ),
                        children: [
                          const TextSpan(
                            text: "FBU ",
                            style:
                                TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          TextSpan(
                            text: Utils.formatPrice("${widget.service.price}"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Icon(
                    FontAwesome.user_md,
                    color: Colors.white,
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
