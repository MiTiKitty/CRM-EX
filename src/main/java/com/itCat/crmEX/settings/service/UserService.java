package com.itCat.crmEX.settings.service;

import com.itCat.crmEX.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface UserService {

    List<User> queryAllUserForOption();

    List<User> queryUsersByCondition(Map<String, Object> map);

    User queryUserByUsernameAndPassword(Map<String, Object> map);

    User queryUserById(String id);

    User queryUserForDetailById(String id);

    int queryUserCountByUsername(String username);

    int queryAllUserCountByCondition(Map<String, Object> map);

    int editUserPasswordById(Map<String, Object> map);

    int saveNewUser(User user);

    int editUserById(User user);

    int editUserLockStatusById(Map<String, Object> map);

    void removeUsersById(String[] ids);

}
