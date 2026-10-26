// lib/utils/wellness_content.dart
// Hardcoded wellness & donor care guidance for Legash mobile in English, Amharic, and Afaan Oromoo.
// Note: Content is organized by ABO/Rh blood group for user engagement,
// but all nutritional, hydration, and activity guidance is general and
// evidence-based for all whole blood donors. Nutritional requirements are
// NOT genetically determined by ABO blood group.

class WellnessTip {
  final String title;
  final String description;
  final List<String> bulletPoints;

  const WellnessTip({
    required this.title,
    required this.description,
    this.bulletPoints = const [],
  });
}

class DonorWellnessProfile {
  final String bloodType;
  final String engagementNote;
  final List<WellnessTip> foods;
  final List<WellnessTip> activities;
  final List<WellnessTip> mindfulNotes;
  final List<WellnessTip> additionalTips;

  const DonorWellnessProfile({
    required this.bloodType,
    required this.engagementNote,
    required this.foods,
    required this.activities,
    required this.mindfulNotes,
    this.additionalTips = const [],
  });
}

// -------------------------------------------------------------
// ENGLISH WELLNESS CONTENT
// -------------------------------------------------------------
final List<WellnessTip> _sharedFoodsEn = [
  const WellnessTip(
    title: 'Iron-Rich Foods for Healthy Hemoglobin',
    description:
        'Whole blood donation draws upon red cell iron stores. Consuming bioavailable iron helps restore hemoglobin levels safely and consistently.',
    bulletPoints: [
      'Heme iron sources: Lean red meats, poultry, and fish (readily absorbed)',
      'Non-heme iron sources: Lentils, chickpeas, spinach, fortified teff, and kidney beans',
      'Cooking with traditional cast iron cookware can naturally boost dietary iron intake',
    ],
  ),
  const WellnessTip(
    title: 'Vitamin C: The Iron Absorption Synergist',
    description:
        'Vitamin C significantly enhances the absorption of non-heme iron from plant-based foods when consumed in the same meal.',
    bulletPoints: [
      'Citrus fruits (oranges, lemons, limes) and fresh papaya',
      'Tomatoes, bell peppers, and fresh greens paired with lentil stews',
      'Avoid drinking strong tea or coffee during meals, as tannins hinder iron uptake',
    ],
  ),
  const WellnessTip(
    title: 'High-Quality Protein for Cellular Recovery',
    description:
        'Protein supports overall tissue maintenance, plasma volume regeneration, and enzyme synthesis following donation.',
    bulletPoints: [
      'Eggs, legumes, roasted chickpeas (kolo), and dairy products',
      'Lean fish, chicken, and bean-based stews (shiro / misir wat)',
      'Aim for a balanced source of protein across breakfast and dinner',
    ],
  ),
  const WellnessTip(
    title: 'Proactive Hydration & Fluid Intake',
    description:
        'Plasma constitutes roughly 55% of your blood volume and is predominantly water. Replenishing fluids is the fastest way to stabilize blood volume.',
    bulletPoints: [
      'Drink 500 mL (approx. 2 glasses) of water or fruit juice 1-2 hours before donating',
      'Continue drinking generous fluids (water, broth, coconut water) for 24-48 hours after',
      'Avoid dehydrating alcoholic beverages for at least 24 hours post-donation',
    ],
  ),
  const WellnessTip(
    title: 'Sensible Pre- and Post-Donation Meals',
    description:
        'Never donate blood on an empty stomach. A light, nutritious meal keeps blood sugar steady and minimizes lightheadedness.',
    bulletPoints: [
      'Pre-donation: Eat a wholesome snack (e.g., banana, oatmeal, or bread with egg) 1-3 hours prior',
      'Post-donation: Enjoy the snack and juice provided by the blood center before leaving',
      'Avoid high-fat or greasy fried meals immediately before donating, as lipids can cloud blood testing',
    ],
  ),
];

final List<WellnessTip> _sharedActivitiesEn = [
  const WellnessTip(
    title: 'Immediate Post-Donation Rest (First 4-6 Hours)',
    description:
        'Your body requires a few hours to adjust circulatory hemodynamics after giving a unit of blood.',
    bulletPoints: [
      'Keep the phlebotomy bandage clean and dry for at least 4-5 hours',
      'Avoid sudden standing or rushing up stairs immediately following phlebotomy',
      'Take a comfortable 15-20 minute seated rest with refreshment at the center before traveling',
    ],
  ),
  const WellnessTip(
    title: 'Avoid Heavy Exertion & Strenuous Lifting (24 Hours)',
    description:
        'Straining the donation arm can provoke re-bleeding or bruising at the venipuncture site.',
    bulletPoints: [
      'Refrain from heavy gym workouts, distance running, or high-intensity sport for 24 hours',
      'Avoid lifting heavy loads, buckets, or equipment with the donation arm',
      'Opt for relaxed walking or restful indoor routines on donation day',
    ],
  ),
  const WellnessTip(
    title: 'Gradual Return to Normal Exercise',
    description:
        'Most healthy donors feel fully energized within 24 to 48 hours as circulatory fluids normalize.',
    bulletPoints: [
      'Resume light jogs, gentle yoga, and daily walking on day two if feeling well',
      'Listen to your body; if you feel winded or tired, allow additional rest',
      'Ensure adequate hydration before commencing workouts in warm weather',
    ],
  ),
];

