import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/presentation/common/slivers/f_paginated_page/f_paginated_bar.dart';
import 'package:flavormate/presentation/common/slivers/f_paginated_page/f_paginated_content.dart';
import 'package:flavormate/presentation/common/slivers/f_paginated_page/f_paginated_sort.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class FPaginatedPage<T> extends ConsumerStatefulWidget {
  final String title;
  final bool emptyAppBar;
  final Widget? floatingActionBar;
  final $AsyncNotifierProvider<dynamic, PageableDto<T>> provider;
  final PPageableStateProvider pageProvider;

  final FEmptyMessage onError;
  final FEmptyMessage onEmpty;

  final FPaginatedSort Function()? sortBuilder;

  final Widget Function(T item) itemBuilder;

  const FPaginatedPage({
    super.key,
    required this.title,
    this.emptyAppBar = false,
    this.floatingActionBar,
    required this.provider,
    required this.pageProvider,
    required this.onEmpty,
    required this.onError,
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
      ),
      floatingActionButton: widget.floatingActionBar,
      body: CustomScrollView(
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
        ],
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
