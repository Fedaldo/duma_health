import 'package:cached_network_image/cached_network_image.dart';
import 'package:duma_health/models/insurance.dart';
import 'package:duma_health/services/cart_provider.dart';
import 'package:duma_health/widgets/loading_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class InsurancesGrid extends StatefulWidget {
  final List<Insurance> insurances;

  const InsurancesGrid({
    Key? key,
    required this.insurances,
  }) : super(key: key);

  @override
  State<InsurancesGrid> createState() => InsurancesGridState();
}

class InsurancesGridState extends State<InsurancesGrid> {
  bool isCheck = false;
  TextEditingController pController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Use an Insurance to pay this order",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            Checkbox(
                value: isCheck,
                onChanged: (value) {
                  setState(() {
                    isCheck = value!;
                    if (value == false) {
                      for (var element in widget.insurances) {
                        element.isSelected = false;
                      }
                      Provider.of<CartProvider>(context, listen: false)
                          .setDiscount(percentage: "0");
                      pController.text = "";
                    } else {
                      widget.insurances[0].isSelected = true;
                    }
                  });
                })
          ],
        ),
        const Divider(),
        Visibility(
          visible: isCheck,
          child: Column(
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(5),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 3.0,
                  crossAxisSpacing: 3.0,
                  //mainAxisExtent: 120,
                ),
                itemCount: widget.insurances.length,
                itemBuilder: (BuildContext context, int itemIndex) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        pController.text = "";
                        Provider.of<CartProvider>(context, listen: false)
                            .setDiscount(percentage: "0");
                        for (var element in widget.insurances) {
                          element.isSelected = false;
                        }
                        widget.insurances[itemIndex].isSelected = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        border: Border.all(
                          color: widget.insurances[itemIndex].isSelected
                              ? Colors.grey.withOpacity(0.5)
                              : Colors.transparent,
                        ),
                        color: widget.insurances[itemIndex].isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      widget.insurances[itemIndex].image != null
                                          ? "${widget.insurances[itemIndex].image}"
                                          : "",
                                  errorWidget: (BuildContext context, index, n) {
                                    return Image.asset(
                                      "assets/logo.png",
                                      width: MediaQuery.of(context).size.width,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                  placeholder: (context, n) {
                                    return LoadingHelper(
                                      width: MediaQuery.of(context).size.width,
                                      height: 60,
                                    );
                                  },
                                  width: MediaQuery.of(context).size.width,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "${widget.insurances[itemIndex].name}",
                                style: TextStyle(
                                  color: widget.insurances[itemIndex].isSelected
                                      ? Colors.white
                                      : Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "What percentage does your insurance support you?",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 80,
                      child: TextFormField(
                        controller: pController,
                        maxLength: 3,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "0",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.toString().isEmpty) {
                            Provider.of<CartProvider>(context, listen: false)
                                .setDiscount(percentage: "0");
                          } else if (int.parse(value) <= 100) {
                            Provider.of<CartProvider>(context, listen: false)
                                .setDiscount(percentage: value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
