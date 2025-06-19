import 'dart:developer';

import 'package:flutter/material.dart';

import '../../Widgets/custom/appBarWidget.dart';
import '../../Widgets/custom/customtext.dart';
import '../../backend/supabase/models/feedback_model.dart';
import '../../constants/color.dart';
import '../../utils/flutter_flow/date_format.dart';
import '../../utils/loading.dart';
import '../../utils/utils.dart';

class FeedBack extends StatefulWidget {
  const FeedBack({super.key});

  @override
  State<FeedBack> createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getFeedbacks();
    });
  }

  bool iSLoading = false;

  List<FeedbackRows> feedbacks = [];

  getFeedbacks() async {
    setState(() {
      iSLoading = true;
    });
    await FeedBacktable()
        .queryRows(
      queryFn: (q) => q.order('id', ascending: false),
    )
        .then((value) {
      log(value.toString());
      feedbacks.addAll(value);
      log(feedbacks.toString());
    });

    setState(() {
      iSLoading = false;
    });
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: appBarWidget(
        "Feedbacks",
        true,
        [],
        () {
          Navigator.pop(context);
        },
      ),
      body: iSLoading == true
          ? Center(child: showLoading())
          : feedbacks.isEmpty
              ? Center(
                  child: CustomText2("No Data found", secondaryTextColor, 15,
                      FontWeight.w600, TextOverflow.clip),
                )
              : RawScrollbar(
                  interactive: true,
                  thumbVisibility: true,
                  thumbColor: primaryColor,
                  radius: const Radius.circular(4),
                  crossAxisMargin: 1,
                  controller: scrollController,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: feedbacks.length,
                          padding: EdgeInsets.only(top: 10),
                          itemBuilder: (context, index) {
                            var user = feedbacks[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          secondaryTextColor.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                          user.user_name.toString(),
                                          black,
                                          20,
                                          FontWeight.w900,
                                          TextOverflow.clip),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      CustomText(
                                          user.subject.toString(),
                                          black,
                                          16,
                                          FontWeight.w600,
                                          TextOverflow.clip),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      CustomText2(
                                          user.message.toString(),
                                          secondaryTextColor,
                                          14,
                                          FontWeight.w500,
                                          TextOverflow.clip),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomText2(
                                                dateTimeFormat("EEE, dd MMM y",
                                                    user.createdAt),
                                                secondaryTextColor,
                                                12,
                                                FontWeight.w500,
                                                TextOverflow.clip),
                                            IconButton(
                                              onPressed: () {
                                                FeedBacktable()
                                                    .delete(
                                                        matchingRows: (q) =>
                                                            q.eq(
                                                                'feedback_id',
                                                                user.feedback_id
                                                                    .toString()))
                                                    .then((value) {
                                                  setState(() {
                                                    feedbacks.clear();
                                                    getFeedbacks();
                                                  });
                                                  Utils()
                                                      .toastMessage("Deleted");
                                                }).onError((error, stackTrace) {
                                                  Utils().toastMessage(
                                                      "Something went wrong");
                                                });
                                              },
                                              icon: Icon(
                                                Icons.delete_outline,
                                                color: red,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
