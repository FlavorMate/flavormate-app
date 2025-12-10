import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/presentation/common/slivers/f_paginated_page/f_paginated_bar.dart';
import 'package:flavormate/presentation/common/slivers/f_paginated_page/f_paginated_content.dart';
import 'package:flavormate/presentation/common/slivers/f_paginated_page/f_paginated_sort.dart';
import 'package:flavormate/presentation/common/slivers/f_sized_box_sliver.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class FPaginatedPage<T> extends ConsumerStatefulWidget {
  final String title;
  final List<Widget>? actions;
  final bool emptyAppBar;
  final $AsyncNotifierProvider<dynamic, PageableDto<T>> provider;
  final PPageableStateProvider pageProvider;

  final FEmptyMessage onError;
  final FEmptyMessage onEmpty;

  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? floatingActionButton;

  final FPaginatedSort Function()? sortBuilder;

  final Widget Function(List<T> item) itemBuilder;

  const FPaginatedPage({
    super.key,
    required this.title,
    this.actions,
    this.emptyAppBar = false,
    required this.provider,
    required this.pageProvider,
    required this.onEmpty,
    required this.onError,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.sortBuilder,
    required this.itemBuilder,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FPaginatedPageState<T>();
}

class _FPaginatedPageState<T> extends ConsumerState<FPaginatedPage<T>> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar(
        title: widget.title,
        showHome: !widget.emptyAppBar,
        automaticallyImplyLeading: !widget.emptyAppBar,
        actions: widget.actions,
      ),
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      floatingActionButton: widget.floatingActionButton,
      body: SafeArea(
        child: CustomScrollView(
          controller: _controller,
          slivers: [
            if (widget.sortBuilder != null)
              SliverPersistentHeader(
                floating: true,
                delegate: FPaginatedSortDelegate(widget.sortBuilder!),
              ),
            FPaginatedContent(
              provider: widget.provider,
              pageProvider: widget.pageProvider,
              itemBuilder: widget.itemBuilder,
              controller: _controller,
              onEmpty: widget.onEmpty,
              onError: widget.onError,
            ),

            // Add some space so content doesn't overlap with FAB
            if (widget.floatingActionButton != null)
              const FSizedBoxSliver(height: 56 + 32),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: FPaginatedBar(
          provider: widget.provider,
          pageProvider: widget.pageProvider,
          controller: _controller,
        ),
      ),
    );
  }
}