final List<WellnessTip> _sharedMindfulNotesEn = [
  const WellnessTip(
    title: 'Managing Lightheadedness or Dizziness',
    description:
        'A transient drop in blood pressure can occur in some donors. Simple postural adjustments restore normal blood flow promptly.',
    bulletPoints: [
      'If you feel dizzy or faint, sit down immediately and place your head between your knees, or lie flat with feet elevated',
      'Do not try to walk off a dizzy spell; stay seated until the sensation completely resolves',
      'Sip cool water or natural fruit juice to aid blood volume recovery',
    ],
  ),
  const WellnessTip(
    title: 'Caring for the Venipuncture Site',
    description:
        'Proper puncture care minimizes tenderness and protects against hematoma or bruising.',
    bulletPoints: [
      'If bleeding restarts through the bandage, apply firm, continuous pressure with a clean cloth and elevate your arm',
      'If bruising or mild soreness occurs, apply a cold pack wrapped in a towel for 10-15 minutes',
      'Avoid picking at the puncture site; allow natural healing over 24-48 hours',
    ],
  ),
  const WellnessTip(
    title: 'Respect the 90-Day Donation Interval',
    description:
        'The human body safely replenishes red cell mass over several weeks. A 90-day cooldown protects long-term iron equilibrium.',
    bulletPoints: [
      'Do not attempt whole blood donation before the 90-day cooldown concludes',
      'Tracking your donation date in Legash keeps your schedule safe and automated',
      'Female donors and regular donors may consider routine ferritin checks with their physician',
    ],
  ),
  const WellnessTip(
    title: 'When to Contact a Healthcare Professional',
    description:
        'Severe symptoms are rare, but prompt communication ensures complete safety and peace of mind.',
    bulletPoints: [
      'Contact your blood center or doctor if dizziness, nausea, or headache persists beyond 24 hours',
      'Seek medical evaluation if severe swelling, spreading redness, or pain develops at the puncture site',
      'Notify the blood bank if you develop an unexpected fever or illness in the days following donation',
    ],
  ),
];

final List<WellnessTip> _sharedAdditionalTipsEn = [
  const WellnessTip(
    title: 'Quality Sleep & Circadian Recovery',
    description:
        'Restful sleep is the foundation of cellular repair, immune health, and erythropoiesis (red blood cell production).',
    bulletPoints: [
      'Aim for 7-8 hours of uninterrupted sleep on the nights before and after donation',
      'Avoid screen exposure 30 minutes before sleep to support deep melatonin release',
    ],
  ),
  const WellnessTip(
    title: 'Consistent Wellness Between Donations',
    description:
        'Being a regular lifesaving donor is a lifelong habit of vitality and community service.',
    bulletPoints: [
      'Maintain a colorful, fiber-rich diet with diverse vegetables, grains, and fruits',
      'Stay consistently hydrated every day, not solely on donation mornings',
    ],
  ),
];

const Map<String, String> _engagementNotesEn = {
  'O+':
      'O+ is the most prevalent blood type in many communities and is constantly in high clinical demand for surgeries, trauma care, and obstetric emergencies. Maintaining strong iron balance and hydration keeps you ready to answer community calls.',
  'O-':
      'O- donors are the universal red blood cell donors. In critical trauma where a patient\'s blood type is unknown, O- blood saves lives first. Consistent nutrition and respecting your 90-day cooldown keep this vital community resource ready.',
  'A+':
      'A+ is one of the most widely requested blood groups for planned hospital surgeries and oncology transfusions. Emphasizing iron-rich staples and steady hydration supports your ongoing donor vitality.',
  'A-':
      'A- red cells can be given to A-, A+, AB-, and AB+ patients, making your donations particularly versatile in regional hospital networks. Balanced meals and recovery care ensure your reserves stay robust.',
  'B+':
      'B+ is an essential blood group for sickle cell management, surgical wards, and regional blood bank stability. Wholesome protein, fresh greens, and good hydration help you bounce back rapidly after giving blood.',
  'B-':
      'B- is a rare blood type in many populations, making every B- donation exceptionally valuable for matching patients. Prioritizing dietary iron and proper post-donation rest keeps your hemoglobin at healthy donor levels.',
  'AB+':
      'AB+ donors are the universal recipients for red cells and universal donors for emergency plasma transfusions. Staying well-hydrated and nourished ensures you feel energized both before and after giving blood.',
  'AB-':
      'AB- is the rarest of all ABO/Rh blood groups. Your contributions provide crucial support for specialized hospital matches. Thoughtful pre-donation meals and gentle recovery activities keep you feeling your best.',
};

