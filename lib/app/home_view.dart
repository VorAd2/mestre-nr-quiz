import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mestre_nr/quiz/views/loading_view.dart';
import 'package:mestre_nr/core/widgets/theme_button.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final Set<int> selectedNRs = {};
  String? selectedDifficulty;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: getAppBar(cs),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final isMobile = width < 600;
          final double horizontalPadding = isMobile ? 20 : 70;
          final double badgeFontSize = isMobile ? 14 : 18;
          final double sectionTitleSize = isMobile ? 16 : 20;
          final double buttonFontSize = isMobile ? 18 : 22;
          final double verticalSpacing = isMobile ? 20 : 35;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Selecione as NRs:",
                  style: TextStyle(
                    fontSize: sectionTitleSize,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                getNrs(badgeFontSize, cs, isMobile),
                SizedBox(height: verticalSpacing * 1.5),
                Text(
                  "Selecione a dificuldade:",
                  style: TextStyle(
                    fontSize: sectionTitleSize,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: getDropdown(badgeFontSize, cs, isMobile),
                ),
                SizedBox(height: verticalSpacing * 1.5),
                getStartBtn(
                  badgeFontSize: badgeFontSize,
                  buttonFontSize: buttonFontSize,
                  cs: cs,
                  isMobile: isMobile,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget getAppBar(ColorScheme cs) {
    return AppBar(
      toolbarHeight: 70,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/logo.svg',
                width: 64,
                height: 64,
                colorFilter: ColorFilter.mode(cs.primary, BlendMode.srcIn),
              ),
              const SizedBox(width: 10),
              Text(
                "Mestre NR",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ],
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 12, top: 9),
          child: ThemeButton(),
        ),
      ],
      centerTitle: true,
    );
  }

  Widget getNrs(double badgeFontSize, ColorScheme cs, bool isMobile) {
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
              horizontal: isMobile ? 14 : 20,
            ),
            decoration: BoxDecoration(
              color: selected ? cs.primary : cs.surfaceContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "NR $nr",
              style: TextStyle(
                fontSize: badgeFontSize,
                color: selected ? cs.onPrimary : cs.onSurface,
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget getDropdown(double badgeFontSize, ColorScheme cs, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: isMobile ? 4 : 6),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: cs.surface,
          hint: Text(
            "Escolher dificuldade",
            style: TextStyle(fontSize: badgeFontSize, color: cs.onSurface),
          ),
          value: selectedDifficulty,
          icon: Icon(
            Icons.arrow_drop_down,
            size: isMobile ? 22 : 28,
            color: cs.onSurface,
          ),
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
    required double badgeFontSize,
    required double buttonFontSize,
    required ColorScheme cs,
    required bool isMobile,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
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
          final userParams = {'nrs': selectedNRs, 'diff': selectedDifficulty!};
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => LoadingView(userParams: userParams),
            ),
          );
        },
        child: Text(
          "Iniciar Quiz",
          style: TextStyle(
            fontSize: buttonFontSize,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
