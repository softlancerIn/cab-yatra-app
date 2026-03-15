import 'package:flutter/material.dart';

class SupportScreennn extends StatefulWidget {
  const SupportScreennn({super.key});

  @override
  State<SupportScreennn> createState() => _SupportScreennnState();
}

class _SupportScreennnState extends State<SupportScreennn> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // inFun();
  }

  // void inFun() {
  //   final pro = Provider.of<SupportProvider>(context, listen: false);
  //   pro.getQuery(context);
  //   pro.getFAQ(context);
  // }

  bool show = false;
  bool noShow = false;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          child: const Icon(Icons.arrow_back_ios_new),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Support",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [Image.asset("assets/images/car_icon_n.png")],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: screenHeight * 0.02,
            ),
            const Text("Tell us how we can help",
                // textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600)),
            const SizedBox(
              height: 10,
            ),
            Text(
                "Our experts of superheroes are standing by for services & suupport of superheroes are standing by for services & suupport",
                //  textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.black.withOpacity(0.4),
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400)),
            const SizedBox(
              height: 30,
            ),
            Container(
              //   height: screenHeight * 0.3,
              // margin: EdgeInsets.only(
              //     left: 20, right: 20, top: screenHeight * 0.04),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadiusDirectional.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 2),
                    blurRadius: 2.0,
                    spreadRadius: 0.3,
                  ),
                ],
              ),
              child: TextFormField(
                //controller: provider.controller,
                //maxLines: 100,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: Color(0xFFA3A3A3),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.22,
                  ),
                  contentPadding:
                      EdgeInsets.only(left: 11, top: 10, bottom: 10, right: 40),
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            faqSection(
              context,
            ),
          ],
        ),
      ),
    );
  }

  Widget faqSection(
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [],
        ),
        ListView.builder(
          // reverse: true,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          // itemCount: 7,
          itemCount: helpSupportData.length,
          itemBuilder: (context, index) {
            return Stack(
              alignment: Alignment.centerLeft,
              children: [
                QAItem(
                    title: Text(
                        "${helpSupportData[index].sNo} : ${helpSupportData[index].question}"),
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(helpSupportData[index].answer)),
                    ])
              ],
            );
          },
        )
      ],
    );
  }
}

class QAItem extends StatelessWidget {
  const QAItem({
    super.key,
    required this.title,
    required this.children,
    this.titleColor = Colors.black,
    this.titleFontSize = 14.0,
    this.titleFontWeight = FontWeight.w500,
    this.backgroundColor = Colors.white,
  });

  final Widget title;
  final List<Widget> children;
  final Color titleColor;
  final double titleFontSize;
  final FontWeight titleFontWeight;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      // tilePadding: EdgeInsets.zero,
      textColor: titleColor,

      title: DefaultTextStyle(
        style: TextStyle(
          color: titleColor,
          fontSize: titleFontSize,
          fontWeight: titleFontWeight,
        ),
        child: title,
      ),
      children: children,
    );
  }
}

class QuestionAnswer {
  final String question;
  final String answer;
  final String sNo;

  QuestionAnswer(
      {required this.question, required this.answer, required this.sNo});
}

List<QuestionAnswer> helpSupportData = [
  QuestionAnswer(
    question: "How do I book a ride?",
    answer:
        "To book a ride, open the app, enter your destination, select your preferred ride type, and confirm the booking.",
    sNo: "1",
  ),
  QuestionAnswer(
    question: "Can I schedule a ride in advance?",
    answer:
        "Yes, you can schedule a ride in advance by selecting the 'Schedule' option and choosing a date and time for your ride.",
    sNo: "2",
  ),
  QuestionAnswer(
    question: "How can I cancel my booking?",
    answer:
        "To cancel a booking, go to the 'My Rides' section, select the booking you want to cancel, and tap on the 'Cancel Ride' option.",
    sNo: "3",
  ),
  QuestionAnswer(
    question: "What payment methods are available?",
    answer:
        "We accept credit cards, debit cards, and mobile payment methods like Google Pay and Apple Pay.",
    sNo: "4",
  ),
  QuestionAnswer(
    question: "What if I left something in the taxi?",
    answer:
        "If you left something in the taxi, go to the 'Help' section and report a lost item. We will assist you in retrieving your belongings.",
    sNo: "5",
  ),
  QuestionAnswer(
    question: "How do I contact customer support?",
    answer:
        "You can contact customer support by going to the 'Help' section and selecting 'Contact Us'. You can also email us or call our support hotline.",
    sNo: "6",
  ),
  QuestionAnswer(
    question: "How do I update my payment information?",
    answer:
        "To update your payment information, go to 'Payment Settings' in the app and add or update your payment method.",
    sNo: "7",
  ),
];