// -------------------------------------------------------------
// AMHARIC WELLNESS CONTENT
// -------------------------------------------------------------
final List<WellnessTip> _sharedFoodsAm = [
  const WellnessTip(
    title: 'ለጤናማ ሄሞግሎቢን በብረት የበለፀጉ ምግቦች',
    description:
        'ደም መለገስ የቀይ የደም ሴል የብረት ክምችትን ይጠቀማል። በብረት የበለፀጉ ምግቦችን መመገብ የሄሞግሎቢን መጠንን በአስተማማኝ ሁኔታ ለመመለስ ይረዳል።',
    bulletPoints: [
      'የእንስሳት ብረት ምንጮች፦ ቀይ ስጋ፣ ዶሮ እና ዓሳ (በቀላሉ በሰውነት የሚመጠጡ)',
      'የእፅዋት ብረት ምንጮች፦ ምስር፣ ሽምብራ፣ ቆስጣ፣ ጤፍ እና ባቄላ',
      'በባህላዊ የብረት ድስት ማብሰል የምግብ የብረት ይዘትን በተፈጥሮ ያሳድጋል',
    ],
  ),
  const WellnessTip(
    title: 'ቫይታሚን ሲ፦ የብረት መመጠጥን የሚያፋጥን',
    description:
        'ቫይታሚን ሲ ከእፅዋት የሚገኘውን ብረት ሰውነት በቀላሉ እንዲመጥ ሙሉ እገዛ ያደርጋል።',
    bulletPoints: [
      'የሎሚ ዝርያ ፍራፍሬዎች (ብርቱካን፣ ሎሚ) እና ትኩስ ፓፓያ',
      'ቲማቲም፣ ቃሪያ እና ትኩስ አትክልቶች ከምስር ወጥ ጋር ሲበሉ',
      'በምግብ ወቅት ሻይ ወይም ቡና መጠጣት የብረት መመጠጥን ስለሚቀንስ ያቁሙ',
    ],
  ),
  const WellnessTip(
    title: 'ለፈጣን ማገገም ከፍተኛ ጥራት ያለው ፕሮቲን',
    description:
        'ፕሮቲን የሰውነት ህዋሳትን ለመጠገን፣ የፕላዝማ መጠንን መልሶ ለመተካት እና ኢንዛይሞችን ለማመንጨት አስፈላጊ ነው።',
    bulletPoints: [
      'እንቁላል፣ ጥራጥሬዎች፣ ቆሎ እና የወተት ተዋጽኦዎች',
      'ዓሳ፣ ዶሮ እና የባቄላ ወጦች (ሽሮ እና የምስር ወጥ)',
      'በቁርስ እና በእራት ወቅት የተመጣጠነ የፕሮቲን ምንጭ ለማግኘት ይሞክሩ',
    ],
  ),
  const WellnessTip(
    title: 'በቂ ውሃ እና ፈሳሽ መውሰድ',
    description:
        'የደም ፕላዝማ 55 በመቶ የሚሆነው ፈሳሽ ሲሆን አብዛኛው ውሃ ነው። ፈሳሽ መውሰድ የደም መጠንን በፍጥነት ለማስተካከል ቀዳሚው መንገድ ነው።',
    bulletPoints: [
      'ደም ከመለገስዎ ከ1-2 ሰዓታት በፊት 500 ሚሊ ሊትር (2 ብርጭቆ) ውሃ ወይም ጭማቂ ይጠጡ',
      'ከልገሳ በኋላ ለ24-48 ሰዓታት በቂ ፈሳሽ (ውሃ፣ ሾርባ) መጠጣትዎን ይቀጥሉ',
      'ከልገሳ በኋላ ቢያንስ ለ24 ሰዓታት አልኮል ከመጠጣት ይቆጠቡ',
    ],
  ),
  const WellnessTip(
    title: 'ከልገሳ በፊት እና በኋላ ተገቢ ምግቦች',
    description:
        'በፍፁም ባዶ ሆድ ደም አይለግሱ። ቀላል እና ገንቢ ምግብ የስኳር መጠንን በማስተካከል ራስ ማዞርን ይከላከላል።',
    bulletPoints: [
      'ከልገሳ በፊት፦ ከ1-3 ሰዓታት በፊት ሙዝ፣ አጃ ወይም ዳቦ ከእንቁላል ጋር ይመገቡ',
      'ከልገሳ በኋላ፦ ከደም ማዕከል የሚሰጠውን ብስኩትና ጭማቂ ወስደው ይረፉ',
      'ከልገሳ በፊት ቅባት የበዛባቸው ምግቦችን አይመገቡ፤ ቅባት የደም ምርመራ ውጤትን ሊያዛባ ይችላል',
    ],
  ),
];

final List<WellnessTip> _sharedActivitiesAm = [
  const WellnessTip(
    title: 'ከልገሳ በኋላ ወዲያውኑ የሚደረግ እረፍት (የመጀመሪያዎቹ 4-6 ሰዓታት)',
    description:
        'ሰውነትዎ አንድ ክፍል ደም ከሰጠ በኋላ የደም ዝውውሩን ለማስተካከል ጥቂት ሰዓታት ይፈልጋል።',
    bulletPoints: [
      'የተወጋበትን ማሰሪያ ቢያንስ ለ4-5 ሰዓታት ንጹህና ደረቅ አድርገው ይያዙት',
      'ደም እንደሰጡ ድንገት ከመቆም ወይም ደረጃዎችን በፍጥነት ከመውጣት ይቆጠቡ',
      'ጉዞ ከመጀመርዎ በፊት በማዕከሉ ውስጥ ከ15-20 ደቂቃዎች ተቀምጠው ይረፉ',
    ],
  ),
  const WellnessTip(
    title: 'ከባድ ስራዎችን እና ክብደት ማንሳትን ማስወገድ (24 ሰዓታት)',
    description:
        'ደም የተሰጠበትን እጅ ማድከም ደም እንደገና እንዲፈስ ወይም ቆዳ እንዲያብጥ ሊያደርግ ይችላል።',
    bulletPoints: [
      'ለ24 ሰዓታት ከባድ የአካል ብቃት እንቅስቃሴ፣ የረጅም ርቀት ሩጫ ወይም ስፖርት አያድርጉ',
      'ደም በተወሰደበት እጅ ከባድ እቃዎችን ወይም ባልዲዎችን አያንሱ',
      'በልገሳ ቀን ቀለል ያለ የእግር ጉዞ እና በቤት ውስጥ እረፍት ያድርጉ',
    ],
  ),
  const WellnessTip(
    title: 'ወደ መደበኛ እንቅስቃሴ ቀስ በቀስ መመለስ',
    description:
        'አብዛኛዎቹ ጤናማ ለጋሾች የሰውነት ፈሳሽ ሲስተካከል ከ24 እስከ 48 ሰዓታት ውስጥ ሙሉ ጉልበታቸው ይመለሳል።',
    bulletPoints: [
      'ጥሩ ስሜት ከተሰማዎት በሁለተኛው ቀን ቀላል ሩጫ ወይም የእግር ጉዞ መጀመር ይችላሉ',
      'የሰውነትዎን ስሜት ያዳምጡ፤ ድካም ከተሰማዎት ተጨማሪ እረፍት ይውሰዱ',
      'በሞቃት የአየር ሁኔታ ውስጥ የአካል ብቃት እንቅስቃሴ ከማድረግዎ በፊት በቂ ውሃ ይጠጡ',
    ],
  ),
];

