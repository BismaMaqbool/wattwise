import '../services/language_controller.dart';

const Map<String, String> _ur = {
  // Login
  'Know your bill before it arrives.': 'بل آنے سے پہلے اپنا بل جانیں۔',
  'Welcome back! Sign in to continue.':
      'خوش آمدید! جاری رکھنے کے لیے سائن ان کریں۔',
  'Create an account to get started.': 'شروع کرنے کے لیے اکاؤنٹ بنائیں۔',
  'Full name': 'پورا نام',
  'Email': 'ای میل',
  'Password': 'پاس ورڈ',
  'Confirm password': 'پاس ورڈ کی تصدیق کریں',
  'Sign in': 'سائن ان',
  'Create account': 'اکاؤنٹ بنائیں',
  'or': 'یا',
  'Continue with Google': 'گوگل کے ساتھ جاری رکھیں',
  "Don't have an account? Sign up": 'اکاؤنٹ نہیں ہے؟ سائن اپ کریں',
  'Already have an account? Sign in': 'پہلے سے اکاؤنٹ ہے؟ سائن ان کریں',
  'Please enter your email and password.':
      'براہ کرم اپنی ای میل اور پاس ورڈ درج کریں۔',
  'Please enter your name.': 'براہ کرم اپنا نام درج کریں۔',
  'Passwords do not match.': 'پاس ورڈ مماثل نہیں ہیں۔',

  // Auth errors
  'That email address is not valid.': 'یہ ای میل ایڈریس درست نہیں ہے۔',
  'Incorrect email or password.': 'ای میل یا پاس ورڈ غلط ہے۔',
  'An account with this email already exists.':
      'اس ای میل کے ساتھ اکاؤنٹ پہلے سے موجود ہے۔',
  'Password must be at least 6 characters.':
      'پاس ورڈ کم از کم 6 حروف کا ہونا چاہیے۔',
  'Your browser blocked the sign-in popup. Please allow popups and try again.':
      'آپ کے براؤزر نے سائن ان پاپ اپ بلاک کر دیا۔ براہ کرم پاپ اپ کی اجازت دے کر دوبارہ کوشش کریں۔',
  'Too many attempts. Please try again later.':
      'بہت زیادہ کوششیں۔ براہ کرم بعد میں دوبارہ کوشش کریں۔',
  'Network error. Check your internet connection.':
      'نیٹ ورک کی خرابی۔ اپنا انٹرنیٹ کنکشن چیک کریں۔',
  'Something went wrong ({code}). Please try again.':
      'کچھ غلط ہو گیا ({code})۔ براہ کرم دوبارہ کوشش کریں۔',

  // Home
  'Edit appliance': 'برقی آلہ میں ترمیم کریں',
  'Add appliance': 'برقی آلہ شامل کریں',
  'Appliance name (e.g. AC)': 'آلے کا نام (مثلاً اے سی)',
  'Power (watts)': 'پاور (واٹ)',
  'Hours used per day': 'روزانہ استعمال کے گھنٹے',
  'Cancel': 'منسوخ کریں',
  'Save': 'محفوظ کریں',
  'Add': 'شامل کریں',
  'there': 'دوست',
  'Hello, {name}!': 'السلام علیکم، {name}!',
  'Estimated bill this month': 'اس ماہ کا تخمینہ شدہ بل',
  '{n} units (kWh)': '{n} یونٹ (kWh)',
  'Protected tariff (approx.)': 'محفوظ ٹیرف (تقریباً)',
  'Unprotected tariff (approx.)': 'غیر محفوظ ٹیرف (تقریباً)',
  'Rates: {note}': 'ریٹس: {note}',
  'Quick add': 'فوری شامل کریں',
  'My appliances ({n})': 'میرے برقی آلات ({n})',
  'Tap an appliance to edit it': 'ترمیم کے لیے کسی آلے پر ٹیپ کریں',
  'No appliances yet.\nTap a chip above or the button below to add one.':
      'ابھی کوئی آلہ نہیں ہے۔\nشامل کرنے کے لیے اوپر کسی آپشن یا نیچے بٹن پر ٹیپ کریں۔',
  '{w}W x {h} h/day': '{w}W × {h} گھنٹے/دن',
  '{n} units': '{n} یونٹ',
  'Delete': 'حذف کریں',
  'Sign out': 'سائن آؤٹ',
  'Switch to light mode': 'لائٹ موڈ پر جائیں',
  'Switch to dark mode': 'ڈارک موڈ پر جائیں',

  // Presets
  'AC 1.5 ton': 'اے سی 1.5 ٹن',
  'Fridge': 'فریج',
  'Fan': 'پنکھا',
  'Iron': 'استری',
  'LED bulb': 'ایل ای ڈی بلب',
  'TV': 'ٹی وی',
  'Washing machine': 'واشنگ مشین',
  'Water pump': 'واٹر پمپ',

  // History buttons
  'Save bill': 'بل محفوظ کریں',
  'History': 'ہسٹری',
  "This month's bill has been saved.": 'اس ماہ کا بل محفوظ ہو گیا۔',
  'Could not save: {e}': 'محفوظ نہیں ہو سکا: {e}',

  // Tips
  'Saving tips': 'بچت کے مشورے',
  '{name} uses the most electricity ({pct}% of your units).':
      '{name} سب سے زیادہ بجلی خرچ کرتا ہے (آپ کے یونٹس کا {pct}%)۔',
  '{name} runs around the clock. Keep it on a medium setting and avoid opening the door often.':
      '{name} پورا دن چلتا ہے۔ اسے درمیانی سیٹنگ پر رکھیں اور دروازہ بار بار نہ کھولیں۔',
  'Using {name} 1 hour less per day could save about Rs. {amt} per month.':
      'روزانہ {name} کو 1 گھنٹہ کم چلانے سے ہر ماہ تقریباً Rs. {amt} بچ سکتے ہیں۔',
  'You are only {n} units below the {limit}-unit limit. Going over it moves you to a higher tariff.':
      'آپ {limit} یونٹ کی حد سے صرف {n} یونٹ نیچے ہیں۔ اس سے اوپر جانے پر زیادہ ٹیرف لگے گا۔',
  'Cutting {n} units would bring you under {limit} units (protected status also depends on your last 6 months of usage).':
      '{n} یونٹ کم کرنے سے آپ {limit} یونٹ سے نیچے آ جائیں گے (محفوظ حیثیت پچھلے 6 ماہ کے استعمال پر بھی منحصر ہے)۔',

  // What-if
  'What-if simulator': 'اگر ایسا کروں تو؟',
  'Change daily usage and see how your bill changes.':
      'روزانہ استعمال بدلیں اور دیکھیں بل کیسے بدلتا ہے۔',
  '{h} hours per day (currently {c})': '{h} گھنٹے روزانہ (فی الحال {c})',
  'New bill: Rs. {n}': 'نیا بل: Rs. {n}',
  'You save Rs. {n} per month': 'آپ ہر ماہ Rs. {n} بچاتے ہیں',
  'Extra cost: Rs. {n} per month': 'اضافی خرچ: Rs. {n} ہر ماہ',

  // Breakdown
  'Where your bill goes': 'آپ کا بل کہاں جا رہا ہے',
  '{u} units  ~Rs. {r}': '{u} یونٹ  ~Rs. {r}',

  // History screen
  'Bill history': 'بل کی ہسٹری',
  'Something went wrong: {e}': 'کچھ غلط ہو گیا: {e}',
  'No saved bills yet.\nTap "Save bill" on the home screen to add this month.':
      'ابھی کوئی محفوظ بل نہیں۔\nاس ماہ کا بل شامل کرنے کے لیے ہوم اسکرین پر "بل محفوظ کریں" دبائیں۔',
  'Monthly bills (Rs.)': 'ماہانہ بل (Rs.)',
  '{u} units  |  {d} vs previous month': '{u} یونٹ  |  پچھلے ماہ سے {d}',
  'Jan': 'جنوری',
  'Feb': 'فروری',
  'Mar': 'مارچ',
  'Apr': 'اپریل',
  'May': 'مئی',
  'Jun': 'جون',
  'Jul': 'جولائی',
  'Aug': 'اگست',
  'Sep': 'ستمبر',
  'Oct': 'اکتوبر',
  'Nov': 'نومبر',
  'Dec': 'دسمبر',

  // Protected status card
  'Protected status': 'محفوظ حیثیت',
  'Protected': 'محفوظ',
  'Unprotected': 'غیر محفوظ',
  "This month's estimate is over {limit} units, so unprotected rates apply.":
      'اس ماہ کا تخمینہ {limit} یونٹ سے زیادہ ہے، اس لیے غیر محفوظ ریٹس لاگو ہوں گے۔',
  'You went over {limit} units in {month}. Protected status returns after {n} months at or below {limit} (around {regain}).':
      'آپ {month} میں {limit} یونٹ سے اوپر گئے تھے۔ {n} ماہ {limit} یونٹ یا اس سے کم رہنے پر محفوظ حیثیت واپس آئے گی (تقریباً {regain})۔',
  'No saved history yet. Save your bill each month so WattWise can track this.':
      'ابھی کوئی ہسٹری محفوظ نہیں۔ ہر ماہ اپنا بل محفوظ کریں تاکہ WattWise اسے ٹریک کر سکے۔',
  'None of your last {k} saved months went over {limit} units.':
      'آپ کے پچھلے {k} محفوظ مہینوں میں سے کوئی بھی {limit} یونٹ سے اوپر نہیں گیا۔',
  '{used} of {limit} units used  |  {left} left':
      '{limit} میں سے {used} یونٹ استعمال  |  {left} باقی',
  'Over the limit by {n} units': 'حد سے {n} یونٹ زیادہ',
  'You are close to the {limit}-unit limit. A few more units will change your tariff.':
      'آپ {limit} یونٹ کی حد کے قریب ہیں۔ چند یونٹ مزید بڑھنے سے آپ کا ٹیرف بدل جائے گا۔',
  'The cliff: at {limit} units your bill is about Rs. {a}. At {next} units it jumps to about Rs. {b}, which is Rs. {d} more for 1 extra unit.':
      'جھٹکا: {limit} یونٹ پر آپ کا بل تقریباً Rs. {a} ہے۔ {next} یونٹ پر یہ تقریباً Rs. {b} ہو جاتا ہے، یعنی صرف 1 یونٹ زیادہ پر Rs. {d} اضافی۔',
  'Use {name} about {h} hours less per day to get back to {limit} units.':
      'روزانہ {name} کو تقریباً {h} گھنٹے کم چلائیں تاکہ آپ {limit} یونٹ پر واپس آ جائیں۔',
  'Cut about {n} units across your appliances to get back under {limit}.':
      'اپنے آلات میں تقریباً {n} یونٹ کم کریں تاکہ آپ {limit} سے نیچے آ جائیں۔',
  'Estimates are approximate. Check the exact protected-consumer rule with your DISCO.':
      'تخمینے تقریبی ہیں۔ محفوظ صارف کا درست اصول اپنی ڈسکو سے تصدیق کریں۔',
};

/// Urdu text for an English key (or the key itself if missing).
String urdu(String en) => _ur[en] ?? en;

/// Translate [en] into the current language and fill {placeholders}.
String tr(String en, [Map<String, Object>? params]) {
  var s = LanguageController.isUrdu ? (_ur[en] ?? en) : en;
  params?.forEach((k, v) {
    s = s.replaceAll('{$k}', '$v');
  });
  return s;
}
