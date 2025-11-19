import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mestre_nr/core/theme/app_colors.dart';
import 'package:mestre_nr/core/theme/theme_controller.dart';

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
    final colors = Theme.of(context).colorScheme;
    final custom = Theme.of(context).extension<AppColorScheme>()!;

    return Scaffold(
      backgroundColor: custom.background,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: custom.background,
        title: Padding(
          padding: EdgeInsets.only(top: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/logo.svg',
                width: 70,
                height: 70,
                colorFilter: ColorFilter.mode(colors.primary, BlendMode.srcIn),
              ),
              const SizedBox(width: 10),
              Text(
                "Mestre NR",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: custom.text,
                ),
              ),
            ],
          ),
        ),
        actions: [
          ValueListenableBuilder(
            valueListenable: ThemeController.themeMode,
            builder: (context, mode, _) {
              final isDark = mode == ThemeMode.dark;
              return IconButton(
                icon: Icon(
                  isDark ? Icons.light_mode : Icons.dark_mode,
                  color: colors.secondary,
                ),
                onPressed: () => ThemeController.toggleTheme(),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Selecione as NRs:",
                      style: TextStyle(
                        fontSize: sectionTitleSize,
                        fontWeight: FontWeight.w600,
                        color: custom.text,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  getWrap(width, badgeFontSize, colors),
                  SizedBox(height: verticalSpacing * 1.5),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Selecione a dificuldade:",
                      style: TextStyle(
                        fontSize: sectionTitleSize,
                        fontWeight: FontWeight.w600,
                        color: custom.text,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  getDropdown(width, badgeFontSize, colors),
                  SizedBox(height: verticalSpacing * 2),

                  getStartBtn(
                    width: width,
                    badgeFontSize: badgeFontSize,
                    buttonFontSize: buttonFontSize,
                    colors: colors,
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

  Widget getWrap(double width, double badgeFontSize, ColorScheme colors) {
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
              color: selected ? colors.primary : colors.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "NR $nr",
              style: TextStyle(
                fontSize: badgeFontSize,
                color: selected ? Colors.white : colors.onSurface,
                fontWeight: selected ? FontWeight.bold : FontWeight.w400,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget getDropdown(double width, double badgeFontSize, ColorScheme colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(
            "Escolher dificuldade",
            style: TextStyle(fontSize: badgeFontSize, color: colors.onSurface),
          ),
          value: selectedDifficulty,
          icon: Icon(
            Icons.arrow_drop_down,
            size: isMobile(width) ? 26 : 30,
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
    required double width,
    required double badgeFontSize,
    required double buttonFontSize,
    required ColorScheme colors,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
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
