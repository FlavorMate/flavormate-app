import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable_content.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable_sort.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_struct.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class FPageable<T> extends StatefulWidget {
  final $AsyncNotifierProvider<dynamic, PageableDto<T>> provider;
  final PPageableStateProvider pageProvider;
  final FPageableSort Function(EdgeInsets)? filterBuilder;
  final Widget Function(BuildContext, List<T>) builder;
  final FEmptyMessage onError;
  final FEmptyMessage onEmpty;

  final double padding;

  const FPageable({
    super.key,
    required this.provider,
    required this.pageProvider,
    required this.builder,
    required this.onError,
    required this.onEmpty,
    this.filterBuilder,
    this.padding = PADDING,
  });

  @override
  State<FPageable<T>> createState() => _FPageableState<T>();
}

class _FPageableState<T> extends State<FPageable<T>> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final filterPadding = EdgeInsets.only(
      left: widget.padding,
      right: widget.padding,
      top: widget.padding,
      bottom: PADDING,
    );

    final contentPadding = EdgeInsets.only(
      left: widget.padding,
      right: widget.padding,
      bottom: widget.padding,
      top: widget.filterBuilder != null ? 0 : widget.padding,
    );

    return Column(
      children: [
        Expanded(
          child: FProviderStruct(
            provider: widget.provider,
            onError: widget.onError,
            builder: (context, state) {
              final content = state.data;
              return content.isEmpty
                  ? Center(child: widget.onEmpty)
                  : Column(
                      children: [
                        if (widget.filterBuilder != null)
                          widget.filterBuilder!.call(filterPadding),
                        Expanded(
                          child: FPageableContent(
                            padding: contentPadding,
                            controller: _controller,
                            child: widget.builder.call(context, content),
                          ),
                        ),
                      ],
                    );
            },
          ),
        ),
        FPageableBar(
          provider: widget.provider,
          pageProvider: widget.pageProvider,
          controller: _controller,
        ),
      ],
    );
  }
}
