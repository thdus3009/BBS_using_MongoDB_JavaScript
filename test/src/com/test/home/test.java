package com.test.home;

import java.text.SimpleDateFormat;
import java.util.Date;

public class test {

	public static void main(String[] args) {
		SimpleDateFormat format1 = new  SimpleDateFormat("yyyy-MM-dd");
		
		Date time = new Date();
		
		String result = format1.format(time);
		
		System.out.println(result);
	}
}
