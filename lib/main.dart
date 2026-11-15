import 'package:flutter/material.dart';

void main() => runApp(const NexoraApp());

const navy = Color(0xFF0B1220);
const panel = Color(0xFF151F30);
const blue = Color(0xFF4D8DFF);
const muted = Color(0xFF9BA9BD);
const green = Color(0xFF36C995);
const amber = Color(0xFFFFC66D);

class NexoraApp extends StatefulWidget {
  const NexoraApp({super.key});
  @override
  State<NexoraApp> createState() => _NexoraAppState();
}

class _NexoraAppState extends State<NexoraApp> {
  bool arabic = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NEXORA',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: navy,
        colorScheme: const ColorScheme.dark(primary: blue, surface: panel),
        useMaterial3: true,
        cardTheme: CardThemeData(
          color: panel,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: panel,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: Directionality(
        textDirection: arabic ? TextDirection.rtl : TextDirection.ltr,
        child: NexoraHome(
          arabic: arabic,
          onLanguage: () => setState(() => arabic = !arabic),
        ),
      ),
    );
  }
}

class DemoLoan {
  final String asset;
  final double collateralAmount;
  final double collateralValue;
  final double principal;
  final double ltv;
  final double apr;
  final int days;
  final double interest;
  final double total;

  const DemoLoan({
    required this.asset,
    required this.collateralAmount,
    required this.collateralValue,
    required this.principal,
    required this.ltv,
    required this.apr,
    required this.days,
    required this.interest,
    required this.total,
  });
}

class NexoraHome extends StatefulWidget {
  final bool arabic;
  final VoidCallback onLanguage;
  const NexoraHome({super.key, required this.arabic, required this.onLanguage});

  @override
  State<NexoraHome> createState() => _NexoraHomeState();
}

class _NexoraHomeState extends State<NexoraHome> {
  int tab = 0;
  String asset = 'BTC';
  double collateral = 0.10;
  double ltv = 50;
  double apr = 12;
  int days = 90;
  final List<DemoLoan> loans = [];

  double get price => const {'BTC': 65000.0, 'ETH': 3200.0, 'USDT': 1.0}[asset]!;
  double get collateralValue => collateral * price;
  double get principal => collateralValue * ltv / 100;
  double get interest => principal * (apr / 100) * days / 365;
  double get totalDue => principal + interest;
  double get minCollateral => asset == 'USDT' ? 100 : 0.001;
  double get maxCollateral => asset == 'BTC' ? 2 : asset == 'ETH' ? 20 : 10000;
  double get step => asset == 'USDT' ? 50 : asset == 'BTC' ? 0.001 : 0.01;

  String t(String en, String ar) => widget.arabic ? ar : en;
  String money(double value) => '\$${value.toStringAsFixed(2)}';
  String amount(double value) => asset == 'USDT' ? value.toStringAsFixed(0) : value.toStringAsFixed(asset == 'BTC' ? 4 : 3);

  void changeAsset(String next) {
    setState(() {
      asset = next;
      collateral = next == 'USDT' ? 1000 : next == 'BTC' ? 0.10 : 1;
    });
  }

