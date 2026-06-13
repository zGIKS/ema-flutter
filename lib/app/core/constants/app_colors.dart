import 'package:flutter/material.dart';

/// Centralized semantic color palette for the Ema application.
///
/// All UI colors must reference this class instead of inline hex literals.
/// Colors are grouped by semantic purpose.
abstract final class AppColors {
  // ── Brand / Primary ──────────────────────────────────────────────────────
  /// Bright blue – forms, navigation selected state, icon accents.
  static const Color primary = Color(0xFF2563EB);

  /// Deep navy – FABs, primary action buttons, avatar icon color.
  static const Color primaryDark = Color(0xFF0D47A1);

  /// Medium blue – user list avatar icon.
  static const Color primaryMedium = Color(0xFF1D4ED8);

  /// Pale-blue chip / badge background, avatar container fill.
  static const Color primaryLight = Color(0xFFEAF2FF);

  /// Pale avatar background used in identity screens.
  static const Color avatarBackground = Color(0xFFE8EEFF);

  // ── Surfaces ─────────────────────────────────────────────────────────────
  /// Page / scaffold background.
  static const Color background = Color(0xFFF8F9FC);

  /// Card / modal white surface.
  static const Color surface = Colors.white;

  /// Subtle off-white surface variant (grid cells, form fill, image placeholder).
  static const Color surfaceVariant = Color(0xFFF1F5F9);

  /// Bottom-nav container fill.
  static const Color navBackground = Color(0xFFF4F5FB);

  // ── Borders ───────────────────────────────────────────────────────────────
  /// Primary stroke for inputs and cards.
  static const Color border = Color(0xFFE2E8F0);

  /// Alternate slightly-warmer border.
  static const Color borderWarm = Color(0xFFE5E7EB);

  // ── Text ──────────────────────────────────────────────────────────────────
  /// Titles and high-emphasis text.
  static const Color textTitle = Color(0xFF111827);

  /// Body text and form labels.
  static const Color textBody = Color(0xFF1F2937);

  /// Secondary descriptive text.
  static const Color textSecondary = Color(0xFF4B5563);

  /// Tertiary / caption text.
  static const Color textTertiary = Color(0xFF64748B);

  /// Hint / placeholder text.
  static const Color textHint = Color(0xFF94A3B8);

  /// Disabled / unselected items.
  static const Color textDisabled = Color(0xFF9CA3AF);

  /// Helper labels, account screen subtitle.
  static const Color textMuted = Color(0xFF6B7280);

  /// Very-light periwinkle hint used in form inputs.
  static const Color textHintSoft = Color(0xFFA0AABF);

  // ── Role Badges ───────────────────────────────────────────────────────────
  static const Color adminBadgeBg = Color(0xFFF5F3FF);
  static const Color adminBadgeBorder = Color(0xFFDDD6FE);
  static const Color adminBadgeText = Color(0xFF6D28D9);

  static const Color userBadgeBg = Color(0xFFF1F5F9);
  static const Color userBadgeText = Color(0xFF475569);

  // ── Status ────────────────────────────────────────────────────────────────
  /// Success – SnackBar background.
  static const Color success = Color(0xFF16A34A);

  /// Danger – logout button background.
  static const Color error = Color(0xFFDC2626);

  /// Error banner fill.
  static const Color errorBg = Color(0xFFFEE2E2);

  /// Error banner text.
  static const Color errorText = Color(0xFF991B1B);

  // ── Auditory Log Badges ────────────────────────────────────────────────────
  static const Color auditFaceBg = Color(0xFFEDE9FE);
  static const Color auditFaceText = Color(0xFF7C3AED);

  static const Color auditActionBg = Color(0xFFE0F2FE);
  static const Color auditActionText = Color(0xFF0369A1);

  static const Color auditErrorText = Color(0xFFB91C1C);

  // ── Biometric / Face Upload ────────────────────────────────────────────────
  /// Face-upload card background.
  static const Color faceCardBg = Color(0xFFF4F6FB);

  /// Face-upload dotted border.
  static const Color faceCardBorder = Color(0xFFC7D2FE);

  /// Face-upload placeholder icon.
  static const Color faceCardIcon = Color(0xFFA5B4FC);

  /// Clear-photo button dark background.
  static const Color clearPhotoBg = Color(0xFF111827);

  // ── Profile / Account ─────────────────────────────────────────────────────
  static const Color profileAvatarBg = Color(0xFFF3F4F6);
  static const Color profileAvatarBorder = Color(0xFFD1D5DB);
  static const Color profileAvatarIcon = Color(0xFF6B7280);

  // ── Shadows ───────────────────────────────────────────────────────────────
  static const Color shadowLight = Color(0x0C000000);
  static const Color shadowMedium = Color(0x1A000000);
}
