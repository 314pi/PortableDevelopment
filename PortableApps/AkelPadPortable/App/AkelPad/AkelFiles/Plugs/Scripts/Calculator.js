// http://akelpad.sourceforge.net/en/plugins.php#Scripts
// Version: 1.0
// Author: Shengalts Aleksander aka Instructor
//
//
// Description(1033): Text calculator (based on wisgest code).
//
// How to use:
// Select expression and call script.
//
// Constants:
// E       -Euler's constant, the base of natural logarithms. Approximately equal to 2.718.
// LN2     -The natural logarithm of 2. Approximately equal to 0.693.
// LN10    -The natural logarithm of 10. Approximately equal to 2.302.
// LOG2E   -The base-2 logarithm of e, Euler's constant. Approximately equal to 1.442.
// LOG10E  -The base-10 logarithm of e, Euler's constant. Approximately equal to 0.434.
// PI      -The ratio of the circumference of a circle to its diameter. Approximately equal to 3.141592653589793.
// SQRT1_2 -The square root of 0.5, or one divided by the square root of 2. Approximately equal to 0.707.
// SQRT2   -The square root of 2. Approximately equal to 1.414.
//
// Functions:
// abs     -The absolute value of a number.
// acos    -The arccosine of a number.
// asin    -The arcsine of a number.
// atan    -The arctangent of a number.
// atan2   -The angle (in radians) from the X axis to a point (y,x).
// ceil    -The smallest integer greater than or equal to its numeric argument.
// cos     -The cosine of a number.
// exp     -e (the base of natural logarithms) raised to a power.
// floor   -The greatest integer less than or equal to its numeric argument.
// log     -The natural logarithm of a number.
// max     -The greater of zero or more supplied numeric expressions.
// min     -The lesser of zero or more supplied numeric expressions.
// pow     -The value of a base expression taken to a specified power.
// random  -A pseudorandom number between 0 and 1.
// round   -A supplied numeric expression rounded to the nearest integer.
// sin     -The sine of a number.
// sqrt    -The square root of a number.
// tan     -The tangent of a number.
//
// Examples:
// 56 * 13
// Result: 728
//
// sin(PI/2)
// Result: 1
//
// res=0; for (i=1; i<=500; ++i) res=res+i*i;
// Result: 41791750
//
// x=34+56; Trace(x, "Intermediate result:"); x+26;
// Result: 116
//
// Trace(34+56)+26
// Result: 116
//
//
// Description(1049): ��������� ����������� (������� �� ���� wisgest'a).
//
// ��� ������������:
// �������� ��������� � �������� ������.
//
// ���������:
// E       -��������� ����������� ����������, �������� �������������� ����� 2.718. ������ �� ��� �������� ��������� ����������.
// LN2     -���������, ������������ ����������� �������� ����� 2, �������������� ����� 0.693.
// LN10    -���������, ������������ ����������� �������� ����� ������, �������������� ����� 2.302.
// LOG2E   -���������, �������������� �������� � ���������� 2 ����� E, �������������� ����� 1.442.
// LOG10E  -���������, �������������� �������� � ���������� 10 ����� E, �������������� ����� 0.434.
// PI      -�������� pi - ��� ��������� ����� ���������� � ��������, �������������� ������ 3.14159.
// SQRT1_2 -���������� ������ �� 0.5, �������������� ����� 0.707.
// SQRT2   -���������� ������ �� ����� ���, �������������� ����� 1.414.
//
// �������:
// abs     -���������� ���������� �������� ���������� �����.
// acos    -���������� ����, ������� �������� ����� ���������� �����.
// asin    -���������� ����, ����� �������� ����� ���������� �����.
// atan    -���������� ����, ������� �������� ����� ���������� �����.
// atan2   -���������� ����, ������� �������� ����� ��������� ���� ��������� �����.
// ceil    -���������� ���������� ����� �����, ������� ������ ��� ����� ���������� �����.
// cos     -���������� ������� ���������� ����.
// exp     -���������� e, ����������� � ��������� �������.
// floor   -���������� ���������� ����� �����, ������� ������ ��� ����� ���������� �����.
// log     -���������� �������� ���������� �����.
// max     -���������� ���������� �� ���� �����.
// min     -���������� ���������� �� ���� �����.
// pow     -���������� ��������� �����, ����������� � ��������� �������.
// random  -���������� ��������� ����� � ��������� ����� 0 � 1.
// round   -���������� ��������� � ���������� �������� �����.
// sin     -���������� ����� ���������� ����.
// sqrt    -���������� ���������� ������ �� ���������� �����.
// tan     -���������� ������� ���������� ����.
//
// �������:
// 56 * 13
// ���������: 728
//
// sin(PI/2)
// ���������: 1
//
// res=0; for (i=1; i<=500; ++i) res=res+i*i;
// ���������: 41791750
//
// x=34+56; Trace(x, "������������� ���������:"); x+26;
// ���������: 116
//
// Trace(34+56)+26
// ���������: 116

//Variables
var hMainWnd=AkelPad.GetMainWnd();
var pSelText=AkelPad.GetSelText();
var bHex=false;
var nResult=0;
var nError;
var WM_USER=1024;

if (pSelText)
{
  pSelText=pSelText.replace(/(\d),(\d)/g, "$1.$2");
  if (pSelText.substr(0, 2) == "0x")
    bHex=true;

  try
  {
    with (Math)
    {
      nResult=eval(pSelText);
    }
  }
  catch (nError)
  {
    AkelPad.MessageBox(hMainWnd, nError.description, WScript.ScriptName, 16 /*MB_ICONERROR*/);
    WScript.Quit();
  }
  Trace(nResult, GetLangString(1));
}
else
{
  AkelPad.MessageBox(hMainWnd, GetLangString(0), WScript.ScriptName, 48 /*MB_ICONEXCLAMATION*/);
}


//Functions
function Trace(nResult, pLabel)
{
  var nValue;

  if (bHex)
  {
    if (nResult < 0) nResult=(0xFFFFFFFF + 1) + nResult;
    nResult="0x" + nResult.toString(16).toUpperCase();
  }
  if (nValue=AkelPad.InputBox(hMainWnd, WScript.ScriptName, pLabel, nResult))
    return parseInt(nValue);
  return nResult;
}

function GetLangString(nStringID)
{
  var nLangID=AkelPad.GetLangId(1 /*LANGID_PRIMARY*/);

  if (nLangID == 0x19) //LANG_RUSSIAN
  {
    if (nStringID == 0)
      return "\u041E\u0442\u0441\u0443\u0442\u0441\u0442\u0432\u0443\u0435\u0442\u0020\u0432\u044B\u0434\u0435\u043B\u0435\u043D\u043D\u044B\u0439\u0020\u0442\u0435\u043A\u0441\u0442\u002E";
    if (nStringID == 1)
      return "\u0418\u0442\u043E\u0433\u043E\u0432\u044B\u0439\u0020\u0440\u0435\u0437\u0443\u043B\u044C\u0442\u0430\u0442\u003A";
  }
  else
  {
    if (nStringID == 0)
      return "No text selected.";
    if (nStringID == 1)
      return "Final result:";
  }
  return "";
}
