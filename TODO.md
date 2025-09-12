# TODO List for Accent Color Application to AppBar and Icons

## Completed Tasks
- [x] Updated `lib/main.dart` to set `AppBarTheme` with `backgroundColor` as `themeProvider.accentColor`, and `foregroundColor` and `iconTheme` with contrasting color for both light and dark themes.
- [x] Fixed `lib/screens/history_screen.dart` to remove explicit `color` from `IconButton` in `AppBar` actions to inherit the correct foreground color.
- [x] Verified that BottomNavigationBar in `home_screen.dart` uses `colorScheme.primary` which is the accent color.

## Pending Tasks
- [ ] Test the app to verify that the accent color is applied to all AppBars and their icons across screens (Scanner, Generator, History, Settings).
- [ ] Ensure the BottomNavigationBar icons also reflect the accent color change if needed.
- [ ] Check for any accessibility issues with the contrasting colors.

## Notes
- The accent color is now used as the AppBar background, with automatically calculated contrasting colors for text and icons.
- Icons in the body (e.g., list items in History screen) continue to use the primary color from the color scheme.
- The BottomNavigationBar selected icons are already using the accent color.
