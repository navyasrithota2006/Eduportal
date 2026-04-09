# 🎓 EduPortal — Smarter Management of Schools

A complete Flutter school management app with role-based dashboards for Students, Teachers, and Principals.

---

## 🚀 Quick Start

```bash
cd eduportal
flutter pub get
flutter run
```

---

## 🔐 Demo Credentials

| Role      | ID      | Password |
|-----------|---------|----------|
| Student   | STU001  | pass123  |
| Teacher   | TCH001  | pass123  |
| Principal | PRI001  | pass123  |

---

## 📁 Project Structure

```
lib/
├── main.dart                         ← Original entry point
├── main_v2.dart                      ← Enhanced entry (splash + session restore)
│
├── models/
│   └── user_model.dart
│
├── utils/
│   ├── app_theme.dart                ← Material 3 theme + role colors
│   ├── auth_provider.dart            ← ChangeNotifier auth state
│   ├── mock_data.dart                ← All dummy data
│   └── session_manager.dart          ← SharedPreferences session persistence
│
├── widgets/
│   ├── common_widgets.dart           ← InfoCard, StatusChip, GradeBadge, AvatarCircle…
│   └── app_bar_actions.dart          ← Notification bell + avatar menu (reusable)
│
└── screens/
    ├── splash_screen.dart            ← Animated splash + auto session restore
    ├── auth/
    │   ├── login_screen.dart
    │   └── signup_screen.dart
    ├── student/
    │   ├── student_dashboard.dart    ← 4-tab bottom nav (Blue)
    │   ├── student_home_tab.dart
    │   ├── student_schedule_tab.dart
    │   ├── student_results_tab.dart  ← Original (progress bars)
    │   ├── student_results_chart_tab.dart  ← Enhanced (fl_chart bar chart + donut)
    │   └── student_profile_tab.dart
    ├── teacher/
    │   ├── teacher_dashboard.dart    ← 5-tab bottom nav (Green)
    │   ├── teacher_home_tab.dart
    │   ├── teacher_attendance_tab.dart
    │   ├── teacher_students_tab.dart
    │   ├── teacher_reports_tab.dart
    │   └── teacher_profile_tab.dart
    ├── principal/
    │   ├── principal_dashboard.dart  ← 4-tab bottom nav (Purple)
    │   ├── principal_home_tab.dart
    │   ├── principal_attendance_tab.dart
    │   ├── principal_alerts_tab.dart
    │   ├── principal_profile_tab.dart
    │   └── principal_analytics_screen.dart  ← Full pie + bar chart analytics
    └── shared/
        ├── notifications_screen.dart ← Role-aware notifs + dismiss + mark read
        └── settings_screen.dart      ← Push/email notifs, language, biometric, password
```

---

## 🌟 Feature Matrix

### 🔐 Authentication
- [x] Animated Login screen with role selector (Student / Teacher / Principal)
- [x] Sign-up with full validation (password match, min length, duplicate ID check)
- [x] Auto-login after sign-up
- [x] Session persistence via SharedPreferences
- [x] Animated Splash screen with progress bar

### 🎓 Student Dashboard (4 tabs)
| Tab | Features |
|-----|---------|
| **Home** | Welcome banner, attendance % with progress bar, today's midday meal, upcoming tasks |
| **Schedule** | Week strip date selector, full period-by-period schedule per day |
| **Results** | Fetch by ID + exam type → bar chart + donut progress + grade badges |
| **Profile** | Photo area, student/guardian info, attendance status, edit button |

### 👩‍🏫 Teacher Dashboard (5 tabs)
| Tab | Features |
|-----|---------|
| **Home** | Greeting banner, weekly timetable, day tabs (Mon–Fri), date picker |
| **Attendance** | Grade/section filter, mark all present/absent, toggle per student, submit |
| **Students** | Search + filter by grade/section, bottom sheet detail card |
| **Reports** | Fetch by class/section → expandable cards with mark breakdown |
| **Profile** | Personal info, salary status, leave form + history with status chips |

### 🏫 Principal Dashboard (4 tabs + Analytics)
| Tab | Features |
|-----|---------|
| **Home** | Stats grid (students, staff, classes, leaves), midday meal edit form |
| **Attendance** | 3-tab view: Pending / Approved / Rejected leave requests, approve/reject actions |
| **Alerts** | Compose + broadcast to All/Teachers/Students, swipe to delete alert |
| **Profile** | Contact, branch, salary status |
| **Analytics** | Bar chart (class attendance), pie/donut (grade distribution), staff breakdown |

### 🔔 Shared Features
- [x] Notifications screen (role-aware, unread badge, dismiss to delete, mark all read)
- [x] Settings screen (push/email notifs, dark mode toggle, language picker, biometric, change password)
- [x] AppBar with notification bell badge + avatar popup menu

---

## 📦 Dependencies

```yaml
provider: ^6.1.1           # State management
fl_chart: ^0.66.2          # Bar charts, pie charts, line charts
google_fonts: ^6.1.0       # Typography
intl: ^0.19.0              # Date/number formatting
shared_preferences: ^2.2.2 # Session persistence
```

---

## 🎨 Design System

| Element | Value |
|---------|-------|
| Student color | `#1565C0` Deep Blue |
| Teacher color | `#2E7D32` Forest Green |
| Principal color | `#6A1B9A` Deep Purple |
| Success | `#43A047` |
| Warning | `#FB8C00` |
| Error | `#E53935` |
| Background | `#F5F7FA` |
| Card radius | 16px |
| Button radius | 12px |

---

## 🔧 To Use main_v2.dart (with splash + session restore)

```bash
# Replace main.dart with main_v2.dart
cp lib/main_v2.dart lib/main.dart
flutter run
```

---

## 🗺️ Routing

| Route | Screen |
|-------|--------|
| `/` | SplashScreen (auto-redirects) |
| `/login` | LoginScreen |
| `/student` | StudentDashboard |
| `/teacher` | TeacherDashboard |
| `/principal` | PrincipalDashboard |
| `/analytics` | PrincipalAnalyticsScreen |
| `/settings` | SettingsScreen |
| `/notifications` | NotificationsScreen (arg: role string) |

