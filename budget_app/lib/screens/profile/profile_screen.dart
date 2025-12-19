import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../core/widgets/custom_button.dart';
import '../../data/services/pdf_services.dart';
import '../../providers/auth_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/transaction_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User Info Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: AppStyles.cardDecoration,
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Center(
                      child: Text(
                        user?.name.substring(0, 1).toUpperCase() ?? 'U',
                        style: AppStyles.headline2.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'User Name',
                          style: AppStyles.headline3,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? 'user@email.com',
                          style: AppStyles.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Member since ${DateFormat('MMM yyyy').format(user?.createdAt ?? DateTime.now())}',
                          style: AppStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: _editProfile,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Export Data Card (New Section)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppStyles.cardDecoration,
              child: Column(
                children: [
                  _buildOptionItem(
                    icon: Icons.download_outlined,
                    title: 'Export Data',
                    onTap: _showExportDialog,
                  ),
                  const Divider(height: 24),
                  _buildOptionItem(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: _showHelpSupport,
                  ),
                  const Divider(height: 24),
                  _buildOptionItem(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    onTap: _showPrivacyPolicy,
                  ),
                  const Divider(height: 24),
                  _buildOptionItem(
                    icon: Icons.description_outlined,
                    title: 'Terms & Conditions',
                    onTap: _showTermsConditions,
                  ),
                  const Divider(height: 24),
                  _buildOptionItem(
                    icon: Icons.info_outline,
                    title: 'About App',
                    onTap: _showAboutApp,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Logout Button
            CustomButton(
              text: 'Logout',
              onPressed: _logout,
              backgroundColor: AppColors.error,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: AppStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textLight),
        ],
      ),
    );
  }

  void _editProfile() {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.user;
    final nameController = TextEditingController(text: user?.name ?? '');
    final emailController = TextEditingController(text: user?.email ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Container(
            padding: const EdgeInsets.only(bottom: 16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.border,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.person_outline,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Edit Profile',
                  style: AppStyles.headline3,
                ),
              ],
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Icon
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Center(
                      child: Text(
                        user?.name.substring(0, 1).toUpperCase() ?? 'U',
                        style: AppStyles.headline2.copyWith(
                          color: Colors.white,
                          fontSize: 32,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Name Field
                Text(
                  'Name',
                  style: AppStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextFormField(
                    controller: nameController,
                    style: AppStyles.bodyLarge,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.person_outline_rounded,
                        color: AppColors.primary,
                      ),
                      hintText: 'Enter your name',
                      hintStyle: AppStyles.bodyMedium.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Email Field
                Text(
                  'Email',
                  style: AppStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextFormField(
                    controller: emailController,
                    style: AppStyles.bodyLarge,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: AppColors.primary,
                      ),
                      hintText: 'Enter your email',
                      hintStyle: AppStyles.bodyMedium.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: Text(
                'Cancel',
                style: AppStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Save Button
            ElevatedButton(
              onPressed: () async {
                // Basic validation
                if (nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter your name'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                  return;
                }

                if (emailController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter your email'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                  return;
                }

                // Update profile
                await authProvider.updateProfile(
                  nameController.text,
                  emailController.text,
                );

                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile updated successfully'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Save Changes',
                style: AppStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAboutApp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Budget Buddy'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Budget Buddy v1.0.0',
                style: AppStyles.headline3.copyWith(
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Your Personal Finance Companion',
                style: AppStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Budget Buddy helps you take control of your finances with easy expense tracking, budgeting tools, and financial insights.',
                style: AppStyles.bodyMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'Features:',
                style: AppStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _buildFeatureItem('📊 Track income and expenses'),
              _buildFeatureItem('🎯 Set and monitor budgets'),
              _buildFeatureItem('📈 View detailed reports'),
              _buildFeatureItem('🔔 Get spending alerts'),
              _buildFeatureItem('📱 Sync across devices'),
              const SizedBox(height: 16),
              Text(
                'Contact us: support@budgetbuddy.app',
                style: AppStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Last Updated: ${DateFormat('dd MMM, yyyy').format(DateTime.now())}',
                style: AppStyles.bodySmall,
              ),
              const SizedBox(height: 16),
              Text(
                '1. Information We Collect',
                style: AppStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '• Account information (name, email)\n'
                    '• Financial data (transactions, budgets)\n'
                    '• Device information for app improvement',
                style: AppStyles.bodyMedium,
              ),
              const SizedBox(height: 12),
              Text(
                '2. How We Use Your Data',
                style: AppStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '• To provide and improve Budget Buddy services\n'
                    '• To generate financial reports\n'
                    '• To send important notifications\n'
                    '• For security and fraud prevention',
                style: AppStyles.bodyMedium,
              ),
              const SizedBox(height: 12),
              Text(
                '3. Data Security',
                style: AppStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'We use industry-standard encryption to protect your data. Your financial information is stored securely and never shared without your consent.',
                style: AppStyles.bodyMedium,
              ),
              const SizedBox(height: 12),
              Text(
                '4. Your Rights',
                style: AppStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You can:\n'
                    '• Access your data anytime\n'
                    '• Request data deletion\n'
                    '• Update your preferences\n'
                    '• Contact us with questions',
                style: AppStyles.bodyMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'For questions: privacy@budgetbuddy.app',
                style: AppStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTermsConditions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Use'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'By using Budget Buddy, you agree to these Terms of Use.',
                style: AppStyles.bodyMedium,
              ),
              const SizedBox(height: 16),
              Text(
                '1. Account Terms',
                style: AppStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You must provide accurate information when creating an account. You are responsible for keeping your login credentials secure.',
                style: AppStyles.bodyMedium,
              ),
              const SizedBox(height: 12),
              Text(
                '2. App Usage',
                style: AppStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Budget Buddy is intended for personal financial management. You agree to use the app for lawful purposes only.',
                style: AppStyles.bodyMedium,
              ),
              const SizedBox(height: 12),
              Text(
                '3. Data Accuracy',
                style: AppStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'While we strive for accuracy, Budget Buddy provides financial tools and insights, not professional financial advice.',
                style: AppStyles.bodyMedium,
              ),
              const SizedBox(height: 12),
              Text(
                '4. Service Availability',
                style: AppStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'We aim to provide continuous service but may occasionally need to perform maintenance or updates.',
                style: AppStyles.bodyMedium,
              ),
              const SizedBox(height: 12),
              Text(
                '5. Updates to Terms',
                style: AppStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'We may update these terms. Continued use of the app means you accept any changes.',
                style: AppStyles.bodyMedium,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHelpSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help Center'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'How can we help you today?',
                style: AppStyles.bodyMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'Getting Started',
                style: AppStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '1. Add your first transaction from the dashboard\n'
                    '2. Create categories for your expenses\n'
                    '3. Set monthly budgets for each category\n'
                    '4. Check reports to see your spending patterns',
                style: AppStyles.bodyMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'Common Questions',
                style: AppStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Q: How do I edit a transaction?\n'
                    'A: Go to Transactions, find the transaction, and tap Edit.\n\n'
                    'Q: Can I delete my account?\n'
                    'A: Contact support to request account deletion.\n\n'
                    'Q: Is my data backed up?\n'
                    'A: Yes, your data is securely stored in the cloud.',
                style: AppStyles.bodyMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'Contact Support',
                style: AppStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Email: help@budgetbuddyapp.com\n'
                    'Response time: 24-48 hours',
                style: AppStyles.bodyMedium,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                Icons.picture_as_pdf_rounded,
                color: AppColors.primary,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Generate PDF Report',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create a PDF of your financial data',
              style: AppStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _generatePdfReport();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Generate PDF'),
          ),
        ],
      ),
    );
  }

  Future<void> _generatePdfReport() async {
    final authProvider = context.read<AuthProvider>();
    final transactionProvider = context.read<TransactionProvider>();
    final categoryProvider = context.read<CategoryProvider>();

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  'Generating PDF...',
                  style: AppStyles.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      // Prepare data
      final user = authProvider.user!;
      final transactions = transactionProvider.transactions;

      // Get recent transactions (last 10)
      final recentTransactions = transactionProvider
          .getRecentTransactions(count: 10)
          .map((transaction) {
        final category = categoryProvider.getCategoryById(transaction.categoryId);
        return {
          'date': transaction.date,
          'category': category?.name ?? transaction.categoryName,
          'amount': transaction.amount,
          'isIncome': transaction.isIncome,
        };
      }).toList();

      // Get category spending - FIXED VERSION
      final categories = categoryProvider.categories;
      final List<Map<String, dynamic>> categorySpending = [];

      for (final category in categories) {
        final categoryTransactions = transactions
            .where((t) => t.categoryId == category.id && t.isExpense)
            .toList();

        final total = categoryTransactions.fold(
            0.0,
                (double sum, transaction) => sum + transaction.amount
        );

        // Only add if amount is greater than 0
        if (total > 0) {
          categorySpending.add({
            'name': category.name,
            'amount': total, // This is now a double, not Object
          });
        }
      }

      // Generate PDF bytes
      final pdfBytes = await PdfService.generatePdf(
        userName: user.name,
        userEmail: user.email,
        totalIncome: transactionProvider.getTotalIncome(),
        totalExpenses: transactionProvider.getTotalExpenses(),
        balance: transactionProvider.getBalance(),
        transactions: recentTransactions,
        categorySpending: categorySpending,
      );

      // Close loading dialog
      if (mounted) {
        Navigator.pop(context);
      }

      // Preview PDF
      await PdfService.previewPdf(pdfBytes);

    } catch (e) {
      // Close loading dialog
      if (mounted) {
        Navigator.pop(context);
      }

      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to generate PDF: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final authProvider = context.read<AuthProvider>();
      await authProvider.logout();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }
}