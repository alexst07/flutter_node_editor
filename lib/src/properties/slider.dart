import 'package:flutter/material.dart';

import '../../node_editor.dart';

class SliderProperty extends StatefulWidget {
  const SliderProperty(
      {Key? key,
      required this.name,
      required this.value,
      this.secondaryTrackValue,
      this.onChanged,
      this.onChangeStart,
      this.onChangeEnd,
      required this.min,
      required this.max,
      this.divisions,
      this.label,
      this.activeColor,
      this.inactiveColor,
      this.secondaryActiveColor,
      this.thumbColor,
      this.overlayColor,
      this.mouseCursor,
      this.semanticFormatterCallback,
      this.focusNode,
      required this.autofocus})
      : super(key: key);

  final String name;

  /// The currently selected value for this slider.
  ///
  /// The slider's thumb is drawn at a position that corresponds to this value.
  final double value;

  /// The secondary track value for this slider.
  ///
  /// If not null, a secondary track using [Slider.secondaryActiveColor] color
  /// is drawn between the thumb and this value, over the inactive track.
  ///
  /// If less than [Slider.value], then the secondary track is not shown.
  ///
  /// It can be ideal for media scenarios such as showing the buffering progress
  /// while the [Slider.value] shows the play progress.
  final double? secondaryTrackValue;

  /// Called during a drag when the user is selecting a new value for the slider
  /// by dragging.
  ///
  /// The slider passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the slider with the new
  /// value.
  ///
  /// If null, the slider will be displayed as disabled.
  ///
  /// The callback provided to onChanged should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// {@tool snippet}
  ///
  /// ```dart
  /// Slider(
  ///   value: _duelCommandment.toDouble(),
  ///   min: 1.0,
  ///   max: 10.0,
  ///   divisions: 10,
  ///   label: '$_duelCommandment',
  ///   onChanged: (double newValue) {
  ///     setState(() {
  ///       _duelCommandment = newValue.round();
  ///     });
  ///   },
  /// )
  /// ```
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [onChangeStart] for a callback that is called when the user starts
  ///    changing the value.
  ///  * [onChangeEnd] for a callback that is called when the user stops
  ///    changing the value.
  final ValueChanged<double>? onChanged;

  /// Called when the user starts selecting a new value for the slider.
  ///
  /// This callback shouldn't be used to update the slider [value] (use
  /// [onChanged] for that), but rather to be notified when the user has started
  /// selecting a new value by starting a drag or with a tap.
  ///
  /// The value passed will be the last [value] that the slider had before the
  /// change began.
  ///
  /// {@tool snippet}
  ///
  /// ```dart
  /// Slider(
  ///   value: _duelCommandment.toDouble(),
  ///   min: 1.0,
  ///   max: 10.0,
  ///   divisions: 10,
  ///   label: '$_duelCommandment',
  ///   onChanged: (double newValue) {
  ///     setState(() {
  ///       _duelCommandment = newValue.round();
  ///     });
  ///   },
  ///   onChangeStart: (double startValue) {
  ///     print('Started change at $startValue');
  ///   },
  /// )
  /// ```
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [onChangeEnd] for a callback that is called when the value change is
  ///    complete.
  final ValueChanged<double>? onChangeStart;

  /// Called when the user is done selecting a new value for the slider.
  ///
  /// This callback shouldn't be used to update the slider [value] (use
  /// [onChanged] for that), but rather to know when the user has completed
  /// selecting a new [value] by ending a drag or a click.
  ///
  /// {@tool snippet}
  ///
  /// ```dart
  /// Slider(
  ///   value: _duelCommandment.toDouble(),
  ///   min: 1.0,
  ///   max: 10.0,
  ///   divisions: 10,
  ///   label: '$_duelCommandment',
  ///   onChanged: (double newValue) {
  ///     setState(() {
  ///       _duelCommandment = newValue.round();
  ///     });
  ///   },
  ///   onChangeEnd: (double newValue) {
  ///     print('Ended change on $newValue');
  ///   },
  /// )
  /// ```
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [onChangeStart] for a callback that is called when a value change
  ///    begins.
  final ValueChanged<double>? onChangeEnd;

  /// The minimum value the user can select.
  ///
  /// Defaults to 0.0. Must be less than or equal to [max].
  ///
  /// If the [max] is equal to the [min], then the slider is disabled.
  final double min;

  /// The maximum value the user can select.
  ///
  /// Defaults to 1.0. Must be greater than or equal to [min].
  ///
  /// If the [max] is equal to the [min], then the slider is disabled.
  final double max;

  /// The number of discrete divisions.
  ///
  /// Typically used with [label] to show the current discrete value.
  ///
  /// If null, the slider is continuous.
  final int? divisions;

  /// A label to show above the slider when the slider is active and
  /// [SliderThemeData.showValueIndicator] is satisfied.
  ///
  /// It is used to display the value of a discrete slider, and it is displayed
  /// as part of the value indicator shape.
  ///
  /// The label is rendered using the active [ThemeData]'s [TextTheme.bodyLarge]
  /// text style, with the theme data's [ColorScheme.onPrimary] color. The
  /// label's text style can be overridden with
  /// [SliderThemeData.valueIndicatorTextStyle].
  ///
  /// If null, then the value indicator will not be displayed.
  ///
  /// Ignored if this slider is created with [Slider.adaptive].
  ///
  /// See also:
  ///
  ///  * [SliderComponentShape] for how to create a custom value indicator
  ///    shape.
  final String? label;

