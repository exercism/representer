#include "meetup.h"
namespace meetup {
	scheduler::scheduler(boost::gregorian::months_of_year month, int year) : m_month(month), m_year(year)
	{
		boost::gregorian::date dt = boost::gregorian::date(year, month, 1);
		boost::gregorian::date last_day_of_month_dt = dt.end_of_month();
		m_last_day_of_month = last_day_of_month_dt.day();
	}
	boost::gregorian::date scheduler::monteenth() const
	{
		return day_finder(13,19,boost::date_time::Monday);
	}
	boost::gregorian::date scheduler::tuesteenth() const
	{
		return day_finder(13,19,boost::date_time::Tuesday);
	}
	boost::gregorian::date scheduler::wednesteenth() const
	{
		return day_finder(13,19,boost::date_time::Wednesday);
	}
	boost::gregorian::date scheduler::thursteenth() const
	{
		return day_finder(13,19,boost::date_time::Thursday);
	}
	boost::gregorian::date scheduler::friteenth() const
	{
		return day_finder(13,19,boost::date_time::Friday);
	}
	boost::gregorian::date scheduler::saturteenth() const
	{
		return day_finder(13,19,boost::date_time::Saturday);
	}
	boost::gregorian::date scheduler::sunteenth() const
	{
		return day_finder(13,19,boost::date_time::Sunday);
	}
	boost::gregorian::date scheduler::first_monday() const
	{
		return day_finder(1, 7, boost::date_time::Monday);
	}
	boost::gregorian::date scheduler::first_tuesday() const
	{
		return day_finder(1, 7, boost::date_time::Tuesday);
	}
	boost::gregorian::date scheduler::first_wednesday() const
	{
		return day_finder(1, 7, boost::date_time::Wednesday);
	}
	boost::gregorian::date scheduler::first_thursday() const
	{
		return day_finder(1, 7, boost::date_time::Thursday);
	}
	boost::gregorian::date scheduler::first_friday() const
	{
		return day_finder(1, 7, boost::date_time::Friday);
	}
	boost::gregorian::date scheduler::first_saturday() const
	{
		return day_finder(1, 7, boost::date_time::Saturday);
	}
	boost::gregorian::date scheduler::first_sunday() const
	{
		return day_finder(1, 7, boost::date_time::Sunday);
	}
	boost::gregorian::date scheduler::second_monday() const
	{
		return day_finder(8, 14, boost::date_time::Monday);
	}
	boost::gregorian::date scheduler::second_tuesday() const
	{
		return day_finder(8, 14, boost::date_time::Tuesday);
	}
	boost::gregorian::date scheduler::second_wednesday() const
	{
		return day_finder(8, 14, boost::date_time::Wednesday);
	}
	boost::gregorian::date scheduler::second_thursday() const
	{
		return day_finder(8, 14, boost::date_time::Thursday);
	}
	boost::gregorian::date scheduler::second_friday() const
	{
		return day_finder(8, 14, boost::date_time::Friday);
	}
	boost::gregorian::date scheduler::second_saturday() const
	{
		return day_finder(8, 14, boost::date_time::Saturday);
	}
	boost::gregorian::date scheduler::second_sunday() const
	{
		return day_finder(8, 14, boost::date_time::Sunday);
	}
	boost::gregorian::date scheduler::third_monday() const
	{
		return day_finder(15, 21, boost::date_time::Monday);
	}
	boost::gregorian::date scheduler::third_tuesday() const
	{
		return day_finder(15, 21, boost::date_time::Tuesday);
	}
	boost::gregorian::date scheduler::third_wednesday() const
	{
		return day_finder(15, 21, boost::date_time::Wednesday);
	}
	boost::gregorian::date scheduler::third_thursday() const
	{
		return day_finder(15, 21, boost::date_time::Thursday);
	}
	boost::gregorian::date scheduler::third_friday() const
	{
		return day_finder(15, 21, boost::date_time::Friday);
	}
	boost::gregorian::date scheduler::third_saturday() const
	{
		return day_finder(15, 21, boost::date_time::Saturday);
	}
	boost::gregorian::date scheduler::third_sunday() const
	{
		return day_finder(15, 21, boost::date_time::Sunday);
	}
	boost::gregorian::date scheduler::fourth_monday() const
	{
		return day_finder(22, 28, boost::date_time::Monday);
	}
	boost::gregorian::date scheduler::fourth_tuesday() const
	{
		return day_finder(22, 28, boost::date_time::Tuesday);
	}
	boost::gregorian::date scheduler::fourth_wednesday() const
	{
		return day_finder(22, 28, boost::date_time::Wednesday);
	}
	boost::gregorian::date scheduler::fourth_thursday() const
	{
		return day_finder(22, 28, boost::date_time::Thursday);
	}
	boost::gregorian::date scheduler::fourth_friday() const
	{
		return day_finder(22, 28, boost::date_time::Friday);
	}
	boost::gregorian::date scheduler::fourth_saturday() const
	{
		return day_finder(22, 28, boost::date_time::Saturday);
	}
	boost::gregorian::date scheduler::fourth_sunday() const
	{
		return day_finder(22, 28, boost::date_time::Sunday);
	}
	boost::gregorian::date scheduler::last_monday() const
	{
		return day_finder(m_last_day_of_month - 6, m_last_day_of_month, boost::date_time::Monday);
	}
	boost::gregorian::date scheduler::last_tuesday() const
	{
		return day_finder(m_last_day_of_month - 6, m_last_day_of_month, boost::date_time::Tuesday);
	}
	boost::gregorian::date scheduler::last_wednesday() const
	{
		return day_finder(m_last_day_of_month - 6, m_last_day_of_month, boost::date_time::Wednesday);
	}
	boost::gregorian::date scheduler::last_thursday() const
	{
		return day_finder(m_last_day_of_month - 6, m_last_day_of_month, boost::date_time::Thursday);
	}
	boost::gregorian::date scheduler::last_friday() const
	{
		return day_finder(m_last_day_of_month - 6, m_last_day_of_month, boost::date_time::Friday);
	}
	boost::gregorian::date scheduler::last_saturday() const
	{
		return day_finder(m_last_day_of_month - 6, m_last_day_of_month, boost::date_time::Saturday);
	}
	boost::gregorian::date scheduler::last_sunday() const
	{
		return day_finder(m_last_day_of_month - 6, m_last_day_of_month, boost::date_time::Sunday);
	}
	boost::gregorian::date scheduler::day_finder(int start_day, int end_day, boost::date_time::weekdays weekday) const
	{
		int day = start_day;
		boost::gregorian::date dt = boost::gregorian::date(m_year, m_month, day);
		while (day++ <= end_day && dt.day_of_week() != weekday)
		{
			dt = boost::gregorian::date(m_year, m_month, day);
		}
		return dt;
	}
}
