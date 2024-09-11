# CHANGELOG.md

## 0.2.0

Added:
- Subcategory context items implementation
- Add search on transaction page
- Dynamic colors

Updated:
- Rebuilt transaction filters to allow multiple selections and improve ui
- Migrate to Nunito Sans font
- Colors revamp

Fixed:
- Small async fixes

## 0.1.0

Added:
- CHANGELOG
- Budget page sync with current month/year in range
- Tabs on account page
- Existing budget is editable
- Implement archive and delete operations for subcategories
- Category type switch

Updated:
- Replace count with builder mode on budget page
- Subcategory choice in transaction numpad can de unchecked
- Only non-archived subcategories are shown in transaction numpad
- Replace money2 library to own implementation
- Replace realm to sqlflite

Fixed:
- Progress indicator on budget page
