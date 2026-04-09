import '../models/user_model.dart';

class MockData {
  // ─── Mock Users ───────────────────────────────────────────────
  static final List<UserModel> users = [
    UserModel(
      id: 'STU001',
      name: 'Aanya Sharma',
      email: 'aanya@eduportal.in',
      role: 'student',
      password: 'pass123',
      extraData: {
        'class': '10',
        'section': 'A',
        'attendance': 92.5,
        'address': '12, Rose Garden, Mumbai - 400001',
        'guardian': 'Rajesh Sharma (Father) - 9876543210',
        'photo': '',
      },
    ),
    UserModel(
      id: 'TCH001',
      name: 'Dr. Priya Nair',
      email: 'priya@eduportal.in',
      role: 'teacher',
      password: 'pass123',
      extraData: {
        'subject': 'Mathematics',
        'phone': '9812345678',
        'address': '45, Lake View, Pune - 411001',
        'salary_status': 'Credited',
        'salary_amount': '₹55,000',
      },
    ),
    UserModel(
      id: 'PRI001',
      name: 'Mr. Suresh Verma',
      email: 'suresh@eduportal.in',
      role: 'principal',
      password: 'pass123',
      extraData: {
        'phone': '9911223344',
        'branch': 'Delhi Main Campus',
        'salary_status': 'Credited',
        'salary_amount': '₹1,20,000',
      },
    ),
  ];

  // ─── Student Schedule ─────────────────────────────────────────
  static Map<String, List<Map<String, String>>> studentSchedule = {
    'Monday': [
      {'time': '08:00 – 09:00', 'subject': 'Mathematics', 'teacher': 'Dr. Priya Nair'},
      {'time': '09:00 – 10:00', 'subject': 'Science', 'teacher': 'Mr. Arjun Kumar'},
      {'time': '10:15 – 11:15', 'subject': 'English', 'teacher': 'Ms. Sunita Rao'},
      {'time': '11:15 – 12:15', 'subject': 'History', 'teacher': 'Mr. Vijay Menon'},
      {'time': '13:00 – 14:00', 'subject': 'Computer Science', 'teacher': 'Ms. Kavya Pillai'},
    ],
    'Tuesday': [
      {'time': '08:00 – 09:00', 'subject': 'English', 'teacher': 'Ms. Sunita Rao'},
      {'time': '09:00 – 10:00', 'subject': 'Mathematics', 'teacher': 'Dr. Priya Nair'},
      {'time': '10:15 – 11:15', 'subject': 'Geography', 'teacher': 'Mr. Ravi Teja'},
      {'time': '11:15 – 12:15', 'subject': 'Science', 'teacher': 'Mr. Arjun Kumar'},
      {'time': '13:00 – 14:00', 'subject': 'Physical Education', 'teacher': 'Mr. Deepak Singh'},
    ],
    'Wednesday': [
      {'time': '08:00 – 09:00', 'subject': 'History', 'teacher': 'Mr. Vijay Menon'},
      {'time': '09:00 – 10:00', 'subject': 'Computer Science', 'teacher': 'Ms. Kavya Pillai'},
      {'time': '10:15 – 11:15', 'subject': 'Mathematics', 'teacher': 'Dr. Priya Nair'},
      {'time': '11:15 – 12:15', 'subject': 'English', 'teacher': 'Ms. Sunita Rao'},
      {'time': '13:00 – 14:00', 'subject': 'Art', 'teacher': 'Ms. Meena Joshi'},
    ],
    'Thursday': [
      {'time': '08:00 – 09:00', 'subject': 'Science', 'teacher': 'Mr. Arjun Kumar'},
      {'time': '09:00 – 10:00', 'subject': 'Geography', 'teacher': 'Mr. Ravi Teja'},
      {'time': '10:15 – 11:15', 'subject': 'English', 'teacher': 'Ms. Sunita Rao'},
      {'time': '11:15 – 12:15', 'subject': 'Mathematics', 'teacher': 'Dr. Priya Nair'},
      {'time': '13:00 – 14:00', 'subject': 'Computer Science', 'teacher': 'Ms. Kavya Pillai'},
    ],
    'Friday': [
      {'time': '08:00 – 09:00', 'subject': 'Mathematics', 'teacher': 'Dr. Priya Nair'},
      {'time': '09:00 – 10:00', 'subject': 'English', 'teacher': 'Ms. Sunita Rao'},
      {'time': '10:15 – 11:15', 'subject': 'Science', 'teacher': 'Mr. Arjun Kumar'},
      {'time': '11:15 – 12:15', 'subject': 'Physical Education', 'teacher': 'Mr. Deepak Singh'},
      {'time': '13:00 – 14:00', 'subject': 'History', 'teacher': 'Mr. Vijay Menon'},
    ],
    'Saturday': [
      {'time': '08:00 – 09:30', 'subject': 'Mathematics Lab', 'teacher': 'Dr. Priya Nair'},
      {'time': '09:30 – 11:00', 'subject': 'Science Lab', 'teacher': 'Mr. Arjun Kumar'},
    ],
  };

