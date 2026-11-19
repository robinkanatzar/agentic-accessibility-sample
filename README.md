# Kettle & Crumb

A small café ordering app for iOS, built with SwiftUI and a little UIKit.

This is the sample project for the book *Agentic Accessibility on iOS* by Robin Kanatzar.

## Requirements

- Xcode 27 or later
- iOS 27 simulator or device

## Branches

- `main`: the starting point used throughout the book.
- `solution`: the finished version (coming with the book).

## Running the app

1. Open `KettleAndCrumb.xcodeproj` in Xcode.
2. Choose an iOS 27 simulator.
3. Press Run.

There is no backend and no account to set up. The menu, the rewards history and the order progress are sample data, and checkout never takes a payment. Any 16-digit card number works, and the promo code `CRUMB10` takes 10% off.

## What is in the app

- **Home:** current offers, shortcuts and a short video about how the coffee is roasted.
- **Menu:** drinks and bakes by category, with dietary filters.
- **Item detail:** size, milk and quantity options, and favourites.
- **Cart:** line items, promo codes and totals.
- **Checkout:** pickup time and card details (built with UIKit).
- **Order status:** live progress from received to ready.
- **Rewards:** points balance, a six-month chart and recent activity.
