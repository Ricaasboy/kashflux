import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_navbar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/imgs/mini_logo.png',
          height: 30,
        ),
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
                    const Text(
                      '€ 5,480.35',
                      style: TextStyle(
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
                            value: '€ 2,000',
                            icon: Icons.arrow_upward,
                            iconColor: const Color(0xFF4CAF50),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _miniCard(
                            title: 'Expenses',
                            value: '€ 750',
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
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  children: const [
                    _OperationCard(
                      title: 'Salary',
                      amount: '+ €2,000',
                      date: 'Today',
                      icon: Icons.arrow_downward,
                      iconColor: Color(0xFF4CAF50),
                    ),
                    SizedBox(width: 12),
                    _OperationCard(
                      title: 'Supermarket',
                      amount: '- €50',
                      date: 'Today',
                      icon: Icons.shopping_cart,
                      iconColor: Color(0xFFE53935),
                    ),
                    SizedBox(width: 12),
                    _OperationCard(
                      title: 'Transport',
                      amount: '- €15',
                      date: 'Yesterday',
                      icon: Icons.directions_bus,
                      iconColor: Color(0xFFE53935),
                    ),
                    SizedBox(width: 12),
                    _OperationCard(
                      title: 'Freelance',
                      amount: '+ €320',
                      date: 'Sep 12',
                      icon: Icons.work,
                      iconColor: Color(0xFF4CAF50),
                    ),
                    SizedBox(width: 12),
                    _OperationCard(
                      title: 'Restaurant',
                      amount: '- €22',
                      date: 'Sep 11',
                      icon: Icons.restaurant,
                      iconColor: Color(0xFFE53935),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavbar(currentIndex: 0),
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
                      sections: [
                        PieChartSectionData(
                          value: 35,
                          color: const Color(0xFFFF9800),
                          title: '',
                          radius: 18,
                        ),
                        PieChartSectionData(
                          value: 25,
                          color: const Color(0xFF8BC34A),
                          title: '',
                          radius: 18,
                        ),
                        PieChartSectionData(
                          value: 20,
                          color: const Color(0xFF3F51B5),
                          title: '',
                          radius: 18,
                        ),
                        PieChartSectionData(
                          value: 20,
                          color: const Color(0xFF9E9E9E),
                          title: '',
                          radius: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CategoryLegendItem(
                      color: Color(0xFFFF9800),
                      title: 'Housing',
                      value: '€ 350.00',
                    ),
                    SizedBox(height: 10),
                    _CategoryLegendItem(
                      color: Color(0xFF8BC34A),
                      title: 'Transport',
                      value: '€ 180.00',
                    ),
                    SizedBox(height: 10),
                    _CategoryLegendItem(
                      color: Color(0xFF3F51B5),
                      title: 'Food',
                      value: '€ 275.00',
                    ),
                    SizedBox(height: 10),
                    _CategoryLegendItem(
                      color: Color(0xFF9E9E9E),
                      title: 'Other',
                      value: '€ 110.00',
                    ),
                  ],
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