  // ─── Exam Results ─────────────────────────────────────────────
  static Map<String, Map<String, List<Map<String, dynamic>>>> examResults = {
    'STU001': {
      'Mid-Term': [
        {'subject': 'Mathematics', 'marks': 95, 'total': 100, 'grade': 'A+'},
        {'subject': 'Science', 'marks': 97, 'total': 100, 'grade': 'A+'},
        {'subject': 'English', 'marks': 87, 'total': 100, 'grade': 'A'},
        {'subject': 'History', 'marks': 78, 'total': 100, 'grade': 'B+'},
        {'subject': 'Geography', 'marks': 83, 'total': 100, 'grade': 'A'},
        {'subject': 'Computer Science', 'marks': 99, 'total': 100, 'grade': 'A+'},
      ],
      'Final': [
        {'subject': 'Mathematics', 'marks': 92, 'total': 100, 'grade': 'A+'},
        {'subject': 'Science', 'marks': 94, 'total': 100, 'grade': 'A+'},
        {'subject': 'English', 'marks': 89, 'total': 100, 'grade': 'A'},
        {'subject': 'History', 'marks': 80, 'total': 100, 'grade': 'A'},
        {'subject': 'Geography', 'marks': 85, 'total': 100, 'grade': 'A'},
        {'subject': 'Computer Science', 'marks': 98, 'total': 100, 'grade': 'A+'},
      ],
      'Unit Test 1': [
        {'subject': 'Mathematics', 'marks': 48, 'total': 50, 'grade': 'A+'},
        {'subject': 'Science', 'marks': 45, 'total': 50, 'grade': 'A+'},
        {'subject': 'English', 'marks': 42, 'total': 50, 'grade': 'A'},
      ],
    },
  };

  // ─── Midday Meal ──────────────────────────────────────────────
  static List<Map<String, String>> weeklyMeal = [
    {'day': 'Monday', 'menu': 'Rice, Dal, Sabzi, Chapati, Salad'},
    {'day': 'Tuesday', 'menu': 'Khichdi, Curd, Papad, Pickle'},
    {'day': 'Wednesday', 'menu': 'Chapati, Rajma, Rice, Raita'},
    {'day': 'Thursday', 'menu': 'Puri, Aloo Sabzi, Halwa'},
    {'day': 'Friday', 'menu': 'Rice, Sambar, Coconut Chutney, Fruits'},
    {'day': 'Saturday', 'menu': 'Upma, Coconut Chutney, Banana'},
  ];

  // ─── Students List ────────────────────────────────────────────
  static List<Map<String, dynamic>> studentsList = [
    {'id': 'STU001', 'name': 'Aanya Sharma', 'class': '10', 'section': 'A', 'attendance': 92},
    {'id': 'STU002', 'name': 'Rohan Mehta', 'class': '10', 'section': 'A', 'attendance': 88},
    {'id': 'STU003', 'name': 'Priya Singh', 'class': '10', 'section': 'A', 'attendance': 95},
    {'id': 'STU004', 'name': 'Aryan Gupta', 'class': '10', 'section': 'A', 'attendance': 79},
    {'id': 'STU005', 'name': 'Sneha Patel', 'class': '10', 'section': 'B', 'attendance': 91},
    {'id': 'STU006', 'name': 'Karan Joshi', 'class': '10', 'section': 'B', 'attendance': 85},
    {'id': 'STU007', 'name': 'Divya Nair', 'class': '9', 'section': 'A', 'attendance': 97},
    {'id': 'STU008', 'name': 'Ankit Verma', 'class': '9', 'section': 'A', 'attendance': 83},
    {'id': 'STU009', 'name': 'Riya Kapoor', 'class': '9', 'section': 'B', 'attendance': 90},
    {'id': 'STU010', 'name': 'Vivek Rao', 'class': '9', 'section': 'B', 'attendance': 76},
  ];

