import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

/// The editable widget with User's info
class UserInfoCard extends StatefulWidget {
  const UserInfoCard({
    super.key, 
    required this.editing, 
    required this.userName, 
    required this.userEmail, 
    required this.formKey, 
    required this.userNameController,
    required this.userEmailController
  });

  // True if User is in editing mode and their info can be edited
  final bool editing;
  final String userName;
  final String userEmail;
  final Key formKey;
  final TextEditingController userNameController;
  final TextEditingController userEmailController;

  @override
  State<StatefulWidget> createState() => _UserInfoCardState();
}

/// Stores the mutable data that can change over the lifetime of the UserInfoCard.
class _UserInfoCardState extends State<UserInfoCard> {
  
  @override
  Widget build(BuildContext context) {
    // Now that widget has the passed the User info, populate the controllers
    widget.userNameController.text = widget.userName;
    widget.userEmailController.text = widget.userEmail;

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
          key: widget.formKey,
          child: Column(children: <Widget>[
            
            // Name
            Padding(
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
                        controller: widget.userNameController,
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
                      widget.userNameController.text,
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
                      controller: widget.userEmailController,
                      maxLength: 25,
                      validator: (value) => EmailValidator.validate(value!) ? null : "Please enter a valid email",
                    )
                  ),
                // Normal text if not editing profile
                if (!widget.editing)
                  Text(
                    widget.userEmailController.text,
                    style: const TextStyle(fontSize: 20),
                  )
              ],
            ),
          ])
        ),
    );
  }
}