final List<WellnessTip> _sharedMindfulNotesAm = [
  const WellnessTip(
    title: 'የራስ ማዞርን ወይም መዳከምን መቆጣጠር',
    description:
        'በአንዳንድ ለጋሾች ላይ ጊዜያዊ የደም ግፊት መቀነስ ሊከሰት ይችላል። ትክክለኛ የአቀማመጥ እርምጃዎች የደም ዝውውርን በፍጥነት ይመልሳሉ።',
    bulletPoints: [
      'ራስ የማዞር ስሜት ከተሰማዎት ወዲያውኑ ይቀመጡና ጭንቅላትዎን በጉልበቶችዎ መካከል ያድርጉ፣ ወይም እግሮችዎን ከፍ አድርገው ይተኙ',
      'የማዞር ስሜት ሲሰማዎት ለመራመድ አይሞክሩ፤ ስሜቱ ሙሉ በሙሉ እስኪጠፋ ድረስ ተቀምጠው ይቆዩ',
      'የደም መጠን በፍጥነት እንዲመለስ ቀዝቃዛ ውሃ ወይም የተፈጥሮ ፍራፍሬ ጭማቂ ይጠጡ',
    ],
  ),
  const WellnessTip(
    title: 'መርፌ የተወጋበትን ቦታ መንከባከብ',
    description:
        'ትክክለኛ እንክብካቤ ህመምን ይቀንሳል እንዲሁም የደም መርጋት ወይም መጎዳትን ይከላከላል።',
    bulletPoints: [
      'በማሰሪያው ውስጥ ደም መፍሰስ ከጀመረ በንጹህ ጨርቅ አጥብቀው ይያዙ እና እጅዎን ወደ ላይ ያንሱ',
      'መጎዳት ወይም መጠነኛ ህመም ካለ በፎጣ የተጠቀለለ በረዶ ለ10-15 ደቂቃዎች ያድርጉበት',
      'የመርፌውን ቦታ አይጎርጉሩ፤ በ24-48 ሰዓታት ውስጥ በተፈጥሮ እንዲድን ይተዉት',
    ],
  ),
  const WellnessTip(
    title: 'የ90 ቀናት የልገሳ እረፍት ጊዜን ማክበር',
    description:
        'የሰውነት የቀይ የደም ሴሎችን ክምችት መልሶ ለመተካት ጥቂት ሳምንታት ይፈልጋል። የ90 ቀናት እረፍት የረጅም ጊዜ የብረት ሚዛንን ይጠብቃል።',
    bulletPoints: [
      'የ90 ቀናት የእረፍት ጊዜ ከማለቁ በፊት ደም ለመለገስ አይሞክሩ',
      'የልገሳ ቀንዎን በለጋሽ ላይ መከታተል የልገሳ መርሃ ግብርዎን ደህንነቱ የተጠበቀ ያደርገዋል',
      'ሴት ለጋሾች እና ተደጋጋሚ ለጋሾች ከሀኪማቸው ጋር የፌሪቲን ምርመራ ማድረጋቸው ይመከራል',
    ],
  ),
  const WellnessTip(
    title: 'የጤና ባለሙያን ማነጋገር የሚገባው መቼ ነው?',
    description:
        'ከባድ ምልክቶች እምብዛም አይከሰቱም፤ ነገር ግን ፈጣን ግንኙነት ሙሉ ደህንነትን ያረጋግጣል።',
    bulletPoints: [
      'ራስ ማዞር፣ ማቅለሽለሽ ወይም ራስ ምታት ከ24 ሰዓታት በላይ ከቀጠለ የደም ማዕከሉን ወይም ሀኪምዎን ያነጋግሩ',
      'በመርፌው ቦታ ላይ ከባድ እብጠት፣ መቅላት ወይም ህመም ከተፈጠረ የህክምና ክትትል ያድርጉ',
      'ከልገሳ በኋላ ባሉት ቀናት ውስጥ ያልተጠበቀ ትኩሳት ወይም ህመም ከተሰማዎት ለደም ባንኩ ያሳውቁ',
    ],
  ),
];

