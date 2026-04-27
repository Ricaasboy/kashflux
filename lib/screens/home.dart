import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import '../services/home_service.dart';
import '../services/secure_storage_service.dart';
import '../services/scheduled_operation_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = true;

  double balance = 0;
  double income = 0;
  double expenses = 0;

  List categories = [];
  List operations = [];

  @override
  void initState() {
    super.initState();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    await ScheduledOperationService.processScheduledOperations();

    final email = await SecureStorageService.getEmail();

    if (email == null || email.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final result = await HomeService.getHomeData(email: email);

    if (!mounted) return;

    if (result['success'] == true) {
      setState(() {
        balance = double.parse(result['balance'].toString());
        income = double.parse(result['income'].toString());
        expenses = double.parse(result['expenses'].toString());
        categories = result['categories'] ?? [];
        operations = result['last_operations'] ?? [];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  String money(double value) {
    return '€ ${value.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/imgs/mini_logo.png',
          height: 30,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Available Balance',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      money(balance),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _miniCard(
                            title: 'Income',
                            value: money(income),
                            icon: Icons.arrow_upward,
                            iconColor: const Color(0xFF4CAF50),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _miniCard(
                            title: 'Expenses',
                            value: money(expenses),
                            icon: Icons.arrow_downward,
                            iconColor: const Color(0xFFE53935),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _categoryExpenseCard(),
              const SizedBox(height: 20),
              const Text(
                'Last Operations',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 160,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  primary: false,
                  physics: const BouncingScrollPhysics(),
                  itemCount: operations.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 12);
                  },
                  itemBuilder: (context, index) {
                    final operation = operations[index];
                    final type = operation['type'].toString();
                    final amount = double.parse(operation['amount'].toString());
                    final isIncome = type == 'income';

                    return _OperationCard(
                      title: operation['title'].toString(),
                      amount: '${isIncome ? '+' : '-'} ${money(amount)}',
                      date: operation['date'].toString(),
                      icon: isIncome
                          ? Icons.arrow_downward
                          : Icons.shopping_cart,
                      iconColor: isIncome
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFE53935),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00C853),
        onPressed: () {
          Navigator.pushNamed(context, '/add-operation');
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _miniCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: iconColor.withOpacity(0.18),
            child: Icon(
              icon,
              color: iconColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryExpenseCard() {
    final colors = [
      const Color(0xFFFF9800),
      const Color(0xFF8BC34A),
      const Color(0xFF3F51B5),
      const Color(0xFF9E9E9E),
      const Color(0xFFE53935),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Expenses by Category',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          if (categories.isEmpty)
            const Text(
              'No expenses yet',
              style: TextStyle(color: Colors.black54),
            )
          else
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: SizedBox(
                    height: 140,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 3,
                        centerSpaceRadius: 28,
                        sections: List.generate(categories.length, (index) {
                          final item = categories[index];
                          final total = double.parse(item['total'].toString());

                          return PieChartSectionData(
                            value: total,
                            color: colors[index % colors.length],
                            title: '',
                            radius: 18,
                          );
                        }),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(categories.length, (index) {
                      final item = categories[index];
                      final total = double.parse(item['total'].toString());

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _CategoryLegendItem(
                          color: colors[index % colors.length],
                          title: item['category'].toString(),
                          value: money(total),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _CategoryLegendItem extends StatelessWidget {
  final Color color;
  final String title;
  final String value;

  const _CategoryLegendItem({
    required this.color,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.redAccent,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _OperationCard extends StatelessWidget {
  final String title;
  final String amount;
  final String date;
  final IconData icon;
  final Color iconColor;

  const _OperationCard({
    required this.title,
    required this.amount,
    required this.date,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isIncome = amount.trim().startsWith('+');

    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: iconColor.withOpacity(0.15),
            child: Icon(
              icon,
              color: iconColor,
              size: 18,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            date,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            amount,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isIncome
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFFE53935),
            ),
          ),
        ],
      ),
    );
  }
}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}