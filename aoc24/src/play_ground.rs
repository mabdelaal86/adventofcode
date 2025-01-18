use std::fmt;

const MONTHS: [&str; 12] = [
    "Muharram",
    "Safar",
    "Rabi' al-awwal",
    "Rabi' al-thani",
    "Jumada al-awwal",
    "Jumada al-thani",
    "Rajab",
    "Sha'ban",
    "Ramadan",
    "Shawal",
    "Dhu al-Qi'dah",
    "Dhu al-Hijjah",
];

#[derive(Debug)]
struct HijriDate {
    year: u16,
    month: u8,
    day: u8,
}

impl HijriDate {
    fn new(year: u16, month: u8, day: u8) -> Self {
        if day < 1 || day > 30 {
            panic!("Invalid day");
        }
        if month < 1 || month > 12 {
            panic!("Invalid month");
        }
        if year < 1 || year > 9999 {
            panic!("Invalid year");
        }
        Self { year, month, day }
    }

    #[allow(dead_code)]
    fn value(&self) -> u32 {
        let year = self.year as u32;
        let month = self.month as u32;
        let day = self.day as u32;

        year * 10000 + month * 100 + day
    }
}

impl fmt::Display for HijriDate {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(
            f,
            "{} {} {}",
            self.day,
            MONTHS[self.month as usize - 1],
            self.year
        )
    }
}

#[allow(dead_code)]
fn next_month(date: &HijriDate) -> HijriDate {
    HijriDate::new(
        if date.month == 12 {
            date.year + 1
        } else {
            date.year
        },
        (date.month % 12) + 1,
        date.day,
    )
}

#[allow(dead_code)]
fn to_next_month(date: &mut HijriDate) {
    date.year = if date.month == 12 {
        date.year + 1
    } else {
        date.year
    };
    date.month = (date.month % 12) + 1;
}

#[allow(dead_code)]
fn prev_month(date: &HijriDate) -> HijriDate {
    if date.month == 1 {
        HijriDate::new(date.year - 1, 12, date.day)
    } else {
        HijriDate::new(date.year, date.month - 1, date.day)
    }
}

#[allow(dead_code)]
fn to_first_day(mut date: HijriDate) {
    date = HijriDate::new(date.year, 1, 1);
    println!("{:?}", date);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_1() {
        let date = HijriDate::new(1443, 12, 15);
        println!("{:?}", date);
        println!("{}", date);
        assert_eq!(date.value(), 14431215);

        let mut next_date = next_month(&date);
        to_next_month(&mut next_date);
        println!("{:?}", next_date);
        println!("{}", next_date);
        assert_eq!(next_date.value(), 14440215);

        let mut mut_date = &mut next_date;
        mut_date.year = 1443;
        let mut binding = HijriDate::new(1443, 12, 15);
        mut_date = &mut binding;
        println!("{:?}", mut_date);

        let prev_date = prev_month(&date);
        println!("{:?}", prev_date);
        println!("{}", prev_date);
        assert_eq!(prev_date.value(), 14431115);
    }
}