final List<WellnessTip> _sharedAdditionalTipsAm = [
  const WellnessTip(
    title: 'ጥራት ያለው እንቅልፍ እና የሰውነት ማገገም',
    description:
        'ጥሩ እንቅልፍ ለህዋሳት ጥገና፣ ለበሽታ መከላከያ እና ለቀይ የደም ሴሎች እድገት መሰረት ነው።',
    bulletPoints: [
      'ከልገሳ በፊት እና በኋላ ባሉት ምሽቶች ለ7-8 ሰዓታት ያልተቋረጠ እንቅልፍ ይተኛሉ',
      'ጥልቅ እንቅልፍ እንዲወስድዎት ከመተኛትዎ 30 ደቂቃዎች በፊት የስልክ እና የኮምፒውተር ስክሪን አይመልከቱ',
    ],
  ),
  const WellnessTip(
    title: 'በልገሳዎች መካከል ጤናማ የአኗኗር ዘይቤ',
    description:
        'መደበኛ ህይወት አዳኝ ለጋሽ መሆን ቀጣይነት ያለው የማህበረሰብ አገልግሎት እና የጤንነት ልማድ ነው።',
    bulletPoints: [
      'የተለያዩ አትክልቶችን፣ ጥራጥሬዎችን እና ፍራፍሬዎችን የያዘ የተመጣጠነ ምግብ ይመገቡ',
      'በልገሳ ቀን ብቻ ሳይሆን በየቀኑ በቂ ውሃ የመጠጣት ልማድ ይኑርዎት',
    ],
  ),
];

const Map<String, String> _engagementNotesAm = {
  'O+':
      'O+ በብዙ ማህበረሰቦች ውስጥ በስፋት የሚገኝ የደም አይነት ሲሆን ለቀዶ ጥገና፣ ለአደጋ ጊዜ ህክምና እና ለወሊድ ጊዜ ሁልጊዜ ከፍተኛ ክሊኒካዊ ፍላጎት አለው። ጠንካራ የብረት ሚዛን እና እርጥበት መጠበቅ የማህበረሰብ ጥሪዎችን ለመመለስ ዝግጁ ያደርግዎታል።',
  'O-':
      'የ O- ለጋሾች አለም አቀፍ የቀይ የደም ሴል ለጋሾች ናቸው። የታካሚው የደም አይነት በማይታወቅበት አደገኛ ሁኔታ ውስጥ የ O- ደም በመጀመሪያ ህይወትን ያድናል። የተመጣጠነ ምግብ እና የ90 ቀናት እረፍትዎን ማክበር ይህን ወሳኝ የህይወት አድን ሃብት ዝግጁ ያደርገዋል።',
  'A+':
      'A+ ለሆስፒታል የታቀዱ ቀዶ ጥገናዎች እና ለካንሰር ታካሚዎች በብዛት ከሚፈለጉ የደም ቡድኖች አንዱ ነው። በብረት የበለፀጉ ምግቦችን እና በቂ ፈሳሽ መውሰድ የለጋሽነት ጥንካሬዎን ይደግፋል።',
  'A-':
      'የ A- ቀይ ሴሎች ለ A-፣ A+፣ AB- እና AB+ ታካሚዎች ሊሰጡ ይችላሉ፤ ይህም ልገሳዎ በክልል ሆስፒታሎች ውስጥ ተፈላጊ ያደርገዋል። የተመጣጠነ ምግብ እና የእረፍት እንክብካቤ ክምችትዎ ጠንካራ ሆኖ እንዲቆይ ያረጋግጣል።',
  'B+':
      'B+ ለማጭድ ሴል ህክምና፣ ለቀዶ ጥገና ክፍሎች እና ለክልል የደም ባንኮች ወሳኝ የደም ቡድን ነው። ገንቢ ፕሮቲን፣ ትኩስ አትክልት እና ጥሩ ፈሳሽ ደም ከሰጡ በኋላ በፍጥነት እንዲያገግሙ ይረዱዎታል።',
  'B-':
      'B- በአብዛኛው ማህበረሰብ ውስጥ አነስተኛ ቁጥር ያለው የደም አይነት ሲሆን ይህም እያንዳንዱን የ B- ልገሳ ለተቸገሩ ታካሚዎች እጅግ በጣም ጠቃሚ ያደርገዋል። ለምግብ ብረት እና ለእረፍት ቅድሚያ መስጠት የሄሞግሎቢን መጠንዎን ጤናማ ያደርገዋል።',
  'AB+':
      'የ AB+ ለጋሾች የቀይ የደም ሴል አለም አቀፍ ተቀባዮች እና የአደጋ ጊዜ የፕላዝማ አለም አቀፍ ለጋሾች ናቸው። በቂ ፈሳሽ መውሰድ እና መመገብ ደም ከመስጠትዎ በፊትም ሆነ በኋላ ብርቱ እንዲሆኑ ያደርግዎታል።',
  'AB-':
      'AB- ከሁሉም የ ABO/Rh የደም ቡድኖች በጣም አልፎ አልፎ የሚገኝ ነው። የእርስዎ አስተዋፅኦ ለልዩ የሆስፒታል ፍላጎቶች ወሳኝ ድጋፍ ይሰጣል። ከልገሳ በፊት ተገቢ ምግቦችን መውሰድ እና ረጋ ያሉ እንቅስቃሴዎች ደህንነትዎን ይጠብቃሉ።',
};

