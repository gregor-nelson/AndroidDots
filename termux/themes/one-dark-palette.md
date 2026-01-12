# One Dark Color Palette Reference

## Base16 Colors

| Name    | Hex       | Usage                          |
|---------|-----------|--------------------------------|
| base00  | `#282c34` | Default Background             |
| base01  | `#353b45` | Lighter Background             |
| base02  | `#3e4451` | Selection Background           |
| base03  | `#545862` | Comments, Invisibles           |
| base04  | `#565c64` | Dark Foreground                |
| base05  | `#abb2bf` | Default Foreground             |
| base06  | `#b6bdca` | Light Foreground               |
| base07  | `#c8ccd4` | Lightest Foreground            |
| base08  | `#e06c75` | Red - Variables, Tags          |
| base09  | `#d19a66` | Orange - Integers, Constants   |
| base0A  | `#e5c07b` | Yellow - Classes, Search       |
| base0B  | `#98c379` | Green - Strings                |
| base0C  | `#56b6c2` | Cyan - Support, Regex          |
| base0D  | `#61afef` | Blue - Functions, Methods      |
| base0E  | `#c678dd` | Magenta - Keywords             |
| base0F  | `#be5046` | Dark Red - Deprecated          |

## Terminal Colors

| Index | Name          | Hex       |
|-------|---------------|-----------|
| bg    | Background    | `#1e222a` |
| fg    | Foreground    | `#c8ccd4` |
| cursor| Cursor        | `#abb2bf` |

### Normal (0-7)

| Index | Color   | Hex       |
|-------|---------|-----------|
| 0     | Black   | `#282c34` |
| 1     | Red     | `#e06c75` |
| 2     | Green   | `#98c379` |
| 3     | Yellow  | `#e5c07b` |
| 4     | Blue    | `#61afef` |
| 5     | Magenta | `#c678dd` |
| 6     | Cyan    | `#56b6c2` |
| 7     | White   | `#abb2bf` |

### Bright (8-15)

| Index | Color          | Hex       |
|-------|----------------|-----------|
| 8     | Bright Black   | `#545862` |
| 9     | Bright Red     | `#e06c75` |
| 10    | Bright Green   | `#98c379` |
| 11    | Bright Yellow  | `#e5c07b` |
| 12    | Bright Blue    | `#61afef` |
| 13    | Bright Magenta | `#c678dd` |
| 14    | Bright Cyan    | `#56b6c2` |
| 15    | Bright White   | `#c8ccd4` |

## Quick Copy Formats

### CSS Variables
```css
:root {
  --bg: #1e222a;
  --fg: #c8ccd4;
  --cursor: #abb2bf;
  --black: #282c34;
  --red: #e06c75;
  --green: #98c379;
  --yellow: #e5c07b;
  --blue: #61afef;
  --magenta: #c678dd;
  --cyan: #56b6c2;
  --white: #abb2bf;
  --bright-black: #545862;
  --bright-white: #c8ccd4;
}
```

### JSON
```json
{
  "background": "#1e222a",
  "foreground": "#c8ccd4",
  "cursor": "#abb2bf",
  "color0": "#282c34",
  "color1": "#e06c75",
  "color2": "#98c379",
  "color3": "#e5c07b",
  "color4": "#61afef",
  "color5": "#c678dd",
  "color6": "#56b6c2",
  "color7": "#abb2bf",
  "color8": "#545862",
  "color9": "#e06c75",
  "color10": "#98c379",
  "color11": "#e5c07b",
  "color12": "#61afef",
  "color13": "#c678dd",
  "color14": "#56b6c2",
  "color15": "#c8ccd4"
}
```

### YAML
```yaml
colors:
  background: "#1e222a"
  foreground: "#c8ccd4"
  cursor: "#abb2bf"
  normal:
    black: "#282c34"
    red: "#e06c75"
    green: "#98c379"
    yellow: "#e5c07b"
    blue: "#61afef"
    magenta: "#c678dd"
    cyan: "#56b6c2"
    white: "#abb2bf"
  bright:
    black: "#545862"
    red: "#e06c75"
    green: "#98c379"
    yellow: "#e5c07b"
    blue: "#61afef"
    magenta: "#c678dd"
    cyan: "#56b6c2"
    white: "#c8ccd4"
```
