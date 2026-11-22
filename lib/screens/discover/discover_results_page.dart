import 'package:flutter/material.dart';
import '../match/match_page.dart';

/// Resultados de una categoría de Explorar (usa la misma pantalla de Descubre con el filtro ya puesto).
class DiscoverResultsPage extends StatefulWidget {
  final String title;
  final String? goal;
  final bool pedigree;
  final double? km;

  const DiscoverResultsPage({
    super.key,
    required this.title,
    this.goal,
    this.pedigree = false,
    this.km,
  });

  @override
  State<DiscoverResultsPage> createState() => _DiscoverResultsPageState();
}

class _DiscoverResultsPageState extends State<DiscoverResultsPage> {
  final GlobalKey<MatchPageState> matchKey = GlobalKey<MatchPageState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MatchPage(
            key: matchKey,
            initialGoal: widget.goal,
            initialPedigree: widget.pedigree,
            initialKm: widget.km,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 16, 14, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => matchKey.currentState?.openFilters(),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.tune_rounded,
                          color: Colors.white, size: 22),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