// -------------------------------------------------------------
// AFAAN OROMOO WELLNESS CONTENT
// -------------------------------------------------------------
final List<WellnessTip> _sharedFoodsOm = [
  const WellnessTip(
    title: 'Nyaatawwan Sibiilaan Badhaadhan Heemoogiloobiiniif',
    description:
        'Arjoomni dhiigaa kuusaa sibiilaa seelota dhiiga diimaa keessaa fayyadama. Nyaata sibiila qabu soorachuun sadarkaa heemoogiloobiinii sirreessuuf gargaara.',
    bulletPoints: [
      'Madda sibiila beeyladaa: Foon diimaa, handaqqoo fi qurxummii (salphaatti qaamatti kan xuuxamu)',
      'Madda sibiila biqiltootaa: Misira, shumburaa, qoccoo, xaafii fi baaqelaa',
      'Meeshaa sibiila aadaatiin nyaata bilcheessuun qabiyyee sibiilaa dabala',
    ],
  ),
  const WellnessTip(
    title: 'Vaayitaaminii C: Xuuxamuu Sibiilaa Kan Kakaasu',
    description:
        'Vaayitaaminiin C sibiila biqiltoota irraa argamu qaamni akka salphaatti xuuxatuuf humna guddaa qaba.',
    bulletPoints: [
      'Fuduraalee dhangaggoo (burtukaana, loomii) fi paappaayyaa haaraa',
      'Timaatima, barbaree fi baala haaraa ittolee misiraa wajjin soorachuu',
      'Yeroo nyaataa shaayii yookiin buna cimaa dhuguu dhiisaa; xuuxamuu sibiilaa ni hir\'isa',
    ],
  ),
  const WellnessTip(
    title: 'Pirootiinii Qulqullina Ol\'aanaa Qabu',
    description:
        'Pirootiiniin seelota qaamaa suphuu, hamma pilaasmaa bakka buusuu fi inzaayimoota oomishuuf barbaachisaadha.',
    bulletPoints: [
      'Hanqaaquu, baaqelaa, qoloofi bu\'aalee aannanii',
      'Qurxummii, foon handaqqoo fi ittoo shiroo/misiraa',
      'Ciree fi laaqana irratti madda pirootiinii madaalawaa argachuuf carraaqaa',
    ],
  ),
  const WellnessTip(
    title: 'Dhangala\'aa fi Bishaan Ga\'aa Dhuguu',
    description:
        'Pilaasmaan dhiiga keessanii dhibbeentaa 55 kan ta\'u dhangala\'aa yoo ta\'u irra jireessi isaa bishaani. Dhangala\'aa dhuguun hamma dhiigaa dafee sirreessa.',
    bulletPoints: [
      'Dhiiga arjoomuuf sa\'aatii 1-2 dura bishaan yookiin cuunfaa fuduraa miiliiliitira 500 (burcuqqoo 2) dhugaa',
      'Arjooma booda guyyoota 1-2f bishaan fi dhangala\'aa ga\'aa dhuguu itti fufaa',
      'Arjooma booda yoo xiqqaate sa\'aatii 24f dhugaatii alkoolii irraa of qusadhaa',
    ],
  ),
  const WellnessTip(
    title: 'Nyaata Sirrii Arjooma Duraa fi Boodaa',
    description:
        'Garaa duwwaa matumaa dhiiga hin arjoominaa. Nyaanni salphaan sukkaara dhiigaa eeguun mataa bowwuu ittisa.',
    bulletPoints: [
      'Arjooma dura: Sa\'aatii 1-3 dura muuzii, ootmii yookiin daabboo hanqaaquu wajjin nyaadhaa',
      'Arjooma booda: Cuunfaa fi biskiitii wiirtuu dhiigaa irraa kennamu fudhadhaa boqodhaa',
      'Arjooma dura nyaata cooma baay\'ee qabu hin sooratinaa; qorannoo dhiigaa jeeqaruu danda\'a',
    ],
  ),
];

final List<WellnessTip> _sharedActivitiesOm = [
  const WellnessTip(
    title: 'Boqonnaa Battalaa Arjooma Boodaa (Sa\'aatii 4-6 Duraa)',
    description:
        'Qaamni keessan dhiiga kenname booda dhiibbaa dhiigaa sirreessuuf sa\'aatii muraasa barbaada.',
    bulletPoints: [
      'Bakka waraanname yoo xiqqaate sa\'aatii 4-5f qulqulluu fi gogaa godhaa tursiisaa',
      'Dhiiga erga kennitanii booda tasa dhaabbachuu yookiin dafanii tabba ba\'uu irraa of qusadhaa',
      'Imala eegaluun dura wiirtuu dhiigaa keessatti daqiiqaa 15-20 taa\'aatii boqodhaa',
    ],
  ),
  const WellnessTip(
    title: 'Hojiilee Cimaa fi Ulfaatina Kaasuu Dhiisuu (Sa\'aatii 24)',
    description:
        'Harka dhiigni irraa fudhatame dadhabsiisuun dhiigni akka deebi\'ee dhangala\'u gochuu danda\'a.',
    bulletPoints: [
      'Sa\'aatii 24f jimnastikii cimaa, fiigicha dheeraa yookiin ispoortii cimaa hin hojjetinaa',
      'Harka dhiigni keessaa baheen meeshaa ulfaataa yookiin baaldii hin kaasinaa',
      'Guyyaa arjoomaatti deemsa miilaa salphaa fi boqonnaa mana keessaa filadhaa',
    ],
  ),
  const WellnessTip(
    title: 'Suuta Sochii Idileetti Deebi\'uu',
    description:
        'Arjoomtoonni fayyaa qaban dhangala\'aan qaamaa yoo sirraa\'e sa\'aatii 24 hanga 48 keessatti humna isaanii guutuu argatu.',
    bulletPoints: [
      'Yoo nagaan isinitti dhaga\'ame guyyaa lammaffaatti fiigicha salphaa fi sochii eegaluu dandeessu',
      'Qaama keessan dhaggeeffadhaa; dadhabbiin yoo jiraate boqonnaa dabalataa fudhadhaa',
      'Qilleensa ho\'aa keessatti sochii hojjechuun dura bishaan ga\'aa dhugaa',
    ],
  ),
];

