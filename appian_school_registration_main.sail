/*
   * ============================================================================
   * APPIAN SCHOOL REGISTRATION SYSTEM - MAIN FORM
   * ============================================================================
   * Purpose: Comprehensive school student registration form
   * Features: All Input, Display, Layout, and Advanced components integrated
   * Version: 1.0
   * ============================================================================
   */
a!localVariables(
  /* LOCAL VARIABLES - Store all form data and state */
  local!student: a!map(
    /* Personal Information */
    firstName: "",
    lastName: "",
    email: "",
    phoneNumber: "",
    alternatePhone: "",
    dateOfBirth: null,
    age: 0,
    gender: "",
    bloodGroup: "",
    /* Academic Information */
    class: "",
    section: "",
    rollNumber: "",
    admissionYear: "",
    previousSchool: "",
    /* Medical Information */
    medicalConditions: "",
    allergies: "",
    vaccinated: false,
    vaccinationDetails: "",
    /* Parent/Guardian Information */
    fatherName: "",
    fatherPhone: "",
    motherName: "",
    motherPhone: "",
    guardianName: "",
    guardianRelation: "",
    guardianPhone: "",
    /* Address Information */
    currentAddress: "",
    permanentAddress: "",
    city: "",
    state: "",
    pincode: "",
    country: "India",
    /* Emergency Contact */
    emergencyContactName: "",
    emergencyContactPhone: "",
    emergencyRelation: "",
    /* Preferences */
    transport: false,
    transportMode: "",
    pickupPoint: "",
    extracurricular: {},
    /* Agreement */
    agreeToTerms: false,
    agreeToPolicy: false,
    registrationDate: now(),
    status: "Pending"
  ),
  local!extracurricularOptions: {
    "Sports",
    "Music",
    "Dance",
    "Art",
    "Debate",
    "Science Club",
    "Coding",
    "Drama"
  },
  local!registeredStudents: {
    a!map(
      id: 1,
      firstName: "Arjun",
      lastName: "Kumar",
      class: "10-A",
      rollNumber: "1001",
      email: "arjun.kumar@school.com",
      registrationDate: today() - 15,
      status: "Approved"
    ),
    a!map(
      id: 2,
      firstName: "Priya",
      lastName: "Singh",
      class: "10-B",
      rollNumber: "1002",
      email: "priya.singh@school.com",
      registrationDate: today() - 10,
      status: "Approved"
    ),
    a!map(
      id: 3,
      firstName: "Rajesh",
      lastName: "Patel",
      class: "9-A",
      rollNumber: "1003",
      email: "rajesh.patel@school.com",
      registrationDate: today() - 5,
      status: "Pending"
    ),
    a!map(
      id: 4,
      firstName: "Neha",
      lastName: "Sharma",
      class: "10-C",
      rollNumber: "1004",
      email: "neha.sharma@school.com",
      registrationDate: today() - 2,
      status: "Approved"
    )
  },
  local!showSuccessMessage: false,
  local!successMessage: "",
  local!currentTab: 1,
  local!completionPercentage: 0,
  local!validationErrors: a!map(),
  {
    /* ========================================================================== */
    /* DISPLAY COMPONENT: Rich Text Header with Logo and Title */
    /* ========================================================================== */
    a!richTextDisplayField(
      value: {
        a!richTextItem(text: "🎓 ", size: "LARGE"),
        a!richTextItem(
          text: "SCHOOL STUDENT REGISTRATION SYSTEM",
          style: "STRONG",
          size: "LARGE",
          color: "#185FA5"
        )
      },
      align: "CENTER"
    ),
    /* ========================================================================== */
    /* DISPLAY COMPONENT: Success Message Alert */
    /* ========================================================================== */
    a!textField(
      label: "",
      value: "✓ " & local!successMessage,
      readOnly: true,
      required: false,
      showWhen: local!showSuccessMessage,
      align: "CENTER"
    ),
    /* ========================================================================== */
    /* ADVANCED COMPONENT: Progress Bar showing completion */
    /* ========================================================================== */
    if(
      local!completionPercentage > 0,
      a!sectionLayout(
        label: "Registration Progress",
        contents: {
          a!progressBarField(
            percentage: local!completionPercentage,
            label: "Overall Progress: " & local!completionPercentage & "%"
          )
        }
      ),
      ""
    ),
    /* ========================================================================== */
    /* SECTION 1: PERSONAL INFORMATION - Input Components Demo */
    /* ========================================================================== */
    a!sectionLayout(
      label: "1. Personal Information",
      contents: {
        /* LAYOUT COMPONENT: Column Layout for 2-column form */
        a!columnsLayout(
          columns: {
            /* LEFT COLUMN */
            a!columnLayout(
              contents: {
                /* INPUT COMPONENT: Text Field - First Name */
                a!textField(
                  label: "First Name *",
                  value: local!student.firstName,
                  saveInto: local!student.firstName,
                  required: true,
                  placeholder: "Enter your first name",
                  characterLimit: 50,
                  validations: {
                    if(
                      len(local!student.firstName) < 3,
                      "First name must be at least 3 characters",
                      ""
                    )
                  }
                ),
                /* INPUT COMPONENT: Text Field - Email */
                a!textField(
                  label: "Email Address *",
                  value: local!student.email,
                  saveInto: local!student.email,
                  required: true,
                  placeholder: "student@school.com",
                  characterLimit: 100,
                  validations: {
                    if(
                      or(
                        local!student.email = "",
                        isnull(local!student.email)
                      ),
                      "",
                      if(
                        regexcontains(
                          local!student.email,
                          "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"
                        ),
                        "",
                        "Please enter a valid email address"
                      )
                    )
                  }
                ),
                /* INPUT COMPONENT: Phone Number */
                a!textField(
                  label: "Phone Number *",
                  value: local!student.phoneNumber,
                  saveInto: local!student.phoneNumber,
                  required: true,
                  placeholder: "Enter 10-digit phone number",
                  characterLimit: 10,
                  validations: {
                    if(
                      len(local!student.phoneNumber) <> 10,
                      "Phone number must be 10 digits",
                      ""
                    )
                  }
                ),
                /* INPUT COMPONENT: Date Picker - Date of Birth */
                a!dateField(
                  label: "Date of Birth *",
                  value: local!student.dateOfBirth,
                  saveInto: {
                    local!student.dateOfBirth,
                    local!student.age: if(
                      isnull(local!student.dateOfBirth),
                      0,
                      year(today()) - year(local!student.dateOfBirth)
                    )
                  },
                  required: true,
                  validations: {
                    if(
                      and(
                        not(isnull(local!student.dateOfBirth)),
                        local!student.dateOfBirth > today()
                      ),
                      "Date of birth cannot be in future",
                      ""
                    )
                  }
                ),
                /* DISPLAY COMPONENT: Show calculated age */
                a!textField(
                  label: "Age",
                  value: if(
                    index(local!student, "age", 0) > 0,
                    local!student.age,
                    ""
                  ),
                  readOnly: true,
                  placeholder: "Auto-calculated"
                )
              }
            ),
            /* RIGHT COLUMN */
            a!columnLayout(
              contents: {
                /* INPUT COMPONENT: Text Field - Last Name */
                a!textField(
                  label: "Last Name *",
                  value: local!student.lastName,
                  saveInto: local!student.lastName,
                  required: true,
                  placeholder: "Enter your last name",
                  characterLimit: 50,
                  validations: {
                    if(
                      len(local!student.lastName) < 2,
                      "Last name must be at least 2 characters",
                      ""
                    )
                  }
                ),
                /* INPUT COMPONENT: Alternate Phone */
                a!textField(
                  label: "Alternate Phone Number",
                  value: local!student.alternatePhone,
                  saveInto: local!student.alternatePhone,
                  placeholder: "Optional - 10 digit number",
                  characterLimit: 10,
                  validations: {
                    if(
                      and(
                        local!student.alternatePhone <> "",
                        len(local!student.alternatePhone) <> 10
                      ),
                      "Alternate phone must be 10 digits",
                      ""
                    )
                  }
                ),
                /* INPUT COMPONENT: Radio Button - Gender */
                a!radioButtonField(
                  label: "Gender *",
                  value: local!student.gender,
                  saveInto: local!student.gender,
                  choiceLabels: { "Male", "Female", "Other" },
                  choiceValues: { "M", "F", "O" },
                  required: true
                ),
                /* INPUT COMPONENT: Dropdown - Blood Group */
                a!dropdownField(
                  label: "Blood Group *",
                  value: local!student.bloodGroup,
                  saveInto: local!student.bloodGroup,
                  required: true,
                  choiceLabels: {
                    "A+",
                    "A-",
                    "B+",
                    "B-",
                    "O+",
                    "O-",
                    "AB+",
                    "AB-"
                  },
                  choiceValues: {
                    "AP",
                    "AN",
                    "BP",
                    "BN",
                    "OP",
                    "ON",
                    "ABP",
                    "ABN"
                  },
                  placeholder: "Select blood group"
                )
              }
            )
          }
        )
      }
    ),
    /* ========================================================================== */
    /* SECTION 2: ACADEMIC INFORMATION */
    /* ========================================================================== */
    a!sectionLayout(
      label: "2. Academic Information",
      contents: {
        a!columnsLayout(
          columns: {
            a!columnLayout(
              contents: {
                /* INPUT COMPONENT: Dropdown - Class Selection */
                a!dropdownField(
                  label: "Class/Grade *",
                  value: local!student.class,
                  saveInto: local!student.class,
                  required: true,
                  choiceLabels: {
                    "Class 6",
                    "Class 7",
                    "Class 8",
                    "Class 9",
                    "Class 10",
                    "Class 11",
                    "Class 12"
                  },
                  choiceValues: { "6", "7", "8", "9", "10", "11", "12" },
                  placeholder: "Select your class"
                ),
                /* INPUT COMPONENT: Dropdown - Section */
                a!dropdownField(
                  label: "Section",
                  value: local!student.section,
                  saveInto: local!student.section,
                  choiceLabels: { "A", "B", "C", "D" },
                  choiceValues: { "A", "B", "C", "D" },
                  placeholder: "Select section (if applicable)"
                ),
                /* INPUT COMPONENT: Text Field - Previous School */
                a!textField(
                  label: "Previous School Name",
                  value: local!student.previousSchool,
                  saveInto: local!student.previousSchool,
                  placeholder: "Enter name of previous school",
                  characterLimit: 100
                )
              }
            ),
            a!columnLayout(
              contents: {
                /* INPUT COMPONENT: Text Field - Roll Number */
                a!textField(
                  label: "Roll Number",
                  value: local!student.rollNumber,
                  saveInto: local!student.rollNumber,
                  placeholder: "Auto-generated if blank",
                  characterLimit: 20,
                  readOnly: false
                ),
                /* INPUT COMPONENT: Dropdown - Admission Year */
                a!dropdownField(
                  label: "Admission Year",
                  value: local!student.admissionYear,
                  saveInto: local!student.admissionYear,
                  choiceLabels: { "2024", "2025", "2026" },
                  choiceValues: { "2024", "2025", "2026" },
                  placeholder: "Select year"
                )
              }
            )
          }
        )
      }
    ),
    /* ========================================================================== */
    /* SECTION 3: MEDICAL INFORMATION */
    /* ========================================================================== */
    a!sectionLayout(
      label: "3. Medical Information",
      contents: {
        a!columnsLayout(
          columns: {
            a!columnLayout(
              contents: {
                /* INPUT COMPONENT: Text Area - Medical Conditions */
                a!textField(
                  label: "Medical Conditions",
                  value: local!student.medicalConditions,
                  saveInto: local!student.medicalConditions,
                  placeholder: "List any medical conditions",
                  characterLimit: 500
                ),
                /* INPUT COMPONENT: Text Area - Allergies */
                a!textField(
                  label: "Allergies",
                  value: local!student.allergies,
                  saveInto: local!student.allergies,
                  placeholder: "List any known allergies",
                  characterLimit: 500
                )
              }
            ),
            a!columnLayout(
              contents: {
                /* INPUT COMPONENT: Checkbox - Vaccination Status */
                a!checkboxField(
                  label: "Vaccination Status",
                  value: local!student.vaccinated,
                  saveInto: local!student.vaccinated,
                  choiceLabels: { "Fully Vaccinated" },
                  choiceValues: { true }
                ),
                /* INPUT COMPONENT: Text Field - Vaccination Details */
                a!textField(
                  label: "Vaccination Details",
                  value: local!student.vaccinationDetails,
                  saveInto: local!student.vaccinationDetails,
                  placeholder: "Provide vaccination details",
                  characterLimit: 200,
                  showWhen: local!student.vaccinated
                )
              }
            )
          }
        )
      }
    ),
    /* ========================================================================== */
    /* SECTION 4: PARENT/GUARDIAN INFORMATION */
    /* ========================================================================== */
    a!sectionLayout(
      label: "4. Parent/Guardian Information",
      contents: {
        a!columnsLayout(
          columns: {
            a!columnLayout(
              contents: {
                /* INPUT COMPONENT: Text Field - Father Name */
                a!textField(
                  label: "Father's Name *",
                  value: local!student.fatherName,
                  saveInto: local!student.fatherName,
                  required: true,
                  placeholder: "Enter father's full name",
                  characterLimit: 100
                ),
                /* INPUT COMPONENT: Phone Number - Father */
                a!textField(
                  label: "Father's Phone Number",
                  value: local!student.fatherPhone,
                  saveInto: local!student.fatherPhone,
                  placeholder: "Enter 10-digit phone number",
                  characterLimit: 10,
                  validations: {
                    if(
                      and(
                        local!student.fatherPhone <> "",
                        len(local!student.fatherPhone) <> 10
                      ),
                      "Phone must be 10 digits",
                      ""
                    )
                  }
                ),
                /* INPUT COMPONENT: Text Field - Guardian Name */
                a!textField(
                  label: "Guardian Name (if different)",
                  value: local!student.guardianName,
                  saveInto: local!student.guardianName,
                  placeholder: "Enter guardian's full name",
                  characterLimit: 100
                )
              }
            ),
            a!columnLayout(
              contents: {
                /* INPUT COMPONENT: Text Field - Mother Name */
                a!textField(
                  label: "Mother's Name *",
                  value: local!student.motherName,
                  saveInto: local!student.motherName,
                  required: true,
                  placeholder: "Enter mother's full name",
                  characterLimit: 100
                ),
                /* INPUT COMPONENT: Phone Number - Mother */
                a!textField(
                  label: "Mother's Phone Number",
                  value: local!student.motherPhone,
                  saveInto: local!student.motherPhone,
                  placeholder: "Enter 10-digit phone number",
                  characterLimit: 10,
                  validations: {
                    if(
                      and(
                        local!student.motherPhone <> "",
                        len(local!student.motherPhone) <> 10
                      ),
                      "Phone must be 10 digits",
                      ""
                    )
                  }
                ),
                /* INPUT COMPONENT: Dropdown - Guardian Relation */
                a!dropdownField(
                  label: "Relation to Student",
                  value: local!student.guardianRelation,
                  saveInto: local!student.guardianRelation,
                  choiceLabels: {
                    "Father",
                    "Mother",
                    "Grandfather",
                    "Grandmother",
                    "Uncle",
                    "Aunt",
                    "Brother",
                    "Sister",
                    "Other"
                  },
                  choiceValues: { "F", "M", "GF", "GM", "U", "A", "B", "S", "O" },
                  showWhen: local!student.guardianName <> ""
                )
              }
            )
          }
        )
      }
    ),
    /* ========================================================================== */
    /* SECTION 5: ADDRESS INFORMATION */
    /* ========================================================================== */
    a!sectionLayout(
      label: "5. Address Information",
      contents: {
        /* INPUT COMPONENT: Text Area - Current Address */
        a!textField(
          label: "Current Address *",
          value: local!student.currentAddress,
          saveInto: local!student.currentAddress,
          required: true,
          placeholder: "Enter complete current address",
          characterLimit: 300
        ),
        /* INPUT COMPONENT: Text Area - Permanent Address */
        a!textField(
          label: "Permanent Address (if different)",
          value: local!student.permanentAddress,
          saveInto: local!student.permanentAddress,
          placeholder: "Enter permanent address",
          characterLimit: 300
        ),
        a!columnsLayout(
          columns: {
            a!columnLayout(
              contents: {
                /* INPUT COMPONENT: Text Field - City */
                a!textField(
                  label: "City *",
                  value: local!student.city,
                  saveInto: local!student.city,
                  required: true,
                  placeholder: "Enter city name",
                  characterLimit: 50
                )
              }
            ),
            a!columnLayout(
              contents: {
                /* INPUT COMPONENT: Text Field - State */
                a!textField(
                  label: "State *",
                  value: local!student.state,
                  saveInto: local!student.state,
                  required: true,
                  placeholder: "Enter state name",
                  characterLimit: 50
                )
              }
            ),
            a!columnLayout(
              contents: {
                /* INPUT COMPONENT: Text Field - Pincode */
                a!textField(
                  label: "Pincode *",
                  value: local!student.pincode,
                  saveInto: local!student.pincode,
                  required: true,
                  placeholder: "Enter 6-digit pincode",
                  characterLimit: 6,
                  validations: {
                    if(
                      and(
                        local!student.pincode <> "",
                        or(
                          len(local!student.pincode) <> 6,
                          not(
                            isnumber(value(local!student.pincode, ""))
                          )
                        )
                      ),
                      "Pincode must be 6 digits",
                      ""
                    )
                  }
                )
              }
            )
          }
        ),
        /* DISPLAY COMPONENT: Country (Read-only) */
        a!textField(
          label: "Country",
          value: local!student.country,
          readOnly: true,
          placeholder: ""
        )
      }
    ),
    /* ========================================================================== */
    /* SECTION 6: EMERGENCY CONTACT */
    /* ========================================================================== */
    a!sectionLayout(
      label: "6. Emergency Contact Information",
      contents: {
        a!columnsLayout(
          columns: {
            a!columnLayout(
              contents: {
                /* INPUT COMPONENT: Text Field - Emergency Contact Name */
                a!textField(
                  label: "Contact Name *",
                  value: local!student.emergencyContactName,
                  saveInto: local!student.emergencyContactName,
                  required: true,
                  placeholder: "Enter emergency contact name",
                  characterLimit: 100
                )
              }
            ),
            a!columnLayout(
              contents: {
                /* INPUT COMPONENT: Text Field - Emergency Contact Phone */
                a!textField(
                  label: "Contact Phone Number *",
                  value: local!student.emergencyContactPhone,
                  saveInto: local!student.emergencyContactPhone,
                  required: true,
                  placeholder: "Enter 10-digit phone number",
                  characterLimit: 10,
                  validations: {
                    if(
                      len(local!student.emergencyContactPhone) <> 10,
                      "Phone must be 10 digits",
                      ""
                    )
                  }
                )
              }
            ),
            a!columnLayout(
              contents: {
                /* INPUT COMPONENT: Dropdown - Emergency Relation */
                a!dropdownField(
                  label: "Relation to Student *",
                  value: local!student.emergencyRelation,
                  saveInto: local!student.emergencyRelation,
                  required: true,
                  placeholder: "Select Value",
                  choiceLabels: {
                    "Father",
                    "Mother",
                    "Brother",
                    "Sister",
                    "Uncle",
                    "Aunt",
                    "Grandfather",
                    "Grandmother",
                    "Friend",
                    "Other"
                  },
                  choiceValues: {
                    "F",
                    "M",
                    "B",
                    "S",
                    "U",
                    "A",
                    "GF",
                    "GM",
                    "FR",
                    "O"
                  }
                )
              }
            )
          }
        )
      }
    ),
    /* ========================================================================== */
    /* SECTION 7: ADDITIONAL INFORMATION */
    /* ========================================================================== */
    a!sectionLayout(
      label: "7. Additional Information",
      contents: {
        a!columnsLayout(
          columns: {
            a!columnLayout(
              contents: {
                /* INPUT COMPONENT: Checkbox - Transport */
                a!checkboxField(
                  label: "Transportation",
                  value: local!student.transport,
                  saveInto: local!student.transport,
                  choiceLabels: { "Require school transport" },
                  choiceValues: { true }
                ),
                /* INPUT COMPONENT: Dropdown - Transport Mode (Conditional) */
                a!dropdownField(
                  label: "Transport Mode",
                  value: local!student.transportMode,
                  saveInto: local!student.transportMode,
                  choiceLabels: {
                    "Bus",
                    "Van",
                    "Auto-Rickshaw",
                    "Personal Transport"
                  },
                  choiceValues: { "B", "V", "A", "P" },
                  placeholder: "Select transport mode",
                  showWhen: local!student.transport
                ),
                /* INPUT COMPONENT: Text Field - Pickup Point */
                a!textField(
                  label: "Preferred Pickup Point",
                  value: local!student.pickupPoint,
                  saveInto: local!student.pickupPoint,
                  placeholder: "Enter pickup location",
                  characterLimit: 100,
                  showWhen: local!student.transport
                )
              }
            ),
            a!columnLayout(
              contents: {
                /* DISPLAY COMPONENT: Extracurricular Activities Header */
                a!paragraphField(
                  value: "Extracurricular Activities (Select interests)",
                  readOnly: true
                ),
                /* ADVANCED COMPONENT: Repeating Group - Checkboxes */
                a!forEach(
                  items: local!extracurricularOptions,
                  expression: a!checkboxField(
                    label: fv!item,
                    value: if(
                      contains(local!student.extracurricular, fv!item),
                      true(),
                      null
                    ),
                    saveInto: {
                      local!student.extracurricular: if(
                        contains(local!student.extracurricular, fv!item),
                        remove(local!student.extracurricular, fv!item),
                        append(local!student.extracurricular, fv!item)
                      )
                    },
                    choiceLabels: { fv!item },
                    choiceValues: { true }
                  )
                )
              }
            )
          }
        )
      }
    ),
    /* ========================================================================== */
    /* SECTION 8: TERMS AND AGREEMENTS */
    /* ========================================================================== */
    a!sectionLayout(
      label: "8. Terms and Conditions",
      contents: {
        /* DISPLAY COMPONENT: Rich Text Policy Information */
        a!richTextDisplayField(
          value: {
            a!richTextItem(
              text: "Please read and agree to the following:",
              style: "STRONG"
            ),
            a!richTextItem(
              text: char(10) & "• I certify that the information provided is true and correct" & char(10),
              size: "MEDIUM"
            ),
            a!richTextItem(
              text: "• I agree to abide by the school rules and regulations" & char(10),
              size: "MEDIUM"
            ),
            a!richTextItem(
              text: "• I authorize the school to use my child's image for academic purposes",
              size: "MEDIUM"
            )
          }
        ),
        /* INPUT COMPONENT: Checkbox - Terms */
        a!checkboxField(
          label: "I agree to Terms and Conditions *",
          value: if(local!student.agreeToTerms, true(), null),
          saveInto: local!student.agreeToTerms,
          choiceLabels: {
            "Yes, I understand and agree to all terms"
          },
          choiceValues: { true },
          required: true
        ),
        /* INPUT COMPONENT: Checkbox - Privacy Policy */
        a!checkboxField(
          label: "I agree to the Privacy Policy *",
          value: if(
            local!student.agreeToPolicy,
            true(),
            null
          ),
          saveInto: local!student.agreeToPolicy,
          choiceLabels: {
            "Yes, I have read and accept the privacy policy"
          },
          choiceValues: { true },
          required: true
        )
      }
    ),
    /* ========================================================================== */
    /* BUTTONS AND ACTIONS */
    /* ========================================================================== */
    a!buttonLayout(
      primaryButtons: {
        a!buttonWidget(
          label: "Submit Registration",
          submit: true,
          style: "SOLID",
          size: "LARGE",
          validate: true,
          saveInto: {
            local!showSuccessMessage: true,
            local!successMessage: "Registration submitted successfully! Your admission ID: " & concate(
              left(upper(local!student.firstName), 1),
              left(upper(local!student.lastName), 1),
              text(rand(1, 9999), "0000")
            ),
            local!completionPercentage: 100
          }
        ),
        a!buttonWidget(
          label: "Reset Form",
          submit: false,
          style: "OUTLINE",
          size: "LARGE",
          saveInto: {
            local!student: a!map(
              firstName: "",
              lastName: "",
              email: "",
              phoneNumber: "",
              alternatePhone: "",
              dateOfBirth: null,
              age: 0,
              gender: "",
              bloodGroup: "",
              class: "",
              section: "",
              rollNumber: "",
              admissionYear: "",
              previousSchool: "",
              medicalConditions: "",
              allergies: "",
              vaccinated: false,
              vaccinationDetails: "",
              fatherName: "",
              fatherPhone: "",
              motherName: "",
              motherPhone: "",
              guardianName: "",
              guardianRelation: "",
              guardianPhone: "",
              currentAddress: "",
              permanentAddress: "",
              city: "",
              state: "",
              pincode: "",
              country: "India",
              emergencyContactName: "",
              emergencyContactPhone: "",
              emergencyRelation: "",
              transport: false,
              transportMode: "",
              pickupPoint: "",
              extracurricular: {},
              agreeToTerms: false,
              agreeToPolicy: false,
              registrationDate: now(),
              status: "Pending"
            ),
            local!showSuccessMessage: false,
            local!successMessage: "",
            local!completionPercentage: 0
          }
        ),
        a!buttonWidget(
          label: "Save as Draft",
          submit: false,
          style: "OUTLINE",
          size: "LARGE"
        )
      }
    ),
    /* ========================================================================== */
    /* SECTION 9: REGISTERED STUDENTS DASHBOARD */
    /* ========================================================================== */
    a!sectionLayout(
      label: "9. Recently Registered Students Dashboard",
      isCollapsible: true(),
      isInitiallyCollapsed: false,
      contents: {
        /* DISPLAY COMPONENT: Instructions Paragraph */
        a!paragraphField(
          value: "Below is a list of recently registered students. Click on any row for detailed information.",
          
        ),
        /* ADVANCED COMPONENT: Grid Field (Data Table) */
        a!gridField(
          data: local!registeredStudents,
          columns: {
            a!gridColumn(
              label: "First Name",
              sortField: "firstName",
              value: fv!row.firstName,
              width: "NARROW"
            ),
            a!gridColumn(
              label: "Last Name",
              sortField: "lastName",
              value: fv!row.lastName,
              width: "NARROW"
            ),
            a!gridColumn(
              label: "Class",
              sortField: "class",
              value: fv!row.class,
              width: "NARROW"
            ),
            a!gridColumn(
              label: "Roll Number",
              sortField: "rollNumber",
              value: fv!row.rollNumber,
              width: "NARROW"
            ),
            a!gridColumn(
              label: "Email",
              sortField: "email",
              value: fv!row.email,
              width: "MEDIUM"
            ),
            a!gridColumn(
              label: "Registration Date",
              sortField: "registrationDate",
              value: fv!row.registrationDate,
              width: "NARROW"
            ),
            a!gridColumn(
              label: "Status",
              sortField: "status",
              value: fv!row.status,
              width: "NARROW"
            )
          },
          pageSize: 5,
          selectable: true,
          rowHeader: 1
        )
      }
    ),
    /* ========================================================================== */
    /* FOOTER INFORMATION */
    /* ========================================================================== */
    a!richTextDisplayField(
      value: {
        a!richTextItem(
          text: "For support or queries, please contact: ",
          size: "SMALL",
          color: "#888780"
        ),
        a!richTextItem(
          text: "admissions@school.com",
          size: "SMALL",
          style: "STRONG",
          color: "#185FA5"
        ),
        a!richTextItem(
          text: " | Phone: +91-XXXXX-XXXXX",
          size: "SMALL",
          color: "#888780"
        )
      },
      align: "CENTER"
    )
  }
)