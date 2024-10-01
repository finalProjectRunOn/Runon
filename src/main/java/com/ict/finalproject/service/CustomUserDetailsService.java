package com.ict.finalproject.service;

import com.ict.finalproject.dao.MemberDAO;
import com.ict.finalproject.dto.CustomUserDetails;
import com.ict.finalproject.vo.MemberVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private MemberDAO dao;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        MemberVO memberVO = dao.findByUsername(username);
        if (memberVO != null) {
            return new CustomUserDetails(memberVO);
        }
        return null;
    }
}