final List<WellnessTip> _sharedMindfulNotesOm = [
  const WellnessTip(
    title: 'Mataa Naannessuu fi Dadhabina To\'achuu',
    description:
        'Arjoomtoota muraasa irratti dhiibbaan dhiigaa yeroof gadi bu\'uu danda\'a. Taa\'umsa sirreessuun battalatti furmaata kenna.',
    bulletPoints: [
      'Mataan yoo isin naannesse battalatti taa\'aatii mataa keessan jilba gidduu godhaa, yookiin miila ol kaasaatii ciisaa',
      'Yeroo mataan naannawu deemuuf hin yaalinaa; hamma nagaan isinitti dhaga\'amutti taa\'aa',
      'Bishaan qabbanaawaa yookiin cuunfaa fuduraa dhuguun hamma dhiigaa deebisaa',
    ],
  ),
  const WellnessTip(
    title: 'Bakka Lilmoon Waraane Kunuunsuu',
    description:
        'Kunuunsi gaariin miidhaa salphisa; dhiitahuu fi dhiigni cimmiraahuu irraa eega.',
    bulletPoints: [
      'Yoo dhiigni kuullaa keessaa ba\'e huccuu qulqulluun qabaatii harka ol qabaa',
      'Yoo dhiitahe cabbii huccuutti maraatii daqiiqaa 10-15 irra kaa\'aa',
      'Bakka waraanname hin qoccolinaa; sa\'aatii 24-48 keessatti ofumaan akka fayyu dhiisaa',
    ],
  ),
  const WellnessTip(
    title: 'Boqonnaa Guyyoota 90 Kabajuu',
    description:
        'Qaamni namaa seelota dhiiga diimaa guutuuf torban muraasa barbaada. Boqonnaan guyyaa 90 madaallii sibiilaa eega.',
    bulletPoints: [
      'Boqonnaan guyyoota 90 osoo hin xumuramin dhiiga arjoomuuf hin yaalinaa',
      'Guyyaa arjooma keessanii Legaash irratti hordofuun sagantaa keessan nageenyaan eega',
      'Arjoomtoonni dubartootaa fi kan yeroo baay\'ee arjooman qorannoo feeritiinii gochuun ni gorfama',
    ],
  ),
  const WellnessTip(
    title: 'Ogeessa Yaalaa Yoom Qunnamuu Qabdu?',
    description:
        'Mallattoon cimaan yeroo baay\'ee hin uumamu; garuu qunnamtii ariifachiisaan nageenya guutuu mirkaneessa.',
    bulletPoints: [
      'Mataa naannessuun yookiin ol-deebisuun sa\'aatii 24 ol yoo ture wiirtuu dhiigaa yookiin ogeessa yaalaa qunnamaa',
      'Bakka lilmoon waraane yoo dhiitahe, diimate yookiin dhukkubbiin cime gara yaalaatti deemaa',
      'Arjooma booda guyyoota muraasa keessatti ho\'i qaamaa yoo dabale baankii dhiigaatti beeksisaa',
    ],
  ),
];

final List<WellnessTip> _sharedAdditionalTipsOm = [
  const WellnessTip(
    title: 'Hirriba Qulqulluu fi Bayyanannaa Qaamaa',
    description:
        'Hirribni gaariin suphaa seelotaaf, dhibee ittisuuf, fi seelota dhiiga diimaa haaraa oomishuuf bu\'uuraadha.',
    bulletPoints: [
      'Arjooma duraa fi booda halkan sa\'aatii 7-8 hirriba walirraa hin cinne rafaa',
      'Hirriba gaarii argachuuf rafuun dura daqiiqaa 30f bilbila yookiin iskiriinii ilaaluu dhiisaa',
    ],
  ),
  const WellnessTip(
    title: 'Amala Fayyaa Arjoomawwan Gidduutti',
    description:
        'Arjoomaa lubbuu baraaru ta\'uun amala gaarii jireenyaa fi tajaajila hawaasaa yeroo hundaati.',
    bulletPoints: [
      'Nyaata madaalawaa kuduraalee, muduraalee fi midhaaniin badhaadhe sooradhaa',
      'Guyyaa arjoomaa qofa osoo hin taane guyyaa hunda bishaan ga\'aa dhuguu amaleeffadhaa',
    ],
  ),
];