  void createDemoLoan() {
    setState(() {
      loans.insert(
        0,
        DemoLoan(
          asset: asset,
          collateralAmount: collateral,
          collateralValue: collateralValue,
          principal: principal,
          ltv: ltv,
          apr: apr,
          days: days,
          interest: interest,
          total: totalDue,
        ),
      );
      tab = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [_dashboard(), _borrow(), _loans(), _profile()];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: navy,
        title: const Row(
          children: [
            Text('NEXORA', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2)),
            SizedBox(width: 8),
            Icon(Icons.bubble_chart, color: blue),
          ],
        ),
        actions: [
          TextButton(onPressed: widget.onLanguage, child: Text(widget.arabic ? 'EN' : 'عربي')),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(child: IndexedStack(index: tab, children: pages)),
      bottomNavigationBar: NavigationBar(
        backgroundColor: panel,
        indicatorColor: blue.withOpacity(.2),
        selectedIndex: tab,
        onDestinationSelected: (value) => setState(() => tab = value),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.grid_view_rounded), label: t('Home', 'الرئيسية')),
          NavigationDestination(icon: const Icon(Icons.add_card_rounded), label: t('Borrow', 'اقترض')),
          NavigationDestination(icon: const Icon(Icons.account_balance_wallet_outlined), label: t('My loans', 'قروضي')),
          NavigationDestination(icon: const Icon(Icons.person_outline), label: t('Profile', 'حسابي')),
        ],
      ),
    );
  }

  Widget _dashboard() => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF18345B), Color(0xFF172235)]),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t('GLOBAL CRYPTO COLLATERAL', 'قروض بضمان الأصول الرقمية'), style: const TextStyle(color: Color(0xFFB9D1F8), fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text(t('Your assets.\nYour liquidity.', 'أصولك الرقمية.\nوسيلتك للسيولة.'), style: const TextStyle(fontSize: 29, fontWeight: FontWeight.bold, height: 1.2)),
                const SizedBox(height: 18),
                FilledButton.icon(onPressed: () => setState(() => tab = 1), icon: const Icon(Icons.arrow_forward), label: Text(t('Calculate a loan', 'احسب قرضك'))),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Text(t('Illustrative market prices', 'أسعار سوق افتراضية'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _assetTile('BTC', 'Bitcoin', '\$65,000', Icons.currency_bitcoin)),
            const SizedBox(width: 9),
            Expanded(child: _assetTile('ETH', 'Ethereum', '\$3,200', Icons.diamond_outlined)),
            const SizedBox(width: 9),
            Expanded(child: _assetTile('USDT', 'Tether', '\$1.00', Icons.attach_money)),
          ]),
          const SizedBox(height: 22),
          Text(t('How it works', 'كيف يعمل التطبيق'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          _step('01', t('Choose collateral', 'اختر الضمان'), t('Select BTC, ETH or USDT.', 'اختر BTC أو ETH أو USDT.')),
          _step('02', t('Review your LTV', 'راجع نسبة القرض'), t('Estimate borrowing power and interest.', 'احسب مبلغ القرض والفائدة التقديرية.')),
          _step('03', t('Track your position', 'تابع مركزك'), t('Review simulated loan details.', 'راجع تفاصيل القرض التجريبي.')),
          const SizedBox(height: 12),
          _notice(),
        ],
      );

  Widget _assetTile(String ticker, String name, String value, IconData icon) => Card(
        child: Padding(
          padding: const EdgeInsets.all(11),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(icon, color: blue),
            const SizedBox(height: 9),
            Text(ticker, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(name, style: const TextStyle(color: muted, fontSize: 10)),
            const SizedBox(height: 7),
            FittedBox(child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold))),
          ]),
        ),
      );

  Widget _step(String number, String title, String description) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(backgroundColor: blue.withOpacity(.15), child: Text(number, style: const TextStyle(color: blue, fontWeight: FontWeight.bold))),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(description, style: const TextStyle(color: muted)),
      );

  Widget _notice() => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: const Color(0xFF382D19), borderRadius: BorderRadius.circular(14)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.info_outline, color: amber),
          const SizedBox(width: 10),
          Expanded(child: Text(t(
            'DEMO ONLY: No real assets, deposits, loans or transfers. Prices, rates and calculations are illustrative and are not financial offers.',
            'نسخة تجريبية فقط: لا توجد أصول أو إيداعات أو قروض أو تحويلات حقيقية. الأسعار والفوائد والحسابات افتراضية وليست عرضًا ماليًا.',
          ))),
        ]),
      );

  Widget _borrow() => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(t('Loan calculator', 'حاسبة القروض'), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(t('Estimate borrowing power using crypto collateral.', 'احسب قيمة القرض التقديرية بضمان العملات الرقمية.'), style: const TextStyle(color: muted)),
          const SizedBox(height: 20),
          _label(t('Collateral asset', 'عملة الضمان')),
          DropdownButtonFormField<String>(
            value: asset,
            dropdownColor: panel,
            decoration: const InputDecoration(),
            items: ['BTC', 'ETH', 'USDT'].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
            onChanged: (value) { if (value != null) changeAsset(value); },
          ),
          const SizedBox(height: 18),
          _label(t('Collateral amount', 'كمية الضمان')),
          Text('${amount(collateral)} $asset', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Slider(
            value: collateral.clamp(minCollateral, maxCollateral).toDouble(),
            min: minCollateral,
            max: maxCollateral,
            divisions: ((maxCollateral - minCollateral) / step).round().clamp(1, 1000).toInt(),
            onChanged: (value) => setState(() => collateral = value),
          ),
          const SizedBox(height: 8),
          _label(t('Loan-to-value (LTV)', 'نسبة القرض إلى قيمة الضمان')),
          Text('${ltv.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Slider(value: ltv, min: 10, max: 70, divisions: 12, onChanged: (value) => setState(() => ltv = value)),
          const SizedBox(height: 8),
          _label(t('Annual interest rate (demo)', 'الفائدة السنوية (تجريبية)')),
          Text('${apr.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Slider(value: apr, min: 4, max: 24, divisions: 20, onChanged: (value) => setState(() => apr = value)),
          const SizedBox(height: 8),
          _label(t('Loan term', 'مدة القرض')),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 30, label: Text('30d')),
              ButtonSegment(value: 90, label: Text('90d')),
              ButtonSegment(value: 180, label: Text('180d')),
            ],
            selected: {days},
            onSelectionChanged: (selection) => setState(() => days = selection.first),
          ),
          const SizedBox(height: 18),
          _summaryCard(),
          const SizedBox(height: 14),
          if (asset == 'USDT') _stablecoinNote(),
          FilledButton.icon(onPressed: createDemoLoan, icon: const Icon(Icons.add), label: Text(t('Create demo loan', 'إنشاء قرض تجريبي'))),
          const SizedBox(height: 12),
          _notice(),
        ],
      );

  Widget _summaryCard() => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(20), border: Border.all(color: blue.withOpacity(.35))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t('ESTIMATED LOAN VALUE', 'قيمة القرض التقديرية'), style: const TextStyle(color: muted, fontSize: 11, letterSpacing: 1)),
          const SizedBox(height: 8),
          Text(money(principal), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white)),
          const Divider(height: 26),
          _kv(t('Collateral value', 'قيمة الضمان'), money(collateralValue)),
          _kv(t('Illustrative asset price', 'سعر العملة الافتراضي'), money(price)),
          _kv(t('LTV', 'نسبة القرض'), '${ltv.toStringAsFixed(0)}%'),
          _kv(t('Estimated interest', 'الفائدة التقديرية'), money(interest)),
          _kv(t('Loan term', 'مدة القرض'), '$days ${t('days', 'يومًا')}'),
          const Divider(height: 24),
          _kv(t('Estimated total due', 'إجمالي المبلغ المستحق'), money(totalDue), emphasize: true),
          const SizedBox(height: 12),
          _riskIndicator(),
        ]),
      );

  Widget _riskIndicator() {
    final risky = ltv >= 65;
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(color: (risky ? amber : green).withOpacity(.10), borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Icon(risky ? Icons.warning_amber_rounded : Icons.verified_outlined, color: risky ? amber : green),
        const SizedBox(width: 9),
        Expanded(child: Text(t(risky ? 'Illustrative elevated LTV risk' : 'Illustrative LTV range: moderate', risky ? 'مستوى مخاطر افتراضي مرتفع لنسبة القرض' : 'مستوى مخاطر افتراضي متوسط لنسبة القرض'), style: TextStyle(color: risky ? amber : green, fontWeight: FontWeight.w600))),
      ]),
    );
  }

  Widget _stablecoinNote() => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF26334A), borderRadius: BorderRadius.circular(12)),
        child: Text(t(
          'USDT is shown as collateral in this prototype. A production product must clearly define a different borrow asset or a valid use case before offering a USDT-against-USDT loan.',
          'يظهر USDT هنا كضمان في النموذج التجريبي. قبل الإطلاق الحقيقي يجب تحديد أصل اقتراض مختلف أو مبرر اقتصادي واضح لقرض بضمان USDT.',
        ), style: const TextStyle(color: Color(0xFFD7E3F5), fontSize: 12)),
      );

  Widget _label(String value) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600)));

  Widget _kv(String key, String value, {bool emphasize = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(child: Text(key, style: TextStyle(color: emphasize ? Colors.white : muted, fontWeight: emphasize ? FontWeight.bold : FontWeight.normal))),
          const SizedBox(width: 12),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: emphasize ? green : Colors.white, fontSize: emphasize ? 16 : 14)),
        ]),
      );

  Widget _loans() => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(t('My loans', 'قروضي'), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(t('Your simulated loan activity.', 'سجل القروض التجريبية.'), style: const TextStyle(color: muted)),
          const SizedBox(height: 16),
          if (loans.isEmpty)
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(18)),
              child: Column(children: [
                const Icon(Icons.receipt_long, size: 42, color: muted),
                const SizedBox(height: 12),
                Text(t('No loans yet', 'لا توجد قروض حتى الآن'), style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(t('Create a demo loan from the calculator.', 'أنشئ قرضًا تجريبيًا من الحاسبة.'), style: const TextStyle(color: muted)),
                const SizedBox(height: 14),
                OutlinedButton(onPressed: () => setState(() => tab = 1), child: Text(t('Open calculator', 'افتح الحاسبة'))),
              ]),
            )
          else
            ...loans.map(_loanCard),
          const SizedBox(height: 16),
          _notice(),
        ],
      );

  Widget _loanCard(DemoLoan loan) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const CircleAvatar(backgroundColor: Color(0xFF20385A), child: Icon(Icons.lock_outline, color: blue)),
              const SizedBox(width: 10),
              Expanded(child: Text('${money(loan.principal)} USDT', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17))),
              const Chip(label: Text('DEMO', style: TextStyle(fontSize: 10))),
            ]),
            const Divider(height: 22),
            _kv(t('Collateral', 'الضمان'), '${loan.collateralAmount.toStringAsFixed(loan.asset == 'USDT' ? 0 : 4)} ${loan.asset}'),
            _kv(t('Collateral value', 'قيمة الضمان'), money(loan.collateralValue)),
            _kv(t('LTV', 'نسبة القرض'), '${loan.ltv.toStringAsFixed(0)}%'),
            _kv(t('Term', 'المدة'), '${loan.days} ${t('days', 'يوم')}'),
            _kv(t('Interest', 'الفائدة'), money(loan.interest)),
            _kv(t('Total due', 'إجمالي المستحق'), money(loan.total), emphasize: true),
          ]),
        ),
      );

  Widget _profile() => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(t('Profile & settings', 'الحساب والإعدادات'), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 18),
          const Center(child: CircleAvatar(radius: 34, backgroundColor: Color(0xFF20385A), child: Icon(Icons.person, size: 34, color: blue))),
          const SizedBox(height: 12),
          Center(child: Text(t('Demo user', 'مستخدم تجريبي'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
          const SizedBox(height: 24),
          Card(child: ListTile(leading: const Icon(Icons.language, color: blue), title: Text(t('Language', 'اللغة')), subtitle: Text(widget.arabic ? 'العربية' : 'English'), trailing: TextButton(onPressed: widget.onLanguage, child: Text(t('Change', 'تغيير'))))),
          Card(child: ListTile(leading: const Icon(Icons.shield_outlined, color: blue), title: Text(t('Security', 'الأمان')), subtitle: Text(t('Demo mode — no wallet keys stored', 'وضع تجريبي — لا يتم حفظ مفاتيح المحافظ')))),
          Card(child: ListTile(leading: const Icon(Icons.description_outlined, color: blue), title: Text(t('Legal & risk disclosures', 'الإفصاحات القانونية والمخاطر')), subtitle: Text(t('Review before any real-money launch', 'تجب المراجعة قبل الإطلاق بأموال حقيقية')))),
          const SizedBox(height: 16),
          _notice(),
        ],
      );
}
