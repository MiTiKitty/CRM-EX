package com.itCat.crmEX.settings.service.impl;

import com.itCat.crmEX.settings.domain.User;
import com.itCat.crmEX.settings.mapper.UserMapper;
import com.itCat.crmEX.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service("userService")
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    public User queryUserByUsernameAndPassword(Map<String, Object> map) {
        return userMapper.selectUserByUsernameAndPassword(map);
    }

}
