import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/wallet_controller.dart';


class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final TextEditingController addAmount = TextEditingController();
    final FocusNode focusNode = FocusNode();

    return GetBuilder<WalletController>(
      init: WalletController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: GestureDetector(
              child: Icon(Icons.arrow_back_ios_new),
              onTap: () {
                Get.back();
              },
            ),
            title: Text(
              'Wallet',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: screenWidth * 0.04,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            actions: [
              Image.asset("assets/images/car_icon_n.png"),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(screenWidth * 0.02),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  balanceSection(context, controller, screenWidth, screenHeight, addAmount, focusNode),
                  SizedBox(height: screenHeight * 0.01),
                  transactionSection(context, controller, screenWidth)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget balanceSection(BuildContext context, WalletController controller, double screenWidth, double screenHeight, TextEditingController addAmount, FocusNode focusNode) {
    return Padding(
      padding: EdgeInsets.fromLTRB(screenWidth * 0.05, 5, screenWidth * 0.05, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Balance',
            style: TextStyle(
              color: Colors.black,
              fontSize: screenWidth * 0.04,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              letterSpacing: -0.24,
            ),
          ),
          SizedBox(height: 10),
          Obx(() {
            final wallet = controller.walletResponse.value;
            return Text(
              '₹ ${wallet.driverData.wallet}',
              style: TextStyle(
                color: Colors.black,
                fontSize: screenWidth * 0.08,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            );
          }),
          SizedBox(height: 10),
          Stack(
            alignment: Alignment.topLeft,
            children: [
              Column(
                children: [
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(width: 1, color: Colors.black)),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: addAmount,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: IconButton(
                            onPressed: () {},
                            icon: Text(
                              '₹',
                              style: TextStyle(
                                color: Color(0xFF919191),
                                fontSize: screenWidth * 0.04,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.05),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    'Enter Amount',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenWidth * 0.035,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w300,
                      letterSpacing: -0.24,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
              // Print the amount entered in the text field
              print('Entered Amount: ${addAmount.text}');

              // Dismiss the keyboard
              FocusScope.of(context).unfocus();

              // Optionally, handle logic to add money here
              // await controller.addMoney(addAmount);
            },
            child: Container(
              width: double.infinity,
              height: screenHeight * 0.07,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.25, vertical: 13),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
              ),
              child: Center(
                child: Text(
                  'Add Money',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.04,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.24,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: screenHeight * 0.07,
            padding: EdgeInsets.symmetric(vertical: 13),
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: Color(0xFFFCB117),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
            ),
            child: Center(
              child: Text(
                'Withdraw',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.04,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget transactionSection(BuildContext context, WalletController controller, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transactions History',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: screenWidth * 0.04,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10),
        Obx(() {
          final transactions = controller.walletResponse.value.transactionData;
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0xFFFFFFE0)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transaction.type,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: screenWidth * 0.035,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Transaction Id : ${transaction.transactionId}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: screenWidth * 0.03,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${transaction.type == '1' ? '+' : '-'}₹${transaction.amount}', // todo case for credit/debit type
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: transaction.type == '1'
                                    ? Color(0xFF006C17)
                                    : Colors.red,
                                fontSize: screenWidth * 0.045,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${transaction.createdAt.substring(11, 16)} | ${transaction.createdAt.substring(0, 10)}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: screenWidth * 0.03,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ],
    );
  }
}
