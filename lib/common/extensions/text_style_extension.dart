// Flutter imports:
import 'package:flutter/material.dart';

extension TextStyleExtension on TextStyle {
  // Colors
  TextStyle colorPrimary(BuildContext context) => copyWith(
    color: Theme.of(context).colorScheme.primary,
  );
  TextStyle colorOnPrimary(BuildContext context) => copyWith(
    color: Theme.of(context).colorScheme.onPrimary,
  );
  TextStyle colorPrimaryContainer(BuildContext context) => copyWith(
    color: Theme.of(context).colorScheme.primaryContainer,
  );
  TextStyle colorOnPrimaryContainer(BuildContext context) => copyWith(
    color: Theme.of(context).colorScheme.onPrimaryContainer,
  );
  TextStyle colorSecondary(BuildContext context) => copyWith(
    color: Theme.of(context).colorScheme.secondary,
  );
  TextStyle colorOnSecondary(BuildContext context) => copyWith(
    color: Theme.of(context).colorScheme.onSecondary,
  );
  TextStyle colorSecondaryContainer(BuildContext context) => copyWith(
    color: Theme.of(context).colorScheme.secondaryContainer,
  );
  TextStyle colorOnSecondaryContainer(BuildContext context) => copyWith(
    color: Theme.of(context).colorScheme.onSecondaryContainer,
  );
  TextStyle colorTertiary(BuildContext context) => copyWith(
    color: Theme.of(context).colorScheme.tertiary,
  );
  TextStyle colorOnTertiary(BuildContext context) => copyWith(
    color: Theme.of(context).colorScheme.onTertiary,
  );
  TextStyle colorTertiaryContainer(BuildContext context) => copyWith(
    color: Theme.of(context).colorScheme.tertiaryContainer,
  );
  TextStyle colorOnTertiaryContainer(BuildContext context) => copyWith(
    color: Theme.of(context).colorScheme.onTertiaryContainer,
  );
  TextStyle colorError(BuildContext context) => copyWith(
    color: Theme.of(context).colorScheme.error,
  );
  TextStyle colorOnError(BuildContext context) => copyWith(
    color: Theme.of(context).colorScheme.onError,
  );
  TextStyle colorErrorContainer(BuildContext context) => copyWith(
    color: Theme.of(context).colorScheme.errorContainer,
  );
  TextStyle colorOnErrorContainer(BuildContext context) => copyWith(
    color: Theme.of(context).colorScheme.onErrorContainer,
  );
  TextStyle colorSurface(BuildContext context) => copyWith(
    color: Theme.of(context).colorScheme.surface,
  );
  TextStyle colorOnSurface(BuildContext context) => copyWith(
    color: Theme.of(context).colorScheme.onSurface,
  );
  TextStyle colorOnSurfaceVariant(BuildContext context) => copyWith(
    color: Theme.of(context).colorScheme.onSurfaceVariant,
  );
  TextStyle colorOutline(BuildContext context) => copyWith(
    color: Theme.of(context).colorScheme.outline,
  );
  TextStyle colorOutlineVariant(BuildContext context) => copyWith(
    color: Theme.of(context).colorScheme.outlineVariant,
  );

  // Weights
  TextStyle get light => copyWith(
    fontWeight: FontWeight.w300,
  );
  TextStyle get regular => copyWith(
    fontWeight: FontWeight.w400,
  );
  TextStyle get medium => copyWith(
    fontWeight: FontWeight.w500,
  );
  TextStyle get semiBold => copyWith(
    fontWeight: FontWeight.w600,
  );
  TextStyle get bold => copyWith(
    fontWeight: FontWeight.w700,
  );
}