  // ─── Teacher Timetable ────────────────────────────────────────
  static Map<String, List<Map<String, String>>> teacherTimetable = {
    'Monday': [
      {'time': '08:00 – 09:00', 'class': '10', 'section': 'A', 'subject': 'Mathematics'},
      {'time': '09:00 – 10:00', 'class': '9', 'section': 'B', 'subject': 'Mathematics'},
      {'time': '10:15 – 11:15', 'class': '10', 'section': 'B', 'subject': 'Mathematics'},
      {'time': '13:00 – 14:00', 'class': '8', 'section': 'A', 'subject': 'Mathematics'},
    ],
    'Tuesday': [
      {'time': '09:00 – 10:00', 'class': '10', 'section': 'A', 'subject': 'Mathematics'},
      {'time': '11:15 – 12:15', 'class': '9', 'section': 'A', 'subject': 'Mathematics'},
    ],
    'Wednesday': [
      {'time': '08:00 – 09:00', 'class': '8', 'section': 'B', 'subject': 'Mathematics'},
      {'time': '10:15 – 11:15', 'class': '10', 'section': 'A', 'subject': 'Mathematics'},
      {'time': '13:00 – 14:00', 'class': '9', 'section': 'B', 'subject': 'Mathematics'},
    ],
    'Thursday': [
      {'time': '09:00 – 10:00', 'class': '8', 'section': 'A', 'subject': 'Mathematics'},
      {'time': '11:15 – 12:15', 'class': '10', 'section': 'A', 'subject': 'Mathematics'},
    ],
    'Friday': [
      {'time': '08:00 – 09:00', 'class': '10', 'section': 'A', 'subject': 'Mathematics'},
      {'time': '10:15 – 11:15', 'class': '9', 'section': 'A', 'subject': 'Mathematics'},
      {'time': '13:00 – 14:00', 'class': '10', 'section': 'B', 'subject': 'Mathematics'},
    ],
  };

  // ─── Leave Requests ───────────────────────────────────────────
  static List<Map<String, dynamic>> leaveRequests = [
    {
      'teacher': 'Dr. Priya Nair',
      'id': 'TCH001',
      'reason': 'Medical appointment',
      'from': '2026-04-10',
      'to': '2026-04-11',
      'status': 'Pending',
    },
    {
      'teacher': 'Mr. Arjun Kumar',
      'id': 'TCH002',
      'reason': 'Family function',
      'from': '2026-04-15',
      'to': '2026-04-16',
      'status': 'Approved',
    },
    {
      'teacher': 'Ms. Sunita Rao',
      'id': 'TCH003',
      'reason': 'Personal work',
      'from': '2026-04-08',
      'to': '2026-04-08',
      'status': 'Rejected',
    },
  ];

  // ─── Alerts ───────────────────────────────────────────────────
  static List<Map<String, dynamic>> alerts = [
    {
      'message': 'Staff meeting at 4 PM in Conference Hall',
      'target': 'Teachers',
      'time': '2026-04-09 09:00',
      'icon': 'meeting',
    },
    {
      'message': 'Annual Sports Day on April 20th. All students to participate.',
      'target': 'Students',
      'time': '2026-04-08 10:30',
      'icon': 'sports',
    },
    {
      'message': 'Mid-term exam schedule released. Check the portal.',
      'target': 'All',
      'time': '2026-04-07 11:00',
      'icon': 'exam',
    },
    {
      'message': 'Parent-Teacher Meeting on April 25th at 10 AM.',
      'target': 'All',
      'time': '2026-04-06 09:00',
      'icon': 'meeting',
    },
  ];

  // ─── Dashboard Stats ──────────────────────────────────────────
  static Map<String, dynamic> principalStats = {
    'total_students': 1240,
    'students_present': 1102,
    'total_staff': 68,
    'staff_present': 61,
    'classes': 30,
    'today_menu': {
      'date': 'April 9, 2026',
      'primary_dish': 'Rice & Dal',
      'side_dish': 'Aloo Sabzi, Papad',
      'quantity': '1250 plates',
    },
  };
}
