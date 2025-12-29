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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Scaffold(
      appBar: const _MyAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Selecione as NRs:",
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 16),
              _NRsWrap(
                selectedNRs: selectedNRs,
                onTap: (nr, selected) {
                  setState(() {
                    selected ? selectedNRs.remove(nr) : selectedNRs.add(nr);
                  });
                },
              ),
              const SizedBox(height: 32),
              Text(
                "Selecione a dificuldade:",
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 16),
              _MyDropdown(
                selectedDifficulty: selectedDifficulty,
                onChanged: (value) {
                  setState(() => selectedDifficulty = value);
                },
              ),
              const SizedBox(height: 24),
              _StartButton(
                onPressed: () {
                  if (selectedNRs.isEmpty || selectedDifficulty == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Selecione ao menos uma NR e uma dificuldade.",
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }
                  final userParams = {
                    'nrs': selectedNRs,
                    'diff': selectedDifficulty!,
                  };
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LoadingView(userParams: userParams),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _MyAppBar();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final textTheme = theme.textTheme;
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/logo.svg',
            width: 40,
            height: 40,
            colorFilter: ColorFilter.mode(cs.primary, BlendMode.srcIn),
          ),
          const SizedBox(width: 12),
          Text(
            "Mestre NR",
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
      actions: const [
        Padding(padding: EdgeInsets.only(right: 16), child: ThemeButton()),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _NRsWrap extends StatelessWidget {
  final Set<int> selectedNRs;
  final void Function(int, bool) onTap;
  const _NRsWrap({required this.selectedNRs, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final textTheme = theme.textTheme;
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.start,
      children: List.generate(38, (i) {
        final nr = i + 1;
        final selected = selectedNRs.contains(nr);
        return InkWell(
          onTap: () {
            onTap(nr, selected);
          },
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: selected ? cs.primary : cs.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected ? cs.primary : Colors.transparent,
              ),
            ),
            child: Text(
              "NR $nr",
              style: textTheme.bodyMedium?.copyWith(
                color: selected ? cs.onPrimary : cs.onSurface,
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _MyDropdown extends StatelessWidget {
  final String? selectedDifficulty;
  final void Function(String?) onChanged;

  const _MyDropdown({
    required this.selectedDifficulty,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final textTheme = theme.textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          dropdownColor: cs.surfaceContainer,
          hint: Text("Escolher dificuldade", style: textTheme.bodyLarge),
          icon: Icon(Icons.arrow_drop_down, color: cs.primary),
          value: selectedDifficulty,
          items: const [
            DropdownMenuItem(value: "facil", child: Text("Fácil")),
            DropdownMenuItem(value: "medio", child: Text("Médio")),
            DropdownMenuItem(value: "dificil", child: Text("Difícil")),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _StartButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _StartButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final textTheme = theme.textTheme;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          "Iniciar Quiz",
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: cs.onPrimary,
          ),
        ),
      ),
    );
  }
}
