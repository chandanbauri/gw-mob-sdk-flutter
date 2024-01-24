import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scgateway_flutter_plugin_example/app/widgets/SIButton.dart';
import 'package:scgateway_flutter_plugin_example/app/widgets/SISwitch.dart';
import 'package:scgateway_flutter_plugin_example/app/widgets/SIText.dart';
import 'package:scgateway_flutter_plugin_example/app/widgets/SITextField.dart';

import '../main.dart';
import 'widgets/SIEnvironmentController.dart';

class SILoansPage extends StatelessWidget {
  const SILoansPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SIText.xlarge(text: "LOANS"),
        actions: [
          SIButton(
            label: "Gateway",
            onPressed: () => context.go("/"),
          )
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 8),
          children: [
            SIEnvironmentController(repository: repository),
            StreamBuilder(
              stream: repository.scLoanConfig,
              builder: (context, snapshot) {
                final data = snapshot.data;
                return Column(
                  children: [
                    SITextField(
                      hint: "Enter Gateway Name",
                      text: data?.gatewayName,
                    ),
                    SITextField(
                      hint: "Enter Custom Interaction Token",
                      text: data?.customInteractionToken,
                    ),
                  ],
                );
              },
            ),
            Wrap(
              spacing: 12,
              children: [
                SIButton(label: "Setup", onPressed: () async {
                  await repository.setupScLoans(context);
                }),
                SIButton(label: "Apply", onPressed: () async {
                  await repository.apply(repository.scLoanConfig.value.customInteractionToken ?? "", context);
                }),
                SIButton(label: "Pay", onPressed: () async {
                  await repository.pay(repository.scLoanConfig.value.customInteractionToken ?? "", context);
                }),
                SIButton(label: "Withdraw", onPressed: () async {
                  await repository.withdraw(repository.scLoanConfig.value.customInteractionToken ?? "", context);
                }),
                SIButton(label: "Service", onPressed: () async {
                  await repository.service(repository.scLoanConfig.value.customInteractionToken ?? "", context);
                }),
              ],
            ),
            StreamBuilder(
              stream: repository.siConfig,
              builder: (context, snapshot) {
                final data = snapshot.data;
                return Wrap(
                  children: [
                    SITextField(
                      text: data?.loansUserId,
                      hint: "Enter SI user Id",
                    ),
                    SIButton(label: "Get User")
                  ],
                );
              },
            ),
            SIText.large(text: "Create a New User"),
            Wrap(
              children: [
                SITextField(hint: "Enter new user Id"),
                SITextField(hint: "Enter PAN"),
                SITextField(hint: "Enter DOB"),
                SITextField(hint: "Enter Email"),
                SITextField(hint: "Enter Phone"),
                SITextField(hint: "Enter Bank Acc. no."),
                SITextField(hint: "Enter IFSC code"),
                SITextField(hint: "Enter Account Type"),
                SITextField(hint: "Enter MF Holdings Json"),
                SISwitch(
                  label: "Enable Lien Marking",
                  isEnabled: false,
                  onChanged: (value) {},
                ),
              ],
            ),
            SIButton(label: "Register")
          ],
        ),
      ),
    );
  }
}