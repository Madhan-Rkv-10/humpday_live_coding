
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: false),
      home: HomeScreen(),
    );
  }
}

class ContactData {
  const ContactData({
    required this.name,
    required this.address,
    required this.country,
    required this.phone,
  });

  final String name;
  final String address;
  final String country;
  final String phone;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final presenter = HomeScreenPresenter(context);

  @override
  void initState() {
    super.initState();
    presenter.init();
  }

  @override
  void dispose() {
    presenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
        actions: [
          IconButton(
            onPressed: presenter.onAddPressed,
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: ValueListenableBuilder<List<ContactData>>(
        valueListenable: presenter.addresses,
        builder: (BuildContext context, List<ContactData> value, Widget? child) {
          return ContactList(
            contacts: value,
            onEditContact: presenter.onEditPressed,
          );
        },
      ),
    );
  }
}

class HomeScreenPresenter {
  HomeScreenPresenter(this.context);

  final BuildContext context;

  late ValueNotifier<List<ContactData>> _addresses;

  ValueNotifier<List<ContactData>> get addresses => _addresses;

  void init() {
    _addresses = ValueNotifier([]);
  }

  void dispose() {
    _addresses.dispose();
  }

  Future<void> onAddPressed() async {
    final contact = await Navigator.of(context).push(
      AddContactScreen.route(),
    );
    if (contact != null) {
      addresses.value = UnmodifiableListView(
        [...addresses.value, contact],
      );
    }
  }

  Future<void> onEditPressed(ContactData contact) async {
    final newContact = await Navigator.of(context).push(
      EditContactScreen.route(contact),
    );
    if (newContact != null) {
      addresses.value = UnmodifiableListView(
        [...addresses.value.whereNot((el) => el == contact), newContact],
      );
    }
  }
}

class ContactList extends StatelessWidget {
  const ContactList({
    super.key,
    required this.contacts,
    required this.onEditContact,
  });

  final List<ContactData> contacts;
  final ValueChanged<ContactData> onEditContact;

  static final _newLines = RegExp(r'\s+');

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (BuildContext context, int index) {
        final contact = contacts[index];
        return ListTile(
          onTap: () => onEditContact(contact),
          title: Text(contact.name),
          subtitle: Text(contact.address.replaceAll(_newLines, ' ')),
        );
      },
    );
  }
}

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  static Route<ContactData> route() {
    return MaterialPageRoute(
      requestFocus: true,
      fullscreenDialog: true,
      builder: (BuildContext context) {
        return AddContactScreen();
      },
    );
  }

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _addressFormKey = GlobalKey<AddressFormState>();

  void _onSavePressed() {
    final contact = _addressFormKey.currentState!.save();
    if (contact != null) {
      Navigator.of(context).pop(contact);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Contact'),
      ),
      body: SizedBox.expand(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AddressForm(key: _addressFormKey),
              const SizedBox(height: 36.0),
              ElevatedButton(
                onPressed: _onSavePressed,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditContactScreen extends StatefulWidget {
  const EditContactScreen({
    super.key,
    required this.contact,
  });

  final ContactData contact;

  static Route<ContactData> route(ContactData contact) {
    return MaterialPageRoute(
      requestFocus: true,
      fullscreenDialog: true,
      builder: (BuildContext context) {
        return EditContactScreen(contact: contact);
      },
    );
  }

  @override
  State<EditContactScreen> createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  final _addressFormKey = GlobalKey<AddressFormState>();

  void _onSavePressed() {
    final contact = _addressFormKey.currentState!.save();
    if (contact != null) {
      Navigator.of(context).pop(contact);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Contact'),
      ),
      body: SizedBox.expand(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AddressForm(
                key: _addressFormKey,
                contact: widget.contact,
              ),
              const SizedBox(height: 36.0),
              ElevatedButton(
                onPressed: _onSavePressed,
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddressForm extends StatefulWidget {
  const AddressForm({
    super.key,
    this.contact,
  });

  final ContactData? contact;

  @override
  State<AddressForm> createState() => AddressFormState();
}

class AddressFormState extends State<AddressForm> {
  final _formKey = GlobalKey<FormState>();

  late String _name;
  late String _address;
  late String _country;
  late String _phone;

  @override
  void initState() {
    super.initState();
    _name = widget.contact?.name ?? '';
    _address = widget.contact?.address ?? '';
    _country = widget.contact?.country ?? '';
    _phone = widget.contact?.phone ?? '';
  }

  ContactData? save() {
    final form = _formKey.currentState!;
    if (form.validate() == false) {
      return null;
    }
    form.save();
    return ContactData(
      name: _name,
      address: _address,
      country: _country,
      phone: _phone,
    );
  }

  FormFieldValidator<String>? _fieldRequired(String fieldName) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return '$fieldName required';
      }
      return null;
    };
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            initialValue: _name,
            onSaved: (value) => _name = value!,
            validator: _fieldRequired('Name'),
            decoration: InputDecoration(
              labelText: 'Name',
            ),
          ),
          const SizedBox(height: 12.0),
          TextFormField(
            initialValue: _address,
            onSaved: (value) => _address = value!,
            validator: _fieldRequired('Address'),
            decoration: InputDecoration(
              labelText: 'Address',
            ),
          ),
          const SizedBox(height: 12.0),
          CountryFormField(
            initialValue: _country,
            onSaved: (value) => _country = value!,
            validator: _fieldRequired('Country'),
          ),
          const SizedBox(height: 12.0),
          TextFormField(
            initialValue: _phone,
            onSaved: (value) => _phone = value!,
            validator: _fieldRequired('Phone'),
            decoration: InputDecoration(
              labelText: 'Phone',
            ),
          ),
        ],
      ),
    );
  }
}

class CountryFormField extends FormField<String> {
  CountryFormField({
    super.key,
    super.initialValue,
    super.onSaved,
    super.validator,
  }) : super(
          builder: (FormFieldState<String> formFieldState) {
            return (formFieldState as _CountryFormFieldState)._builder();
          },
        );

  @override
  FormFieldState<String> createState() => _CountryFormFieldState();
}

class _CountryFormFieldState extends FormFieldState<String> {
  final countries = [
    'Algeria',
    'Czechia',
    'Korea',
    'Mexico',
    'United Kingdom',
    'United States',
    'Xanadu',
  ];

  Future<void> _showDialog() async {
    final data = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select assignment'),
          children: <Widget>[
            for (final country in countries) //
              SimpleDialogOption(
                onPressed: () => Navigator.of(context).pop(country),
                child: Text(country),
              ),
          ],
        );
      },
    );
    if (data != null) {
      setState(() {
        setValue(data);
      });
    }
  }

  Widget _builder() {
    return InkWell(
      onTap: _showDialog,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Country',
          errorText: errorText,
        ),
        isEmpty: value == null,
        child: Text(value ?? ''),
      ),
    );
  }
}