  /// The color to use for the portion of the slider track that is active.
  ///
  /// The "active" side of the slider is the side between the thumb and the
  /// minimum value.
  ///
  /// If null, [SliderThemeData.activeTrackColor] of the ambient
  /// [SliderTheme] is used. If that is null, [ColorScheme.primary] of the
  /// surrounding [ThemeData] is used.
  ///
  /// Using a [SliderTheme] gives much more fine-grained control over the
  /// appearance of various components of the slider.
  final Color? activeColor;

  /// The color for the inactive portion of the slider track.
  ///
  /// The "inactive" side of the slider is the side between the thumb and the
  /// maximum value.
  ///
  /// If null, [SliderThemeData.inactiveTrackColor] of the ambient [SliderTheme]
  /// is used. If that is null and [ThemeData.useMaterial3] is true,
  /// [ColorScheme.surfaceVariant] will be used, otherwise [ColorScheme.primary]
  /// with an opacity of 0.24 will be used.
  ///
  /// Using a [SliderTheme] gives much more fine-grained control over the
  /// appearance of various components of the slider.
  ///
  /// Ignored if this slider is created with [Slider.adaptive].
  final Color? inactiveColor;

  /// The color to use for the portion of the slider track between the thumb and
  /// the [Slider.secondaryTrackValue].
  ///
  /// Defaults to the [SliderThemeData.secondaryActiveTrackColor] of the current
  /// [SliderTheme].
  ///
  /// If that is also null, defaults to [ColorScheme.primary] with an
  /// opacity of 0.54.
  ///
  /// Using a [SliderTheme] gives much more fine-grained control over the
  /// appearance of various components of the slider.
  ///
  /// Ignored if this slider is created with [Slider.adaptive].
  final Color? secondaryActiveColor;

  /// The color of the thumb.
  ///
  /// If this color is null, [Slider] will use [activeColor], If [activeColor]
  /// is also null, [Slider] will use [SliderThemeData.thumbColor].
  ///
  /// If that is also null, defaults to [ColorScheme.primary].
  ///
  /// * [CupertinoSlider] will have a white thumb
  /// (like the native default iOS slider).
  final Color? thumbColor;

  /// The highlight color that's typically used to indicate that
  /// the slider thumb is focused, hovered, or dragged.
  ///
  /// If this property is null, [Slider] will use [activeColor] with
  /// an opacity of 0.12, If null, [SliderThemeData.overlayColor]
  /// will be used.
  ///
  /// If that is also null, If [ThemeData.useMaterial3] is true,
  /// Slider will use [ColorScheme.primary] with an opacity of 0.08 when
  /// slider thumb is hovered and with an opacity of 0.12 when slider thumb
  /// is focused or dragged, If [ThemeData.useMaterial3] is false, defaults
  /// to [ColorScheme.primary] with an opacity of 0.12.
  final MaterialStateProperty<Color?>? overlayColor;

  /// {@template flutter.material.slider.mouseCursor}
  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// widget.
  ///
  /// If [mouseCursor] is a [MaterialStateProperty<MouseCursor>],
  /// [MaterialStateProperty.resolve] is used for the following [MaterialState]s:
  ///
  ///  * [MaterialState.dragged].
  ///  * [MaterialState.hovered].
  ///  * [MaterialState.focused].
  ///  * [MaterialState.disabled].
  /// {@endtemplate}
  ///
  /// If null, then the value of [SliderThemeData.mouseCursor] is used. If that
  /// is also null, then [MaterialStateMouseCursor.clickable] is used.
  ///
  /// See also:
  ///
  ///  * [MaterialStateMouseCursor], which can be used to create a [MouseCursor]
  ///    that is also a [MaterialStateProperty<MouseCursor>].
  final MouseCursor? mouseCursor;

  /// The callback used to create a semantic value from a slider value.
  ///
  /// Defaults to formatting values as a percentage.
  ///
  /// This is used by accessibility frameworks like TalkBack on Android to
  /// inform users what the currently selected value is with more context.
  ///
  /// {@tool snippet}
  ///
  /// In the example below, a slider for currency values is configured to
  /// announce a value with a currency label.
  ///
  /// ```dart
  /// Slider(
  ///   value: _dollars.toDouble(),
  ///   min: 20.0,
  ///   max: 330.0,
  ///   label: '$_dollars dollars',
  ///   onChanged: (double newValue) {
  ///     setState(() {
  ///       _dollars = newValue.round();
  ///     });
  ///   },
  ///   semanticFormatterCallback: (double newValue) {
  ///     return '${newValue.round()} dollars';
  ///   }
  ///  )
  /// ```
  /// {@end-tool}
  ///
  /// Ignored if this slider is created with [Slider.adaptive]
  final SemanticFormatterCallback? semanticFormatterCallback;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  @override
  State<SliderProperty> createState() => _SliderPropertyState();
}

class _SliderPropertyState extends State<SliderProperty>
    with PropertyMixin<double?> {
  @override
  void initState() {
    registerProperty(context, widget.name, null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: widget.value,
      onChanged: (double value) {
        setPropertyValue(value);
        widget.onChanged?.call(value);
      },
      overlayColor: widget.overlayColor,
      activeColor: widget.activeColor,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      mouseCursor: widget.mouseCursor,
      inactiveColor: widget.inactiveColor,
      divisions: widget.divisions,
      label: widget.label,
      max: widget.max,
      min: widget.min,
      onChangeEnd: widget.onChangeEnd,
      onChangeStart: widget.onChangeStart,
      secondaryActiveColor: widget.secondaryActiveColor,
      secondaryTrackValue: widget.secondaryTrackValue,
      semanticFormatterCallback: widget.semanticFormatterCallback,
      thumbColor: widget.thumbColor,
    );
  }
}
