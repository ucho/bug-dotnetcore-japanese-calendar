using System;
using System.Globalization;

namespace ReproduceJapaneseCalendarBug
{
    class Program
    {
        static void Main()
        {
            var cultureInfo = new CultureInfo("ja-JP", false)
            {
                DateTimeFormat = { Calendar = new JapaneseCalendar() }
            };
            var date = DateTime.Parse("令和1年6月1日", cultureInfo);
            Console.WriteLine(date.ToString("yyyy/MM/dd"));
        }
    }
}
