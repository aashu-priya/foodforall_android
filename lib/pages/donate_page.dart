import 'package:flutter/material.dart';
import 'package:food_for_all/services/donation_service.dart';

const Color kPrimaryColor = Color(0xFF014D4E);
const Color kSecondaryColor = Color(0xFFD5F4E6);
const Color kAccentColor = Color(0xFFFF6B6B);
const Color kHighlightColor = Color(0xFFF4A261);
const Color kTextColor = Color(0xFF555555);

String _formatDate(DateTime date) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}

class DonatePage extends StatefulWidget {
  const DonatePage({super.key});

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  final List<String> _foodCategories = [
    'Fruits',
    'Vegetables',
    'Dairy',
    'Bakery',
    'Grains',
    'Prepared Food',
    'Other'
  ];

  // Form data
  String _selectedCategory = 'Fruits';
  String _foodItemName = '';
  int _quantity = 1;
  DateTime _expiryDate = DateTime.now().add(const Duration(days: 3));
  String _packaging = '';
  String _specialInstructions = '';
  String _donorName = '';
  String _donorEmail = '';
  String _donorPhone = '';
  String _pickupAddress = '';
  bool _isDelivery = false;
  TimeOfDay _preferredTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donate Food'),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: kPrimaryColor),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: const TextStyle(color: kTextColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: kPrimaryColor),
            ),
          ),
        ),
        child: Form(
          key: _formKey,
          child: Stepper(
            currentStep: _currentStep,
            onStepContinue: _continue,
            onStepCancel: _cancel,
            onStepTapped: (step) => setState(() => _currentStep = step),
            controlsBuilder: (context, details) {
              return Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    if (_currentStep != 0)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kSecondaryColor,
                          foregroundColor: kTextColor,
                        ),
                        onPressed: details.onStepCancel,
                        child: const Text('Back'),
                      ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: details.onStepContinue,
                      child: Text(
                        _currentStep == 2 ? 'Submit Donation' : 'Next',
                      ),
                    ),
                  ],
                ),
              );
            },
            steps: [
              Step(
                title: const Text('Food Details'),
                content: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Food Category',
                        prefixIcon: const Icon(Icons.category, color: kPrimaryColor),
                      ),
                      items: _foodCategories
                          .map((category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              ))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedCategory = value!),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Food Item Name',
                      icon: Icons.fastfood,
                      onChanged: (value) => _foodItemName = value,
                      validatorMsg: 'Please enter food item name',
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: 'Quantity',
                            icon: Icons.format_list_numbered,
                            keyboardType: TextInputType.number,
                            initialValue: _quantity.toString(),
                            onChanged: (value) => _quantity = int.tryParse(value) ?? 1,
                            validatorMsg: 'Please enter quantity',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            controller: TextEditingController(
                              text: _formatDate(_expiryDate),
                            ),
                            decoration: InputDecoration(
                              labelText: 'Expiry Date',
                              prefixIcon: const Icon(Icons.calendar_today, color: kPrimaryColor),
                            ),
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _expiryDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 365)),
                              );
                              if (date != null) {
                                setState(() => _expiryDate = date);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Packaging Type',
                      icon: Icons.inventory,
                      onChanged: (value) => _packaging = value,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Special Instructions',
                      icon: Icons.note,
                      onChanged: (value) => _specialInstructions = value,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              Step(
                title: const Text('Pickup/Delivery'),
                content: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Delivery Required?'),
                      value: _isDelivery,
                      onChanged: (value) => setState(() => _isDelivery = value),
                      activeColor: kPrimaryColor,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Pickup/Delivery Address',
                      icon: Icons.location_on,
                      onChanged: (value) => _pickupAddress = value,
                      validatorMsg: 'Please enter address',
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.access_time, color: kPrimaryColor),
                      title: const Text('Preferred Time'),
                      subtitle: Text(_preferredTime.format(context)),
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: _preferredTime,
                        );
                        if (time != null) {
                          setState(() => _preferredTime = time);
                        }
                      },
                    ),
                  ],
                ),
              ),
              Step(
                title: const Text('Your Information'),
                content: Column(
                  children: [
                    _buildTextField(
                      label: 'Your Name',
                      icon: Icons.person,
                      onChanged: (value) => _donorName = value,
                      validatorMsg: 'Please enter your name',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Email Address',
                      icon: Icons.email,
                      onChanged: (value) => _donorEmail = value,
                      validatorMsg: 'Please enter your email',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Phone Number',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      onChanged: (value) => _donorPhone = value,
                      validatorMsg: 'Please enter your phone number',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    String? initialValue,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? validatorMsg,
    required void Function(String) onChanged,
  }) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: kPrimaryColor),
      ),
      validator: validatorMsg != null
          ? (value) => (value == null || value.isEmpty) ? validatorMsg : null
          : null,
      onChanged: onChanged,
    );
  }

  void _cancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    }
  }

  void _continue() async {
    bool isValid = true;

    if (_currentStep == 0 && (_foodItemName.isEmpty || _quantity <= 0)) {
      isValid = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete the food details')),
      );
    } else if (_currentStep == 1 && _pickupAddress.isEmpty) {
      isValid = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide pickup/delivery address')),
      );
    }

    if (!isValid) return;

    if (_currentStep == 2) {
      if (_formKey.currentState!.validate()) {
        final donationData = {
          'donor_name': _donorName,
          'donor_email': _donorEmail,
          'donor_phone': _donorPhone,
          'food_category': _selectedCategory,
          'food_item': _foodItemName,
          'quantity': _quantity,
          'expiry_date': _expiryDate.toIso8601String(),
          'packaging': _packaging,
          'special_instructions': _specialInstructions,
          'pickup_address': _pickupAddress,
          'is_delivery': _isDelivery,
          'preferred_time': _preferredTime.format(context),
        };

        try {
          await DonationService.submitDonation(donationData);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Thank you for your donation!'),
              backgroundColor: kPrimaryColor,
            ),
          );

          setState(() {
            _currentStep = 0;
            _selectedCategory = 'Fruits';
            _foodItemName = '';
            _quantity = 1;
            _expiryDate = DateTime.now().add(const Duration(days: 3));
            _packaging = '';
            _specialInstructions = '';
            _donorName = '';
            _donorEmail = '';
            _donorPhone = '';
            _pickupAddress = '';
            _isDelivery = false;
            _preferredTime = TimeOfDay.now();
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Submission failed. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      setState(() => _currentStep += 1);
    }
  }
}
