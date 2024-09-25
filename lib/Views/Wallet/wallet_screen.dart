import 'package:noamooz/Controllers/Wallet/wallet_controller.dart';
import 'package:noamooz/Globals/Globals.dart';
import 'package:noamooz/Models/Wallet/transaction_model.dart';
import 'package:noamooz/Plugins/datepicker/persian_datetime_picker.dart';
import 'package:noamooz/Plugins/highlight_text.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/shimmer_widget.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:noamooz/Utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../Plugins/get/get.dart';

class WalletScreen extends StatelessWidget {
  final WalletController controller = Get.put(WalletController());

  WalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: StreamBuilder(
        stream: Globals.userStream.getStream,
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: ColorUtils.bgColor,
            appBar: buildAppBar(),
            body: Column(
              children: [
                ViewUtils.sizedBox(48),
                buildBalance(),
                ViewUtils.sizedBox(48),
                buildAddCredit(),
                ViewUtils.sizedBox(),
                Expanded(
                  child: buildTransactions(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      elevation: 0,
      toolbarHeight: 50,
      shadowColor: ColorUtils.orange,
      backgroundColor: ColorUtils.white,
      foregroundColor: ColorUtils.black,
      leadingWidth: 40,
      actions: [
        IconButton(
          splashRadius: 20,
          onPressed: () => Globals.toggleDarkMode(),
          icon: Icon(
            Globals.darkModeStream.darkMode ? Iconsax.lamp_on : Iconsax.lamp_slash,
            size: 26,
          ),
        ),
      ],
      title: Text(
        "کیف پول",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: ColorUtils.black,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget buildBalance() {
    return Container(
      width: Get.width,
      margin: const EdgeInsets.all(12),
      height: Get.height / 10,
      decoration: BoxDecoration(
        color: ColorUtils.white,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/img/wallet.png',
            height: Get.height / 12,
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: HighlightText(
                        text: "موجودی کیف پول ${Globals.settingStream.setting!.name}",
                        highlight: Globals.settingStream.setting!.name,
                        textAlign: TextAlign.right,
                        highlightStyle: TextStyle(
                          color: ColorUtils.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        style: TextStyle(
                          color: ColorUtils.black.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  ((Globals.userStream.user?.credit == null ||
                          Globals.userStream.user?.credit == 0)
                      ? "حساب خالی"
                      : '${Globals.userStream.user?.credit.toString().seRagham()} تومان'),
                  style: TextStyle(
                    color: ColorUtils.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAddCredit() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "افزودن اعتبار",
                style: TextStyle(
                  color: ColorUtils.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Icon(
                Iconsax.info_circle,
                color: ColorUtils.textColor,
                size: 15,
              ),
              const SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  "با استفاده از دکمه های زیر مبلغ مورد نظر خود برای افزایش اعتبار را وارد کنید",
                  style: TextStyle(
                    fontSize: 10,
                    color: ColorUtils.textColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WidgetUtils.smallSoftIcon(
                color: ColorUtils.red,
                icon: Iconsax.minus,
                onTap: () {
                  if (controller.addPrice.value > 0) {
                    controller.addPrice.value -= 5000;
                  }
                },
              ),
              Obx(
                () => Container(
                  decoration: BoxDecoration(
                    color: ColorUtils.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: Text(
                    "${controller.addPrice.toString().seRagham()} تومان",
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorUtils.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              WidgetUtils.smallSoftIcon(
                color: ColorUtils.green,
                icon: Iconsax.add,
                onTap: () {
                  if (controller.addPrice.value < 1000000) {
                    controller.addPrice.value += 5000;
                  }
                },
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            children: [
              Obx(
                () => Expanded(
                  child: WidgetUtils.softButton(
                    reverse: true,
                    loading: controller.isPayLoading,
                    icon: controller.addPrice > 0
                        ? Iconsax.wallet
                        : Iconsax.warning_2,
                    enabled: controller.addPrice > 0,
                    title: controller.addPrice > 0
                        ? "تایید و پرداخت"
                        : "مبلغ کمتر از حد مجاز",
                    fontWeight: FontWeight.bold,
                    onTap:
                        controller.addPrice > 0 ? () => controller.pay() : null,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTransactions() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "تراکنش های قبلی",
                style: TextStyle(
                  color: ColorUtils.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Icon(
                Iconsax.info_circle,
                color: ColorUtils.textColor,
                size: 15,
              ),
              const SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  "لیست تراکنش های شما از زمان ثبت نام در ${Globals.settingStream.setting!.name} تا الان",
                  style: TextStyle(
                    fontSize: 10,
                    color: ColorUtils.textColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Obx(
            () => Expanded(
              child: controller.isTransactionLoading.isTrue
                  ? ListView.separated(
                      itemCount: 8,
                      itemBuilder: (_, int index) => buildLoadingTransaction(),
                      separatorBuilder: (_, int index) => const SizedBox(
                        height: 18,
                      ),
                    )
                  : ListView.separated(
                      itemBuilder: (_, int index) => buildTransaction(index),
                      separatorBuilder: (_, int index) => SizedBox(
                        height: 18,
                        child: Center(
                          child: ViewUtils.softUiDivider(
                            ColorUtils.orange,
                            0.1,
                          ),
                        ),
                      ),
                      itemCount: controller.transactions.length,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoadingTransaction() {
    return Row(
      children: [
        ShimmerWidget(
          height: Get.height / 24,
          width: Get.height / 24,
          radius: 5,
        ),
        const SizedBox(
          width: 8,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerWidget(
              height: 15,
              width: Get.width / 4,
              radius: 5,
            ),
            const SizedBox(
              height: 8,
            ),
            ShimmerWidget(
              height: 12,
              width: Get.width / 3,
              radius: 5,
            ),
          ],
        ),
        const Spacer(),
        ShimmerWidget(
          height: 15,
          width: Get.width / 6,
          radius: 5,
        ),
      ],
    );
  }

  Widget buildTransaction(int index) {
    TransactionModel transaction = controller.transactions[index];
    return SizedBox(
      height: Get.height / 24,
      child: Row(
        children: [
          Container(
            height: Get.height / 24,
            width: Get.height / 24,
            decoration: BoxDecoration(
              color: transaction.isPayed
                  ? ColorUtils.green.withOpacity(0.2)
                  : ColorUtils.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: transaction.isPayed
                  ? Icon(
                      Iconsax.wallet_add,
                      color: ColorUtils.green,
                    )
                  : Icon(
                      Iconsax.wallet_remove,
                      color: ColorUtils.red,
                    ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    transaction.type,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: ColorUtils.black,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    "${transaction.id}#",
                    style: TextStyle(
                      fontSize: 12,
                      color: ColorUtils.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Iconsax.calendar_1,
                    size: 15,
                    color: ColorUtils.black.withOpacity(0.6),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    transaction.createdAt.toJalali().formatFullDate(),
                    style: TextStyle(
                      fontSize: 10,
                      color: ColorUtils.black.withOpacity(0.6),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                    height: 10,
                    child: VerticalDivider(
                      color: ColorUtils.orange,
                    ),
                  ),
                  Icon(
                    Iconsax.clock,
                    size: 15,
                    color: ColorUtils.black.withOpacity(0.6),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    "${transaction.createdAt.hour}:${transaction.createdAt.minute}",
                    style: TextStyle(
                      fontSize: 10,
                      color: ColorUtils.black.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Text(
            "${transaction.amount.toString().seRagham()} تومان",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: ColorUtils.black,
            ),
          ),
        ],
      ),
    );
  }
}
