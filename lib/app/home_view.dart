import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mestre_nr/quiz/views/loading_view.dart';
import 'package:mestre_nr/core/theme/app_colors.dart';
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
    final colors = Theme.of(context).colorScheme;
    final custom = Theme.of(context).extension<AppColorScheme>()!;

    return Scaffold(
      backgroundColor: custom.background,
      appBar: getAppBar(custom, colors),
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
                    color: custom.text,
                  ),
                ),
                const SizedBox(height: 10),
                getNrs(badgeFontSize, colors, isMobile),
                SizedBox(height: verticalSpacing * 1.5),
                Text(
                  "Selecione a dificuldade:",
                  style: TextStyle(
                    fontSize: sectionTitleSize,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: custom.text,
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: getDropdown(badgeFontSize, colors, isMobile),
                ),
                SizedBox(height: verticalSpacing * 1.5),
                getStartBtn(
                  badgeFontSize: badgeFontSize,
                  buttonFontSize: buttonFontSize,
                  colors: colors,
                  isMobile: isMobile,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget getAppBar(AppColorScheme custom, ColorScheme colors) {
    return AppBar(
      backgroundColor: custom.background,
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
                colorFilter: ColorFilter.mode(colors.primary, BlendMode.srcIn),
              ),
              const SizedBox(width: 10),
              Text(
                "Mestre NR",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                  color: custom.text,
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

  Widget getNrs(double badgeFontSize, ColorScheme colors, bool isMobile) {
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
              color: selected ? colors.primary : colors.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "NR $nr",
              style: TextStyle(
                fontSize: badgeFontSize,
                color: selected ? Colors.white : colors.onSurface,
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget getDropdown(double badgeFontSize, ColorScheme colors, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: isMobile ? 4 : 6),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: colors.surface,
          hint: Text(
            "Escolher dificuldade",
            style: TextStyle(fontSize: badgeFontSize, color: colors.onSurface),
          ),
          value: selectedDifficulty,
          icon: Icon(
            Icons.arrow_drop_down,
            size: isMobile ? 22 : 28,
            color: colors.onSurface,
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
    required ColorScheme colors,
    required bool isMobile,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
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
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
