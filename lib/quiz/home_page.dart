import 'package:flutter/material.dart';

const double mobileBreakpoint = 600;
const double tabletBreakpoint = 900;

bool isMobile(double width) => width < mobileBreakpoint;
bool isTablet(double width) =>
    width >= mobileBreakpoint && width < tabletBreakpoint;
bool isDesktop(double width) => width >= tabletBreakpoint;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Set<int> selectedNRs = {};
  String? selectedDifficulty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            double titleSize = isMobile(width)
                ? 26
                : isTablet(width)
                ? 32
                : 40;
            double badgeFontSize = isMobile(width) ? 14 : 18;
            double sectionTitleSize = isMobile(width) ? 16 : 20;
            double buttonFontSize = isMobile(width) ? 18 : 22;
            double verticalSpacing = isMobile(width) ? 20 : 35;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile(width) ? 20 : 80,
                vertical: 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        size: isMobile(width) ? 60 : 90,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Mestre NR",
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: verticalSpacing * 1.5),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Selecione as NRs:",
                      style: TextStyle(
                        fontSize: sectionTitleSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  getWrap(width, badgeFontSize),
                  SizedBox(height: verticalSpacing * 1.5),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Selecione a dificuldade:",
                      style: TextStyle(
                        fontSize: sectionTitleSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  getDropdown(width, badgeFontSize),
                  SizedBox(height: verticalSpacing * 2),

                  getStartBtn(
                    width: width,
                    badgeFontSize: badgeFontSize,
                    buttonFontSize: buttonFontSize,
                  ),
                  SizedBox(height: verticalSpacing),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget getWrap(double width, double badgeFontSize) {
    return Wrap(
      spacing: 8,
      runSpacing: 10,
      children: List.generate(38, (i) {
        final nr = i + 1;
        final selected = selectedNRs.contains(nr);

        return GestureDetector(
          onTap: () {
            setState(() {
              selected ? selectedNRs.remove(nr) : selectedNRs.add(nr);
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: isMobile(width) ? 14 : 20,
            ),
            decoration: BoxDecoration(
              color: selected ? Colors.blue : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "NR $nr",
              style: TextStyle(
                fontSize: badgeFontSize,
                color: selected ? Colors.white : Colors.black87,
                fontWeight: selected ? FontWeight.bold : FontWeight.w400,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget getDropdown(double width, double badgeFontSize) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(
            "Escolher dificuldade",
            style: TextStyle(fontSize: badgeFontSize),
          ),
          value: selectedDifficulty,
          icon: Icon(Icons.arrow_drop_down, size: isMobile(width) ? 26 : 30),
          items: const [
            DropdownMenuItem(value: "Fácil", child: Text("Fácil")),
            DropdownMenuItem(value: "Médio", child: Text("Médio")),
            DropdownMenuItem(value: "Difícil", child: Text("Difícil")),
          ],
          onChanged: (value) {
            setState(() => selectedDifficulty = value);
          },
        ),
      ),
    );
  }

  Widget getStartBtn({
    required double width,
    required double badgeFontSize,
    required double buttonFontSize,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: EdgeInsets.symmetric(vertical: isMobile(width) ? 16 : 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          if (selectedNRs.isEmpty || selectedDifficulty == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Selecione ao menos uma NR e uma dificuldade.",
                  style: TextStyle(fontSize: badgeFontSize),
                ),
              ),
            );
            return;
          }
        },
        child: Text(
          "Iniciar Quiz",
          style: TextStyle(fontSize: buttonFontSize, color: Colors.white),
        ),
      ),
    );
  }
}
