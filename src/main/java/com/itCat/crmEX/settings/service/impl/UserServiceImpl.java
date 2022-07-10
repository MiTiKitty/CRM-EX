package com.itCat.crmEX.settings.service.impl;

import com.itCat.crmEX.settings.domain.User;
import com.itCat.crmEX.settings.mapper.UserMapper;
import com.itCat.crmEX.settings.mapper.UserRoleRelationMapper;
import com.itCat.crmEX.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("userService")
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private UserRoleRelationMapper userRoleRelationMapper;

    @Override
    public List<User> queryAllUserForOption() {
        return userMapper.selectAllUserForOption();
    }

    @Override
    public List<User> queryUsersByCondition(Map<String, Object> map) {
        return userMapper.selectUsersByCondition(map);
    }

    public User queryUserByUsernameAndPassword(Map<String, Object> map) {
        return userMapper.selectUserByUsernameAndPassword(map);
    }

    public User queryUserById(String id) {
        return userMapper.selectUserById(id);
    }

    @Override
    public User queryUserForDetailById(String id) {
        return userMapper.selectUserForDetailById(id);
    }

    @Override
    public int queryUserCountByUsername(String username) {
        return userMapper.selectUserCountByUsername(username);
    }

    @Override
    public int queryAllUserCountByCondition(Map<String, Object> map) {
        return userMapper.selectAllUserCountByCondition(map);
    }

    public int editUserPasswordById(Map<String, Object> map) {
        return userMapper.updateUserPasswordById(map);
    }

    public int saveNewUser(User user) {
        return userMapper.insertNewUser(user);
    }

    @Override
    public int editUserById(User user) {
        return userMapper.updateUserById(user);
    }

    @Override
    public int editUserLockStatusById(Map<String, Object> map) {
        return userMapper.updateUserLockStatusById(map);
    }

    @Override
    public void removeUsersById(String[] ids) {
        userRoleRelationMapper.deleteUserRoleRelationByUserIds(ids);
        userMapper.deleteUsersById(ids);
    }
}
