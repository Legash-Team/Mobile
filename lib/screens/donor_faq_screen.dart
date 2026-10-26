import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';
import '../l10n/app_localizations.dart';

class DonorFaqItem {
  final String id;
  final String category;
  final String question;
  final String answer;
  final List<String> bulletPoints;

  const DonorFaqItem({
    required this.id,
    required this.category,
    required this.question,
    required this.answer,
    this.bulletPoints = const [],
  });
}

class DonorFaqScreen extends StatefulWidget {
  const DonorFaqScreen({super.key});

  @override
  State<DonorFaqScreen> createState() => _DonorFaqScreenState();
}

class _DonorFaqScreenState extends State<DonorFaqScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategoryId = 'all';
  final Set<String> _expandedIds = {'faq-1', 'faq-3', 'faq-8'};

  static const List<DonorFaqItem> _faqsEn = [
    DonorFaqItem(
      id: 'faq-1',
      category: 'Registration & Login',
      question: 'How do I register as a donor and verify my phone number via OTP?',
      answer:
          'To sign up on Legash, enter your full name and valid Ethiopian phone number. A 6-digit One-Time Password (OTP) is sent via SMS to verify your mobile number. Once verified, you will be prompted to create a 4-digit security PIN for fast and safe access to your donor account.',
      bulletPoints: [
        'Enter valid mobile phone number and full name',
        'Receive and input 6-digit SMS OTP for verification',
        'Set up a 4-digit PIN for future logins',
      ],
    ),
    DonorFaqItem(
      id: 'faq-2',
      category: 'Registration & Login',
      question: 'How does PIN security and login work?',
      answer:
          'Your account is secured by your registered phone number and your 4-digit secret PIN. Every time you open the app or after logging out, you authenticate using your PIN. You can change your PIN from your Profile screen under Security settings whenever needed.',
      bulletPoints: [
        'Fast 4-digit PIN unlock replaces long passwords',
        'Can be updated under Profile > Security',
        'Keep your PIN confidential to protect your donation records',
      ],
    ),
    DonorFaqItem(
      id: 'faq-3',
      category: 'Blood Type & Compatibility',
      question: 'How do I set or update my blood type?',
      answer:
          'You can set your blood type (A+, A-, B+, B-, AB+, AB-, O+, O-) during initial profile registration or subsequently from your Profile screen. Having an accurate blood type ensures Legash can match you with urgent hospital requests that are clinically compatible with your blood group.',
      bulletPoints: [
        'Select from 8 ABO/Rh blood groups: A+, A-, B+, B-, AB+, AB-, O+, O-',
        'Update anytime from Profile screen',
        'Crucial for receiving accurate emergency donation matches',
      ],
    ),
    DonorFaqItem(
      id: 'faq-4',
      category: 'Blood Type & Compatibility',
      question: 'What if I selected "I don\'t know my blood type"?',
      answer:
          'If you are uncertain of your ABO or Rh blood group, choose "I don\'t know my blood type". While you can still browse blood centers, community events, and wellness tips, emergency matching alerts remain inactive until your blood type is confirmed and updated.',
      bulletPoints: [
        'Allows immediate account registration without guessing',
        'Visit any regional blood center for free, confidential typing',
        'Update your profile once your blood group is determined',
      ],
    ),
    DonorFaqItem(
      id: 'faq-5',
      category: 'Blood Type & Compatibility',
      question: 'How does blood compatibility work on Legash?',
      answer:
          'Blood compatibility follows standard ABO and Rh transfusion rules. For example, O- is the universal red cell donor and can donate to all blood groups, while AB+ is the universal recipient. The Blood Compatibility card on your dashboard visualizes exactly which blood types you can donate to and receive from.',
      bulletPoints: [
        'Dashboard explainer shows both "Donate to" and "Receive from"',
        'O- donors can donate to all 8 blood groups',
        'AB+ donors can receive from all 8 blood groups',
      ],
    ),
    DonorFaqItem(
      id: 'faq-6',
      category: 'Centers & Navigation',
      question: 'How do I find nearby blood centers and transfusion facilities?',
      answer:
          'From your dashboard, tap "Nearby Centers" in the quick navigation bar or open the directory. You will see a list of verified blood banks and transfusion centers ordered by proximity, complete with address details, opening hours, and direct telephone contact.',
      bulletPoints: [
        'Quick navigation chip on your dashboard',
        'Displays nearest verified blood bank centers',
        'Provides directions, phone numbers, and operating schedules',
      ],
    ),
    DonorFaqItem(
      id: 'faq-7',
      category: 'Requests & Donations',
      question: 'How do request notifications work, and how do I accept a donation request?',
      answer:
          'When a nearby hospital issues an emergency blood request matching your blood group, you receive an instant push notification and in-app alert. Under the Requests tab or Notifications page, review the hospital name, required blood type, urgency level, and distance. Tap "Accept" to commit to donating.',
      bulletPoints: [
        'Instant notifications for matching emergency requests',
        'Inspect hospital location, urgency, and units requested',
        'Tap "Accept" to notify the hospital triage team of your arrival',
      ],
    ),
    DonorFaqItem(
      id: 'faq-8',
      category: 'Requests & Donations',
      question: 'What is donor eligibility and the 90-day donation cooldown?',
      answer:
          'To safeguard donor health and replenish iron reserves, whole blood donations require a mandatory 90-day cooldown period between successful donations. During this 90-day window, your status displays as resting and you will not receive emergency broadcast requests until the cooldown completes.',
      bulletPoints: [
        '90-day rest interval between whole blood donations',
        'Ensures healthy hemoglobin replenishment and recovery',
        'Countdown timer visible on your dashboard and history',
      ],
    ),
    DonorFaqItem(
      id: 'faq-9',
      category: 'Profile & Settings',
      question: 'How do I update my profile information and phone number?',
      answer:
          'Open the Profile tab from the bottom navigation bar. You can edit your display name, location, and emergency contacts. For security and anti-fraud validation, changing your registered telephone number requires re-verification via SMS OTP.',
      bulletPoints: [
        'Edit display name and contact preferences in Profile',
        'Phone number updates require SMS OTP authentication',
        'Keep information up to date to receive localized requests',
      ],
    ),
    DonorFaqItem(
      id: 'faq-10',
      category: 'Requests & Donations',
      question: 'Where can I view my donation history and past outcomes?',
      answer:
          'Tap "Donation History" on your dashboard. This screen records every donation milestone, including the hospital or blood bank, donation date, units contributed, and clinical status (Completed or Deferred). Each verified donation contributes to your community lifesaving count.',
      bulletPoints: [
        'Full timeline of past donations and centers visited',
        'Tracks your verified lifesaving impact score',
        'Indicates the exact date your next donation eligibility opens',
      ],
    ),
    DonorFaqItem(
      id: 'faq-11',
      category: 'Community & Events',
      question: 'How do community blood drives and events work?',
      answer:
          'Tap the "Events" tab in the bottom navigation bar to view scheduled blood donation campaigns, mobile blood drives, and community health fairs organized by regional blood centers. You can see event dates, venues, organizer contact info, and directions.',
      bulletPoints: [
        'Dedicated Events tab in bottom navigation',
        'Active drives and upcoming mobile blood buses in your region',
        'Clear venue locations, target dates, and blood bank contacts',
      ],
    ),
    DonorFaqItem(
      id: 'faq-12',
      category: 'Health & Wellness',
      question: 'What is the Health page and how does it help donors?',
      answer:
          'The Health page (accessible from the bottom navigation bar) provides practical wellness and nutrition tips to help donors stay healthy before and after giving blood. It includes suggestions for iron-rich foods, vitamin C intake, hydration guidelines, post-donation recovery, and activity guidance tailored for donor wellbeing.',
      bulletPoints: [
        'Dedicated Health tab replacing previous news feeds',
        'Foods that support healthy hemoglobin and iron levels',
        'Hydration, post-donation rest, and mindful activity tips',
        'General wellness guidance (not medical prescription)',
      ],
    ),
    DonorFaqItem(
      id: 'faq-13',
      category: 'Security & Privacy',
      question: 'How are my notifications, privacy, and account security protected?',
      answer:
          'Legash treats donor medical and contact data with utmost confidentiality. Your location is used strictly to compute approximate proximity to emergency requests. You can toggle notification preferences or request complete account deletion from the Profile settings under Privacy & Account.',
      bulletPoints: [
        'End-to-end encrypted session authentication',
        'Location used solely for distance matching, never public tracking',
        'Account deletion available under Profile settings',
      ],
    ),
  ];

  static const List<DonorFaqItem> _faqsAm = [
    DonorFaqItem(
      id: 'faq-1',
      category: 'ምዝገባ እና መግቢያ',
      question: 'እንዴት እንደ ለጋሽ እመዘገባለሁ እና ስልክ ቁጥሬን በኦቲፒ (OTP) አረጋግጣለሁ?',
      answer:
          'በለጋሽ ላይ ለመመዝገብ ሙሉ ስምዎን እና ትክክለኛ የኢትዮጵያ ስልክ ቁጥርዎን ያስገቡ። የስልክ ቁጥርዎን ለማረጋገጥ ባለ 6 አሃዝ የአንድ ጊዜ የይለፍ ቃል (OTP) በኤስኤምኤስ ይላካል። አንዴ ከተረጋገጠ በኋላ ወደ ለጋሽ መለያዎ ፈጣን እና ደህንነቱ የተጠበቀ መዳረሻ ለማግኘት ባለ 4 አሃዝ የደህንነት ፒን እንዲፈጥሩ ይጠየቃሉ።',
      bulletPoints: [
        'ትክክለኛ የስልክ ቁጥር እና ሙሉ ስም ያስገቡ',
        'ለማረጋገጫ ባለ 6 አሃዝ የኤስኤምኤስ ኦቲፒ ተቀብለው ያስገቡ',
        'ለወደፊት መግቢያዎች ባለ 4 አሃዝ ፒን ያዘጋጁ',
      ],
    ),
    DonorFaqItem(
      id: 'faq-2',
      category: 'ምዝገባ እና መግቢያ',
      question: 'የፒን ደህንነት እና የመግቢያ ሂደት እንዴት ይሰራል?',
      answer:
          'መለያዎ በተመዘገበው ስልክ ቁጥርዎ እና በሚስጥራዊ ባለ 4 አሃዝ ፒንዎ የተጠበቀ ነው። መተግበሪያውን በከፈቱ ቁጥር ወይም ከወጡ በኋላ ፒንዎን በመጠቀም ማንነትዎን ያረጋግጣሉ። አስፈላጊ ሆኖ ሲገኝ በማንኛውም ጊዜ ፒንዎን ከመገለጫ ማያዎ በደህንነት ቅንብሮች ስር መቀየር ይችላሉ።',
      bulletPoints: [
        'ፈጣን ባለ 4 አሃዝ ፒን ረጅም የይለፍ ቃሎችን ይተካል',
        'በመገለጫ > ደህንነት ስር በማንኛውም ጊዜ ማዘመን ይቻላል',
        'የልገሳ መዝገቦችዎን ለመጠበቅ ፒንዎን በሚስጥር ይያዙ',
      ],
    ),
    DonorFaqItem(
      id: 'faq-3',
      category: 'የደም ዓይነት እና ተኳሃኝነት',
      question: 'የደም ዓይነቴን እንዴት ማዘጋጀት ወይም ማዘመን እችላለሁ?',
      answer:
          'የደም ዓይነትዎን (A+, A-, B+, B-, AB+, AB-, O+, O-) በመጀመሪያው የመገለጫ ምዝገባ ወቅት ወይም በመቀጠል ከመገለጫ ማያዎ ማዘጋጀት ይችላሉ። ትክክለኛ የደም ዓይነት መኖሩ ለጋሽ ከደም ቡድንዎ ጋር በክሊኒካዊ መልኩ ተኳሃኝ ከሆኑ አስቸኳይ የሆስፒታል ጥያቄዎች ጋር እንዲያዛምድዎት ያረጋግጣል።',
      bulletPoints: [
        'ከ8ቱ የ ABO/Rh የደም ቡድኖች ይምረጡ፦ A+, A-, B+, B-, AB+, AB-, O+, O-',
        'በማንኛውም ጊዜ ከመገለጫ ገጽዎ ማዘመን ይችላሉ',
        'ትክክለኛ የአደጋ ጊዜ የልገሳ ጥሪዎችን ለመቀበል ወሳኝ ነው',
      ],
    ),
    DonorFaqItem(
      id: 'faq-4',
      category: 'የደም ዓይነት እና ተኳሃኝነት',
      question: '"የደም ዓይነቴን አላውቅም" የሚለውን ከመረጥኩ ምን ይሆናል?',
      answer:
          'ስለ ደም ቡድንዎ እርግጠኛ ካልሆኑ "የደም ዓይነቴን አላውቅም" የሚለውን ይምረጡ። አሁንም የደም ማዕከላትን፣ የማህበረሰብ ዝግጅቶችን እና የጤና ምክሮችን ማሰስ ቢችሉም፣ የደም ዓይነትዎ ተረጋግጦ እስኪዘመን ድረስ የአደጋ ጊዜ የማዛመጃ ማሳወቂያዎች ንቁ አይሆኑም።',
      bulletPoints: [
        'ሳይገምቱ ወዲያውኑ መለያ ለመመዝገብ ያስችላል',
        'በነጻ እና በሚስጥር ለመመርመር ማንኛውንም የክልል የደም ማዕከል ይጎብኙ',
        'የደም ቡድንዎ ከተረጋገጠ በኋላ መገለጫዎን ያዘምኑ',
      ],
    ),
    DonorFaqItem(
      id: 'faq-5',
      category: 'የደም ዓይነት እና ተኳሃኝነት',
      question: 'የደም ተኳሃኝነት በለጋሽ ላይ እንዴት ይሰራል?',
      answer:
          'የደም ተኳሃኝነት መደበኛውን የ ABO እና Rh ደም መስጠት ደንቦችን ይከተላል። ለምሳሌ፣ O- አለም አቀፍ የቀይ ሴል ለጋሽ ሲሆን ለሁሉም የደም ቡድኖች መለገስ ይችላል፤ AB+ ደግሞ አለም አቀፍ ተቀባይ ነው። በዳሽቦርድዎ ላይ ያለው የደም ተኳሃኝነት ካርድ ለማን መለገስ እና ከማን መቀበል እንደሚችሉ በግልጽ ያሳያል።',
      bulletPoints: [
        'ዳሽቦርዱ "መለገስ የሚችሉበት" እና "መቀበል የሚችሉበት" ቡድኖችን ያሳያል',
        'የ O- ለጋሾች ለሁሉም 8 የደም ቡድኖች መለገስ ይችላሉ',
        'የ AB+ ለጋሾች ከሁሉም 8 የደም ቡድኖች መቀበል ይችላሉ',
      ],
    ),
    DonorFaqItem(
      id: 'faq-6',
      category: 'የደም ማዕከላት እና አቅጣጫ',
      question: 'የአቅራቢያ የደም ማዕከላትን እና የህክምና ተቋማትን እንዴት ማግኘት እችላለሁ?',
      answer:
          'ከዳሽቦርድዎ፣ በፍጥነት መፈለጊያ አሞሌው ላይ "አቅራቢያ ማዕከላት" የሚለውን ይንኩ ወይም ማውጫውን ይክፈቱ። በርቀት የተደረደሩ የተረጋገጡ የደም ባንኮች እና የማዕከላት ዝርዝር ከአድራሻ፣ የስራ ሰዓት እና የቀጥታ ስልክ ቁጥር ጋር ያገኛሉ።',
      bulletPoints: [
        'በዳሽቦርድዎ ላይ ፈጣን የመፈለጊያ ቁልፍ',
        'በጣም ቅርብ የሆኑ የተረጋገጡ የደም ባንክ ማዕከላትን ያሳያል',
        'አቅጣጫዎችን፣ ስልክ ቁጥሮችን እና የስራ ሰዓቶችን ያቀርባል',
      ],
    ),
    DonorFaqItem(
      id: 'faq-7',
      category: 'ጥያቄዎች እና ልገሳዎች',
      question: 'የጥያቄ ማሳወቂያዎች እንዴት ይሰራሉ፣ እና የልገሳ ጥሪን እንዴት መቀበል እችላለሁ?',
      answer:
          'አቅራቢያዎ የሚገኝ ሆስፒታል ከደም ቡድንዎ ጋር የሚዛመድ የአደጋ ጊዜ የደም ጥያቄ ሲያቀርብ፣ ፈጣን ማሳወቂያ እና የመተግበሪያ ማንቂያ ይደርስዎታል። በጥያቄዎች ትር ስር የሆስፒታሉን ስም፣ የሚፈለገውን የደም ዓይነት፣ የአጣዳፊነት ደረጃ እና ርቀቱን ይመልከቱ። ለመለገስ ቃል ለመግባት "ተቀበል" የሚለውን ይጫኑ።',
      bulletPoints: [
        'ለሚዛመዱ የአደጋ ጊዜ ጥያቄዎች ፈጣን ማሳወቂያዎች',
        'የሆስፒታሉን አድራሻ፣ አጣዳፊነት እና የሚፈለጉ ክፍሎችን ይመልከቱ',
        'የመምጣትዎን ሁኔታ ለሆስፒታሉ ለማሳወቅ "ተቀበል" የሚለውን ይጫኑ',
      ],
    ),
    DonorFaqItem(
      id: 'faq-8',
      category: 'ጥያቄዎች እና ልገሳዎች',
      question: 'የለጋሽ ብቃት እና የ90 ቀናት የልገሳ እረፍት ምንድን ነው?',
      answer:
          'የለጋሾችን ጤና ለመጠበቅ እና የብረት ክምችትን ለመተካት፣ ሙሉ ደም ከለገሱ በኋላ የግዴታ የ90 ቀናት የእረፍት ጊዜ ያስፈልጋል። በዚህ የ90 ቀናት መስኮት ውስጥ ሁኔታዎ እንደሚያርፍ ይታያል እና እረፍቱ እስኪጠናቀቅ ድረስ የአደጋ ጊዜ ጥሪዎች አይደርስዎትም።',
      bulletPoints: [
        'በሙሉ ደም ልገሳዎች መካከል የ90 ቀናት የግዴታ የእረፍት ጊዜ',
        'ጤናማ የሄሞግሎቢን መተካት እና ማገገምን ያረጋግጣል',
        'የቀናት ቆጣሪ በዳሽቦርድዎ እና በታሪክዎ ላይ ይታያል',
      ],
    ),
    DonorFaqItem(
      id: 'faq-9',
      category: 'መገለጫ እና ቅንብሮች',
      question: 'የመገለጫ መረጃዬን እና ስልክ ቁጥሬን እንዴት ማዘመን እችላለሁ?',
      answer:
          'ከታችኛው አሞሌ የመገለጫ ትርን ይክፈቱ። የማሳያ ስምዎን፣ አካባቢዎን እና የአደጋ ጊዜ አድራሻዎችን ማርትዕ ይችላሉ። ለደህንነት እና ለማጭበርበር መከላከል፣ የተመዘገበውን ስልክ ቁጥር መቀየር በኤስኤምኤስ ኦቲፒ በኩል እንደገና ማረጋገጥን ይጠይቃል።',
      bulletPoints: [
        'በመገለጫ ውስጥ ስም እና አድራሻዎችን ያርትዑ',
        'የስልክ ቁጥር ማሻሻያ በኤስኤምኤስ ኦቲፒ ማረጋገጫ ይፈልጋል',
        'አካባቢያዊ ጥያቄዎችን ለመቀበል መረጃዎን ወቅታዊ ያድርጉ',
      ],
    ),
    DonorFaqItem(
      id: 'faq-10',
      category: 'ጥያቄዎች እና ልገሳዎች',
      question: 'የልገሳ ታሪኬን እና ያለፉ ውጤቶችን የት ማየት እችላለሁ?',
      answer:
          'በዳሽቦርድዎ ላይ "የልገሳ ታሪክ" የሚለውን ይንኩ። ይህ ማያ ገጽ ሆስፒታሉን ወይም የደም ባንኩን፣ የተለገሰበትን ቀን፣ የተሰጡ ክፍሎችን እና ክሊኒካዊ ሁኔታን (የተጠናቀቀ ወይም የተላለፈ) ጨምሮ እያንዳንዱን ልገሳ ይመዘግባል። እያንዳንዱ የተረጋገጠ ልገሳ ለማህበረሰብ ህይወት አድን ቁጥርዎ አስተዋፅኦ ያደርጋል።',
      bulletPoints: [
        'ያለፉት ልገሳዎች እና የተጎበኙ ማዕከላት ሙሉ ታሪክ',
        'የተረጋገጠውን የህይወት አድን ተፅዕኖዎን ውጤት ይከታተላል',
        'ቀጣዩ የልገሳ ብቃትዎ የሚከፈትበትን ትክክለኛ ቀን ያሳያል',
      ],
    ),
    DonorFaqItem(
      id: 'faq-11',
      category: 'ማህበረሰብ እና ክስተቶች',
      question: 'የማህበረሰብ የደም ልገሳ ዘመቻዎች እና ክስተቶች እንዴት ይሰራሉ?',
      answer:
          'በክልል የደም ማዕከላት የሚዘጋጁ የታቀዱ የደም ልገሳ ዘመቻዎችን፣ የሞባይል ደም አውቶቡሶችን እና የማህበረሰብ ጤና ዝግጅቶችን ለማየት ከታች ባለው አሞሌ ላይ "ክስተቶች" የሚለውን ይንኩ። የዝግጅቱን ቀናት፣ ቦታዎች፣ የአዘጋጅ አድራሻዎችን እና አቅጣጫዎችን ማየት ይችላሉ።',
      bulletPoints: [
        'በታችኛው አሞሌ ላይ የተወሰነ የክስተቶች ትር',
        'በአካባቢዎ ያሉ ንቁ ዘመቻዎች እና መጪ የሞባይል ደም አውቶቡሶች',
        'ግልጽ የቦታ አድራሻዎች፣ የታለሙ ቀናት እና የደም ባንክ እውቂያዎች',
      ],
    ),
    DonorFaqItem(
      id: 'faq-12',
      category: 'ጤና እና ደህንነት',
      question: 'የጤና ገጽ ምንድን ነው እና ለጋሾችን እንዴት ይረዳል?',
      answer:
          'የጤና ገጽ ለጋሾች ደም ከመስጠታቸው በፊት እና በኋላ ጤናማ ሆነው እንዲቆዩ ተግባራዊ የጤንነት እና የአመጋገብ ምክሮችን ይሰጣል። በብረት የበለፀጉ ምግቦችን፣ የቫይታሚን ሲ አወሳሰድን፣ የፈሳሽ መመሪያዎችን፣ ከልገሳ በኋላ ማገገምን እና ለለጋሾች ደህንነት ተስማሚ የሆኑ እንቅስቃሴዎችን ያካትታል።',
      bulletPoints: [
        'የቀድሞውን ዜናዎች የተካ የተለየ የጤና ትር',
        'ጤናማ ሄሞግሎቢንን እና የብረት ደረጃን የሚደግፉ ምግቦች',
        'የውሃ አወሳሰድ፣ ከልገሳ በኋላ እረፍት እና የጥንቃቄ ምክሮች',
        'አጠቃላይ የጤንነት መመሪያ (የህክምና ማዘዣ አይደለም)',
      ],
    ),
    DonorFaqItem(
      id: 'faq-13',
      category: 'ደህንነት እና ግላዊነት',
      question: 'ማሳወቂያዎቼ፣ ግላዊነቴ እና የመለያ ደህንነቴ እንዴት ይጠበቃሉ?',
      answer:
          'ለጋሽ የለጋሾችን የህክምና እና የእውቂያ መረጃዎች በከፍተኛ ሚስጥራዊነት ይይዛል። አካባቢዎ ጥቅም ላይ የሚውለው ለአደጋ ጊዜ ጥያቄዎች ግምታዊ ርቀትን ለማስላት ብቻ ነው። የማሳወቂያ ምርጫዎችን ማስተካከል ወይም ከመገለጫ ቅንብሮች ስር መለያዎን ሙሉ በሙሉ መሰረዝ ይችላሉ።',
      bulletPoints: [
        'ከጫፍ እስከ ጫፍ የተመሰጠረ የመግቢያ ደህንነት',
        'አካባቢ ጥቅም ላይ የሚውለው ለርቀት ማዛመድ ብቻ እንጂ ለህዝብ ክትትል አይደለም',
        'የመለያ ስረዛ በመገለጫ ቅንብሮች ስር ይገኛል',
      ],
    ),
  ];

  static const List<DonorFaqItem> _faqsOm = [
    DonorFaqItem(
      id: 'faq-1',
      category: 'Galmee & Seensa',
      question: 'Akkamitti akka arjoomaatti galmaa\'ee bilbila koo OTP\'n mirkaneessa?',
      answer:
          'Legaash irratti galmaa\'uuf maqaa guutuu fi lakkoofsa bilbila Itoophiyaa sirrii galchaa. Lakkoofsa mobaayila keessan mirkaneessuuf koodiin OTP dijitii 6 qabu SMS\'n ni ergama. Erga mirkanaa\'ee booda gara herrega keessaniitti saffisaan seenuuf PIN icciitii dijitii 4 qabu akka uumtan isin gaafata.',
      bulletPoints: [
        'Lakkoofsa bilbilaa sirrii fi maqaa guutuu galchaa',
        'Mirkaneessaaf koodii OTP dijitii 6 SMS\'n ergame galchaa',
        'Seensa gara fuulduraatiif PIN dijitii 4 qopheessaa',
      ],
    ),
    DonorFaqItem(
      id: 'faq-2',
      category: 'Galmee & Seensa',
      question: 'Nageenyi PIN fi seensi akkamitti hojjeta?',
      answer:
          'Herregni keessan lakkoofsa bilbilaa fi PIN icciitii dijitii 4 qabuun kan eegameedha. Yeroo appilikeeshinii bantanii fi yeroo baatan hunda PIN keessan galchuun seentu. Yeroo barbaaddanitti fuula Piroofayilii jalatti qindaa\'ina Nageenyaa keessaa PIN keessan jijjiiruu dandeessu.',
      bulletPoints: [
        'PIN dijitii 4 jecha icciitii dheeraa bakka bu\'a',
        'Piroofayilii > Nageenya jalatti haaromsuun ni danda\'ama',
        'Galmee arjooma keessanii eeguuf PIN keessan icciitiin qabadhaa',
      ],
    ),
    DonorFaqItem(
      id: 'faq-3',
      category: 'Gosa Dhiigaa & Walsimsiisa',
      question: 'Gosa dhiiga koo akkamitti murteessaa yookiin haaromsa?',
      answer:
          'Gosa dhiiga keessanii (A+, A-, B+, B-, AB+, AB-, O+, O-) yeroo galmee duraa yookiin fuula Piroofayilii irraa murteessuu dandeessu. Gosa dhiigaa sirrii qabaachuun Legaashiin gaaffilee hospitaalaa ariifachiisaa walsimoo ta\'an wajjin akka walitti isin fidu mirkaneessa.',
      bulletPoints: [
        'Gosoota dhiigaa 8n keessaa filadhaa: A+, A-, B+, B-, AB+, AB-, O+, O-',
        'Yeroo kamiyyuu fuula Piroofayilii irraa haaromsaa',
        'Waamicha arjooma ariifachiisaa sirrii argachuuf murteessaadha',
      ],
    ),
    DonorFaqItem(
      id: 'faq-4',
      category: 'Gosa Dhiigaa & Walsimsiisa',
      question: '"Gosa dhiiga koo hin beeku" yoon jedhe maaltu ta\'a?',
      answer:
          'Gosa dhiiga keessanii yoo hin beekne "Gosa dhiiga koo hin beeku" kan jedhu filadhaa. Wiirtuuwwan dhiigaa, sagantaalee hawaasaa fi gorsa fayyaa ilaaluu kan dandeessan ta\'us, gosi dhiiga keessanii mirkanaa\'ee hanga haaromfamutti beeksisni walitti-fiduu tasaa hin hojjetu.',
      bulletPoints: [
        'Osoo hin tilmaamin yeruma sana galmaa\'uuf gargaara',
        'Tola qoramuuf wiirtuu dhiigaa naannoo kamiyyuu daawwadhaa',
        'Gosa dhiiga keessan yoo bartan piroofayilii keessan haaromsaa',
      ],
    ),
    DonorFaqItem(
      id: 'faq-5',
      category: 'Gosa Dhiigaa & Walsimsiisa',
      question: 'Walsimsiisni dhiigaa Legaash irratti akkamitti hojjeta?',
      answer:
          'Walsimsiisni dhiigaa seera dabarsa dhiigaa ABO fi Rh hordofa. Fakkeenyaaf, O- arjoomaa seelii dhiiga diimaa addunyaa yoo ta\'u gosoota dhiigaa hundaaf arjoomuu danda\'a; AB+ immoo fudhataa addunyaati. Kaardiin daashboordii keessan irratti argamu eenyuuf arjoomuu fi eenyurraa fudhachuu akka dandeessan ifatti agarsiisa.',
      bulletPoints: [
        'Daashboordiin "Kanneeniif arjoomuu" fi "Kanneen irraa fudhachuu" agarsiisa',
        'Arjoomtoonni O- gosoota dhiigaa 8n hundaaf arjoomuu danda\'u',
        'Arjoomtoonni AB+ gosoota dhiigaa 8n hunda irraa fudhachuu danda\'u',
      ],
    ),
    DonorFaqItem(
      id: 'faq-6',
      category: 'Wiirtuuwwan & Qajeelcha',
      question: 'Wiirtuuwwan dhiigaa dhihoo jiran akkamitti argadha?',
      answer:
          'Daashboordii keessan irraa sarara barbaachaa irratti "Wiirtuuwwan Dhihoo" tuqaa yookiin galmee banaa. Tarree baankii dhiigaa fageenyaan qindaa\'e teessoo, sa\'aatii hojii fi lakkoofsa bilbilaa wajjin ni argitu.',
      bulletPoints: [
        'Daashboordii irratti qabduu barbaacha saffisaa',
        'Baankii dhiigaa mirkanaa\'an kanneen dhihoo jiran agarsiisa',
        'Qajeelcha kallattii, bilbila fi sa\'aatii hojii dhiyeessa',
      ],
    ),
    DonorFaqItem(
      id: 'faq-7',
      category: 'Gaaffilee & Arjooma',
      question: 'Beeksisni gaaffii akkamitti hojjeta, gaaffii arjoomaa akkamitti fudhadha?',
      answer:
          'Hospitaalli dhihoo jiru gaaffii dhiigaa ariifachiisaa gosa dhiiga keessaniin walsimu yeroo baasu, beeksisni battalaa isiniif ergama. Kutaa Gaaffilee jalatti maqaa hospitaalaa, gosa dhiigaa barbaadamu, sadarkaa ariifachiisummaa fi fageenya ilaalaa. Arjoomuuf waadaa galuuf "Fudhadhu" tuqaa.',
      bulletPoints: [
        'Gaaffilee ariifachiisaa walsimaniif beeksisa battalaa',
        'Bakka hospitaalaa, ariifachiisummaa fi yuunitii barbaadamu ilaalaa',
        'Gareen hospitaalaa akka qophaa\'uuf "Fudhadhu" tuqaa',
      ],
    ),
    DonorFaqItem(
      id: 'faq-8',
      category: 'Gaaffilee & Arjooma',
      question: 'Ga\'umsa arjoomaa fi boqonnaan guyyoota 90 maalidha?',
      answer:
          'Fayyaa arjoomaa eeguu fi kuusaa sibiilaa bakka buusuuf, arjooma dhiiga guutuu booda boqonnaa guyyaa 90 fudhachuun dirqama. Guyyoota 90 kana keessatti haalli keessan boqonnaa irratti akka jiru mul\'ata; hanga boqonnaan xumuramutti gaaffiin tasaa isin hin qaqqabu.',
      bulletPoints: [
        'Arjoomawwan dhiiga guutuu gidduutti boqonnaa dirqamaa guyyaa 90',
        'Heemoogiloobiinii deebisanii guutuu fi bayyanannaa mirkaneessa',
        'Lakkoofsi guyyootaa daashboordii fi seenaa keessan irratti mul\'ata',
      ],
    ),
    DonorFaqItem(
      id: 'faq-9',
      category: 'Piroofayilii & Qindaa\'inoota',
      question: 'Odeeffannoo piroofayilii fi bilbila koo akkamitti haaromsa?',
      answer:
          'Sarara gadii irraa kutaa Piroofayilii banaa. Maqaa, bakka fi bilbila nama yeroo balaa qunnamamu gulaaluu dandeessu. Nageenyaaf jecha lakkoofsa bilbilaa galmaa\'e jijjiiruun SMS OTP\'n deebisanii mirkaneessuu barbaada.',
      bulletPoints: [
        'Piroofayilii keessatti maqaa fi teessoo gulaalaa',
        'Bilbila haaromsuuf mirkaneessi SMS OTP barbaachisaadha',
        'Gaaffilee naannoo argachuuf ragaa keessan yeroon haaromsaa',
      ],
    ),
    DonorFaqItem(
      id: 'faq-10',
      category: 'Gaaffilee & Arjooma',
      question: 'Seenaa arjooma koo fi bu\'aawwan darban eessatti ilaala?',
      answer:
          'Daashboordii irratti "Seenaa Arjoomaa" tuqaa. Fuulli kun hospitaala, guyyaa arjoomaa, yuunitii kenname fi haala yaalaa galmeessa. Arjoomni mirkanaa\'e hundi lakkoofsa lubbuu baraaruu keessaniif gumaacha godha.',
      bulletPoints: [
        'Seenaa guutuu arjoomawwan darbanii fi wiirtuuwwan daawwatamanii',
        'Qabxii gumaacha lubbuu baraaruu keessanii hordofa',
        'Guyyaa ga\'umsi arjooma itti aanu itti banamu sirriitti agarsiisa',
      ],
    ),
    DonorFaqItem(
      id: 'faq-11',
      category: 'Hawaasa & Sagantaalee',
      question: 'Duulli arjooma hawaasaa fi sagantaaleen akkamitti hojjetu?',
      answer:
          'Duula arjooma dhiigaa qophaa\'an, baabura dhiigaa mobaayilaa fi sagantaalee fayyaa hawaasaa ilaaluuf sarara gadii irraa "Sagantaalee" tuqaa. Guyyoota sagantaa, bakka, bilbila qindeessitootaa fi qajeelcha kallattii argachuu dandeessu.',
      bulletPoints: [
        'Sarara gadii irratti kutaa Sagantaalee addaa',
        'Duulawwan naannoo keessatti hojiirra jiraniifi dhufaa jiran',
        'Bakka ifaa, guyyoota fi qunnamtii baankii dhiigaa',
      ],
    ),
    DonorFaqItem(
      id: 'faq-12',
      category: 'Fayyaa & Nageenya',
      question: 'Fuulli Fayyaa maalidha, arjoomtoota akkamitti gargaara?',
      answer:
          'Fuulli Fayyaa (sarara gadii irraa kan argamu) arjoomtoonni dhiiga kennuun duraa fi booda nagaan akka turan gorsa fayyaa fi nyaataa qabatamaa kenna. Nyaata sibiila qabu, vaayitaaminii C, bishaan dhuguu, fi sochii arjoomtootaaf ta\'u hammata.',
      bulletPoints: [
        'Oduu darbe bakka bu\'uun kutaa Fayyaa qophaa\'e',
        'Nyaatawwan heemoogiloobiinii fi sibiila deeggaran',
        'Bishaan dhuguu, boqonnaa fi gorsa of-eeggannoo',
        'Gorsa fayyaa waliigalaa (ajaja yaalaa miti)',
      ],
    ),
    DonorFaqItem(
      id: 'faq-13',
      category: 'Nageenya & Dhuunfaa',
      question: 'Beeksisni, dhuunfaan fi nageenyi herrega koo akkamitti eegamu?',
      answer:
          'Legaashiin ragaalee yaalaa fi qunnamtii arjoomtootaa icciitii cimaadhaan qaba. Bakki keessan fageenya gaaffii balaa tasaa shallaguuf qofa gargaara. Qindaa\'ina beeksisaa to\'achuu yookiin herrega keessan guutummaatti haquu dandeessu.',
      bulletPoints: [
        'Seensa nageenyaan cufamee mirkanaa\'e',
        'Bakki fageenya madaaluuf qofa oola malee hordoffiif miti',
        'Herrega haquun qindaa\'ina Piroofayilii jalatti ni danda\'ama',
      ],
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DonorFaqItem> _getFaqs(String lang) {
    if (lang == 'am') return _faqsAm;
    if (lang == 'om') return _faqsOm;
    return _faqsEn;
  }

  List<DonorFaqItem> _filteredFaqs(List<DonorFaqItem> faqs, String lang) {
    final query = _searchController.text.trim().toLowerCase();
    return faqs.where((faq) {
      final matchesCategory = _selectedCategoryId == 'all' ||
          _matchesCategory(faq.id, _selectedCategoryId);
      final matchesQuery = query.isEmpty ||
          faq.question.toLowerCase().contains(query) ||
          faq.answer.toLowerCase().contains(query) ||
          faq.category.toLowerCase().contains(query) ||
          faq.bulletPoints.any((pt) => pt.toLowerCase().contains(query));
      return matchesCategory && matchesQuery;
    }).toList();
  }

  bool _matchesCategory(String faqId, String categoryId) {
    switch (categoryId) {
      case 'reg':
        return faqId == 'faq-1' || faqId == 'faq-2';
      case 'blood':
        return faqId == 'faq-3' || faqId == 'faq-4' || faqId == 'faq-5';
      case 'requests':
        return faqId == 'faq-7' || faqId == 'faq-8' || faqId == 'faq-10';
      case 'health':
        return faqId == 'faq-12';
      case 'centers':
        return faqId == 'faq-6';
      case 'community':
        return faqId == 'faq-11';
      case 'security':
        return faqId == 'faq-9' || faqId == 'faq-13';
      default:
        return true;
    }
  }

  void _toggleExpanded(String id) {
    setState(() {
      if (_expandedIds.contains(id)) {
        _expandedIds.remove(id);
      } else {
        _expandedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final allFaqs = _getFaqs(lang);
    final filtered = _filteredFaqs(allFaqs, lang);

    final categories = lang == 'am'
        ? const [
            {'id': 'all', 'label': 'ሁሉም'},
            {'id': 'reg', 'label': 'ምዝገባ እና መግቢያ'},
            {'id': 'blood', 'label': 'የደም ዓይነት እና ተኳሃኝነት'},
            {'id': 'requests', 'label': 'ጥያቄዎች እና ልገሳዎች'},
            {'id': 'health', 'label': 'ጤና እና ደህንነት'},
            {'id': 'centers', 'label': 'የደም ማዕከላት'},
            {'id': 'community', 'label': 'ማህበረሰብ እና ክስተቶች'},
            {'id': 'security', 'label': 'ደህንነት እና ግላዊነት'},
          ]
        : lang == 'om'
            ? const [
                {'id': 'all', 'label': 'Hunda'},
                {'id': 'reg', 'label': 'Galmee & Seensa'},
                {'id': 'blood', 'label': 'Gosa Dhiigaa & Walsimsiisa'},
                {'id': 'requests', 'label': 'Gaaffilee & Arjooma'},
                {'id': 'health', 'label': 'Fayyaa & Nageenya'},
                {'id': 'centers', 'label': 'Wiirtuuwwan'},
                {'id': 'community', 'label': 'Hawaasa & Sagantaalee'},
                {'id': 'security', 'label': 'Nageenya & Dhuunfaa'},
              ]
            : const [
                {'id': 'all', 'label': 'All'},
                {'id': 'reg', 'label': 'Registration & Login'},
                {'id': 'blood', 'label': 'Blood Type & Compatibility'},
                {'id': 'requests', 'label': 'Requests & Donations'},
                {'id': 'health', 'label': 'Health & Wellness'},
                {'id': 'centers', 'label': 'Centers & Navigation'},
                {'id': 'community', 'label': 'Community & Events'},
                {'id': 'security', 'label': 'Security & Privacy'},
              ];

    final pageTitle = l10n?.donorFaqTitle ?? (lang == 'am' ? 'የለጋሽ ተደጋጋሚ ጥያቄዎች' : lang == 'om' ? 'Gaaffilee Arjoomaa' : 'Help & FAQ');
    final searchHint = lang == 'am'
        ? 'የለጋሽ ጥያቄዎችን፣ የእረፍት ጊዜን፣ የደም ዓይነትን ፈልግ...'
        : lang == 'om'
            ? 'Gaaffilee arjoomaa, boqonnaa, gosa dhiigaa barbaadi...'
            : 'Search donor questions, cooldown, blood type...';

    final noFoundTitle = lang == 'am'
        ? 'ምንም ተዛማጅ ጥያቄዎች አልተገኙም'
        : lang == 'om'
            ? 'Gaaffiin walsimu hin argamne'
            : 'No matching questions found';

    final noFoundDesc = lang == 'am'
        ? 'የፍለጋ ቃላትዎን ወይም የምድብ ማጣሪያዎችን ያስተካክሉ።'
        : lang == 'om'
            ? 'Jecha barbaachaa yookiin calaltuuwwan ramaddii sirreessaa.'
            : 'Try adjusting your keywords or category filters.';

    final resetFiltersText = lang == 'am' ? 'ማጣሪያዎችን አጽዳ' : lang == 'om' ? 'Calaltuuwwan Deebisi' : 'Reset Filters';

    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        title: Text(
          pageTitle,
          style: const TextStyle(
            color: AppColors.ink,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppColors.paper,
        foregroundColor: AppColors.ink,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: _expandedIds.isEmpty ? 'Expand all' : 'Collapse all',
            icon: Icon(
              _expandedIds.isEmpty ? Icons.unfold_more : Icons.unfold_less,
              color: AppColors.crimson,
            ),
            onPressed: () {
              setState(() {
                if (_expandedIds.isEmpty) {
                  _expandedIds.addAll(allFaqs.map((f) => f.id));
                } else {
                  _expandedIds.clear();
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter header
          Container(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.sm),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: AppColors.cardBorder, width: 0.8),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: searchHint,
                    hintStyle: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.paperDim,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: AppSpacing.md,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((cat) {
                      final catId = cat['id']!;
                      final catLabel = cat['label']!;
                      final isSelected = _selectedCategoryId == catId;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          label: Text(catLabel),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedCategoryId = catId);
                            }
                          },
                          selectedColor: AppColors.crimson,
                          backgroundColor: AppColors.paperDim,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppColors.inkSoft,
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          ),
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                            side: BorderSide(
                              color: isSelected ? AppColors.crimson : AppColors.cardBorder,
                              width: 0.8,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // FAQ List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.help_outline,
                            size: 48,
                            color: AppColors.sand,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            noFoundTitle,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            noFoundDesc,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          TextButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _selectedCategoryId = 'all');
                            },
                            child: Text(
                              resetFiltersText,
                              style: const TextStyle(
                                color: AppColors.crimson,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _buildContactCard(context, l10n, lang),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: filtered.length + 1,
                    itemBuilder: (context, index) {
                      if (index == filtered.length) {
                        return _buildContactCard(context, l10n, lang);
                      }

                      final faq = filtered[index];
                      final isExpanded = _expandedIds.contains(faq.id);

                      return Container(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(
                            color: isExpanded
                                ? AppColors.crimson.withValues(alpha: 0.35)
                                : AppColors.cardBorder,
                            width: 0.8,
                          ),
                          boxShadow: isExpanded
                              ? [
                                  BoxShadow(
                                    color: AppColors.crimson.withValues(alpha: 0.04),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  )
                                ]
                              : null,
                        ),
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          child: Theme(
                            data: theme.copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              key: PageStorageKey(faq.id),
                              initiallyExpanded: isExpanded,
                              onExpansionChanged: (_) => _toggleExpanded(faq.id),
                              tilePadding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: 4,
                              ),
                              childrenPadding: const EdgeInsets.fromLTRB(
                                AppSpacing.md,
                                0,
                                AppSpacing.md,
                                AppSpacing.md,
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.crimson.withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      faq.category.toUpperCase(),
                                      style: const TextStyle(
                                        color: AppColors.crimson,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.4,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    faq.question,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.5,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                              children: [
                                const Divider(
                                  color: AppColors.cardBorder,
                                  height: 16,
                                  thickness: 0.6,
                                ),
                                Text(
                                  faq.answer,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13.5,
                                    height: 1.45,
                                  ),
                                ),
                                if (faq.bulletPoints.isNotEmpty) ...[
                                  const SizedBox(height: AppSpacing.sm),
                                  Container(
                                    padding: const EdgeInsets.all(AppSpacing.sm),
                                    decoration: BoxDecoration(
                                      color: AppColors.paperDim,
                                      borderRadius: BorderRadius.circular(AppRadius.sm),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: faq.bulletPoints.map((pt) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 2),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                '• ',
                                                style: TextStyle(
                                                  color: AppColors.crimson,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  pt,
                                                  style: const TextStyle(
                                                    color: AppColors.textPrimary,
                                                    fontSize: 12.5,
                                                    height: 1.35,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleEmailContact(BuildContext context) async {
    const email = 'admin@legash.com';
    final uri = Uri.parse('mailto:$email?subject=Legash%20Donor%20Support');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return;
      }
    } catch (_) {}

    await Clipboard.setData(const ClipboardData(text: email));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Support email copied: admin@legash.com'),
        backgroundColor: AppColors.crimson,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, AppLocalizations? l10n, String lang) {
    final title = l10n?.faqStillQuestions ??
        (lang == 'am' ? 'ተጨማሪ ጥያቄዎች አሉዎት?' : lang == 'om' ? 'Ammas gaaffii qabduu?' : 'Still have questions?');
    final desc = l10n?.faqAskHereAt ??
        (lang == 'am'
            ? 'ሌላ ማንኛውም ጥያቄ ካለዎት admin@legash.com ላይ ይጠይቁ'
            : lang == 'om'
                ? 'Gaaffii biraa yoo qabaattan admin@legash.com irratti gaafadhaa'
                : 'If you have any other questions, ask here at admin@legash.com');

    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.xs, bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.cardBorder, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.mark_email_read_outlined,
                color: AppColors.crimson,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _handleEmailContact(context),
              icon: const Icon(Icons.email_outlined, size: 16),
              label: const Text(
                'admin@legash.com',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.crimson,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
