import 'package:flutter/material.dart';

/// The editable widget with User's info
class UserInfoCard extends StatefulWidget {
  const UserInfoCard({super.key, required this.editing, required this.userName, required this.userEmail});

  // True if User is in editing mode and their info can be edited
  final bool editing;
  final String userName;
  final String userEmail;

  @override
  State<StatefulWidget> createState() => _UserInfoCardState();
}

/// Stores the mutable data that can change over the lifetime of the UserInfoCard.
class _UserInfoCardState extends State<UserInfoCard> {
  
  // The global key uniquely identifies the Form widget and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  TextEditingController userNameController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    // Now that widget has the passed the User info, populate the controllers
    userNameController.text = widget.userName;
    userEmailController.text = widget.userEmail;

    final screenWidth = MediaQuery.of(context).size.width;
    double textFieldWidth = screenWidth * 0.75;
  
    return Container(
      // Card container
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black26, offset: Offset(2, 2), blurRadius: 10)
        ],
      ),
      child: 
        Form(
          key: _formKey,
          child: Column(children: <Widget>[

            Padding(
              // Name
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(Icons.account_box), 
                  ),
                  // Form field for editing profile mode
                  if (widget.editing)
                    SizedBox(
                      width: textFieldWidth,
                      child: TextFormField(
                        controller: userNameController,
                        maxLength: 25,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      )
                    ),
                  // Normal text if not editing profile
                  if (!widget.editing)
                    Text(
                      userNameController.text,
                      style: const TextStyle(fontSize: 20),
                    )
                ],
              ),
            ),

            // Email
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(Icons.email), 
                ),
                // Form field for editing profile mode
                if (widget.editing)
                  SizedBox(
                    width: textFieldWidth,
                    child: TextFormField(
                      controller: userEmailController,
                      maxLength: 25,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    )
                  ),
                // Normal text if not editing profile
                if (!widget.editing)
                  Text(
                    userEmailController.text,
                    style: const TextStyle(fontSize: 20),
                  )
              ],
            ),
          ])
        ),
    );
  }
}