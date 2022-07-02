package com.itCat.crmEX.settings.service;

import com.itCat.crmEX.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface UserService {

    List<User> queryAllUserForOption();

    User queryUserByUsernameAndPassword(Map<String, Object> map);

    User queryUserById(String id);

    int editUserPasswordById(Map<String, Object> map);

    int saveNewUser(User user);

}
