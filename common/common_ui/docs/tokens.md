# Design System Tokens

Design tokens are semantic values for the design system. They are used to build scalable, consistent and extensible UI.

## Requirements

Here is a list of technical requirements to take into account when creating tokens:

- Tokens should be generic enough to support multiple brand styles. For example, one theme may use fully rounded controls (like text fields and buttons), while another uses slight or no rounding. But even in a fully rounded theme, not every component should be fully rounded; cards should keep standard rounded corners.
- Each token should include a recommended default use. For example, the background color token is for app backgrounds, not card backgrounds.
- Components should not use hardcoded visual values (color, radius, spacing, elevation, opacity).
- Token naming should be semantic and stable (avoid names tied to raw values like blue500 in app-facing APIs). The only exception right now is spacing tokens, which are named `sN` where `N` is the pixel value at default base. This makes it easier to understand the relationship between the token and the visual value and doesn't break customizations.
