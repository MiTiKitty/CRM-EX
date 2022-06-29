package com.itCat.crmEX.settings.mapper;

import com.itCat.crmEX.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface UserMapper {

    /**
     * 根据用户名和密码查询用户
     * @param map
     * @return
     */
    User selectUserByUsernameAndPassword(Map<String, Object> map);

    /**
     * 根据用户id查找用户
     * @param id
     * @return
     */
    User selectUserById(String id);

    /**
     * 根据当前用户id修改密码
     * @param map
     * @return
     */
    int updateUserPasswordById(Map<String, Object> map);

    /**
     * 插入一个新的用户数据
     * @param user
     * @return
     */
    int insertNewUser(User user);

    /**
     * 分页查询用户
     * @param map
     * @return
     */
    List<User> selectUsersByPageSize(Map<String, Object> map);

}
