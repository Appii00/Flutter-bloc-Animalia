import 'package:animalapp/screens/all_type_animals/stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:animalapp/models/animal_model.dart';
import 'package:animalapp/models/class_model.dart';
import 'package:animalapp/screens/classs_info/cubit/stream.dart';
import 'package:animalapp/themes/theme.dart';
import 'package:animalapp/widgets/animals_list.dart';
import 'package:animalapp/widgets/error_page.dart';
import 'package:animalapp/widgets/loading_page.dart';

class AllAnimalsByType extends StatelessWidget {
  final String name;
  final String image;
  final int index;
  const AllAnimalsByType({
    Key? key,
    required this.name,
    required this.image,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
          backgroundColor: scaffoldColor,
          body: ClassTypeInfoWidget(
            index: 1,
            name: name,
            image: image,
          )),
    );
  }
}

class ClassTypeInfoWidget extends StatefulWidget {
  final String name;
  final String image;
  final int index;
  ClassTypeInfoWidget({
    Key? key,
    required this.name,
    required this.image,
    required this.index,
  }) : super(key: key);

  @override
  _ClassTypeInfoWidgetState createState() => _ClassTypeInfoWidgetState();
}

class _ClassTypeInfoWidgetState extends State<ClassTypeInfoWidget> {
  final GetAllTypesAnimals animal = GetAllTypesAnimals();

  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    animal.addData(widget.name);
    controller.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      print("at the end of list");
      if (!animal.isfinish) {
        animal.getNextAnimals(animal.snp, widget.name);
      }
    }
  }

  @override
  void dispose() {
    animal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      controller: controller,
      slivers: [
        SliverAppBarWithShadow(
          title: widget.name,
          image: widget.image,
          index: widget.index,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: StreamBuilder<List<Animals>>(
              stream: animal.controller.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final animals = snapshot.data!;
                  return Container(
                    child: Column(
                      children: [
                        GridView(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, childAspectRatio: 9 / 16),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            for (var i = 0; i < animals.length; i++)
                              AnimalsGridCard(
                                animals: animals[i],
                                index: i,
                              ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        if (!animal.isfinish)
                          if (animal.animals.length > 5)
                            Center(
                                child: CircularProgressIndicator(
                              backgroundColor: Colors.black,
                              color: Colors.greenAccent.shade400,
                            ))
                          else
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Look like you reach the end!",
                                  style: normalText,
                                ),
                              ),
                            )
                        else
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Look like you reach the end!",
                                style: normalText,
                              ),
                            ),
                          ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
