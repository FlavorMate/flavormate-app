import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';

class TPageableBar extends StatelessWidget {
  final int totalPages;
  final int currentPage;
  final Function(int) onPressed;

  const TPageableBar({
    super.key,
    required this.totalPages,
    required this.onPressed,
    required this.currentPage,
  });

  List<String> get createPaginationButtons {
    List<String> pages = [];

    if (totalPages <= 6) {
      // If total pages are less than or equal to 6, show all page numbers
      for (int i = 1; i <= totalPages; i++) {
        pages.add(i.toString());
      }
    } else {
      if (currentPage <= 2) {
        // If current page is in the first 3 pages
        for (int i = 1; i <= 5; i++) {
          pages.add(i.toString());
        }
        pages.add('...');
        pages.add(totalPages.toString());
      } else if (currentPage >= totalPages - 4) {
        // If current page is in the last 3 pages
        pages.add('1');
        pages.add('...');
        for (int i = totalPages - 4; i <= totalPages; i++) {
          pages.add(i.toString());
        }
      } else {
        // For all middle pages
        pages.add('1');
        pages.add('...');
        for (int i = currentPage; i <= currentPage + 2; i++) {
          pages.add(i.toString());
        }
        pages.add('...');
        pages.add(totalPages.toString());
      }
    }

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(PADDING / 2),
      child: Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        spacing: PADDING / 2,
        children: List.generate(
          createPaginationButtons.length,
          (index) {
            final label = createPaginationButtons[index];

            const width = 40.0;
            final int i = label == '...' ? -1 : int.parse(label) - 1;

            onPressed() {
              if (label != '...') {
                this.onPressed(i);
              }
            }

            if (i == currentPage) {
              return SizedBox(
                width: width,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: onPressed,
                  child: Text(label),
                ),
              );
            } else {
              return SizedBox(
                width: width,
                child: FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: onPressed,
                  child: Text(label),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
