# NEXORA — Android MVP source

Bilingual (English/Arabic) Flutter prototype for a crypto-collateral loan simulator.

## Included in this iteration
- Dark premium dashboard and bottom navigation
- English/Arabic language toggle with RTL/LTR layout
- BTC / ETH / USDT collateral selector with asset-specific amount ranges
- Illustrative LTV calculator
- Configurable demo APR and 30/90/180-day terms
- Estimated simple interest and total repayment calculation
- Illustrative LTV risk indicator
- Create and view simulated loan records in app memory
- Clear demo-only and stablecoin-collateral disclosures

## Calculation model
- Collateral value = collateral quantity × illustrative asset price
- Principal = collateral value × LTV
- Simple interest = principal × annual rate × (term days / 365)
- Estimated total due = principal + simple interest

The sample prices are hard-coded solely for interface testing: BTC $65,000, ETH $3,200, USDT $1. They are not live market prices, quotes, or financial offers. The interest and LTV settings are illustrative and are not approved lending terms.

## Important limitations
This is a local UI and calculation prototype only. It does not authenticate users, connect wallets, custody assets, accept deposits, issue real loans, process repayments, fetch live prices, or execute blockchain transactions. Simulated loan records are held in memory and reset when the app restarts.

Do not deploy real-money functionality without jurisdiction-specific legal review, appropriate licensing and compliance, security audits, custody design, oracle validation, liquidation controls, and compliant liquidity providers.

## Run locally
1. Install Flutter SDK and Android Studio.
2. From this folder run `flutter create .` to generate the Android platform project.
3. Run `flutter pub get`.
4. Run `flutter run` with an Android emulator or device.
5. After testing, build a release APK with `flutter build apk --release`.

The current authoring environment does not have the Flutter SDK, so this source has not been compiled or device-tested here.

## Supabase schema starter
A demo-only SQL schema is included at `supabase/schema.sql`. It stores per-user simulation records with Row Level Security. It is not a production lending ledger and must not be used to custody collateral or settle real loans. Apply it only to a development Supabase project after enabling Supabase Auth.
