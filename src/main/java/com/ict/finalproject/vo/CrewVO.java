package com.ict.finalproject.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CrewVO {
    private String crew_name;
    private String logo;
    private String content;
    private String addr;
    private String addr_gu;
    private String area;
    private String gender;
    private String age;
    private String a_s;
    private String b_s;
    private String c_s;
    private String d_s;
    private String e_s;

    private int a_n;
    private int b_n;
    private int c_n;
    private int d_n;
    private int e_n;
    private int is_active;
    private int is_deleted;
    private int is_updated;
    private int max_num;
    private int num;
    private int create_crew_code;
    private int hits;
    private int total_record;
    private int usercode;

    private String deleted_date;
    private String writedate;
    private String updated_date;
    private String activationdate;



}