const Map<String, String> _engagementNotesOm = {
  'O+':
      'O+ hawaasa baay\'ee keessatti gosa dhiigaa baay\'ee jiru yoo ta\'u, baqaqsanii hodhuu, balaa tasaa, fi ciniinsuuf yeroo hunda fedhii guddaa qaba. Madaallii sibiilaa fi bishaan eeguun gaaffii hawaasaatiif qophaa\'aa isin godha.',
  'O-':
      'Arjoomtoonni O- arjoomtoota seelii dhiiga diimaa addunyaati. Haala balaa cimaa gosi dhiiga dhukkubsataa hin beekamnetti, dhiigni O- lubbuu baraara. Nyaata madaalawaa fi boqonnaa guyyaa 90 kabajuun qabeenya lubbuu baraaru kana qopheessa.',
  'A+':
      'A+ hospitaalota keessatti baqaqsanii hodhuu fi waldhaansa kaansariitiif dhiiga baay\'inaan barbaadamu keessaa isa tokkodha. Nyaata sibiila qabu fi bishaan dhuguun cimina arjooma keessanii deeggara.',
  'A-':
      'Seelonni A- dhukkubsattoota A-, A+, AB-, fi AB+ ta\'aniif kennamuu danda\'u; kunis arjooma keessan hospitaalota keessatti baay\'ee barbaadamaa taasisa. Nyaata madaalawaan kuusaa keessan jabeessa.',
  'B+':
      'B+ dhibee dhiigaa sikil-seelii to\'achuuf, kutaa baqaqsanii hodhuuf, fi baankii dhiigaatiif gosa dhiigaa murteessaadha. Pirootiinii gaarii, baala haaraa fi bishaan dhuguun daftanii akka bayyanattan isin gargaara.',
  'B-':
      'B- hawaasa keessatti gosa dhiigaa muraasa yoo ta\'u, arjoomni B- hundi dhukkubsattoota walsimaniif gatii ol\'aanaa qaba. Sibiila nyaataa fi boqonnaadhaaf dursa kennuun heemoogiloobiinii keessan fayyaa godha.',
  'AB+':
      'Arjoomtoonni AB+ fudhattoota dhiiga diimaa addunyaa fi arjoomtoota pilaasmaa balaa tasaa addunyaati. Bishaan ga\'aa dhuguu fi nyaata gaariin arjooma duraa fi booda humna akka qabaattan taasisa.',
  'AB-':
      'AB- gosoota dhiigaa ABO/Rh hunda keessaa isa baay\'ee qaalii fi muraasa ta\'eedha. Gumaachi keessan fedhii hospitaalaatiif deeggarsa murteessaa kenna. Nyaata sirrii fi boqonnaa gaariin nagaa keessan eega.',
};

// -------------------------------------------------------------
// PUBLIC API & PROFILE FACTORIES
// -------------------------------------------------------------
DonorWellnessProfile getWellnessForBloodType(String? bloodType, [String languageCode = 'en']) {
  final normalized = bloodType?.trim().toUpperCase();
  final isKnown = normalized != null && _engagementNotesEn.containsKey(normalized);
  final resolvedType = isKnown ? normalized : 'Unknown';

  if (languageCode == 'am') {
    final note = isKnown
        ? _engagementNotesAm[resolvedType]!
        : 'የደም ዓይነትዎን ማወቅዎ ለጋሽ በአካባቢዎ ካሉ አስቸኳይ የሆስፒታል ጥያቄዎች ጋር እንዲያዛምድዎት ያስችላል። የደም ዓይነትዎን በነጻ ለማወቅ ማንኛውንም የክልል የደም ማዕከል ይጎብኙ!';

    return DonorWellnessProfile(
      bloodType: resolvedType,
      engagementNote: note,
      foods: _sharedFoodsAm,
      activities: _sharedActivitiesAm,
      mindfulNotes: _sharedMindfulNotesAm,
      additionalTips: _sharedAdditionalTipsAm,
    );
  }

  if (languageCode == 'om') {
    final note = isKnown
        ? _engagementNotesOm[resolvedType]!
        : 'Gosa dhiiga keessanii beekuun Legaashiin gaaffilee ariifachiisaa hospitaalaa naannoo keessanii wajjin akka walitti isin fidu dandeessisa. Gosa dhiiga keessanii tola beekuuf wiirtuu dhiigaa naannoo kamiyyuu daawwadhaa!';

    return DonorWellnessProfile(
      bloodType: resolvedType,
      engagementNote: note,
      foods: _sharedFoodsOm,
      activities: _sharedActivitiesOm,
      mindfulNotes: _sharedMindfulNotesOm,
      additionalTips: _sharedAdditionalTipsOm,
    );
  }

  // Default English
  final note = isKnown
      ? _engagementNotesEn[resolvedType]!
      : 'Knowing your blood type helps Legash match you with urgent local requests where your blood group is needed most. Visit any regional blood center to discover your type for free!';

  return DonorWellnessProfile(
    bloodType: resolvedType,
    engagementNote: note,
    foods: _sharedFoodsEn,
    activities: _sharedActivitiesEn,
    mindfulNotes: _sharedMindfulNotesEn,
    additionalTips: _sharedAdditionalTipsEn,
  );
}

// Backwards-compatible aliases
final Map<String, DonorWellnessProfile> wellnessByBloodType = {
  for (final type in ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'])
    type: getWellnessForBloodType(type, 'en'),
};
// ignore: non_constant_identifier_names
final Map<String, DonorWellnessProfile> WELLNESS_BY_BLOOD_TYPE = wellnessByBloodType;

final DonorWellnessProfile generalWellnessProfile = getWellnessForBloodType(null, 'en');
// ignore: non_constant_identifier_names
final DonorWellnessProfile GENERAL_WELLNESS_PROFILE = generalWellnessProfile;
