package com.itCat.crmEX.settings.mapper;

import com.itCat.crmEX.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface UserMapper {

    /**
     * 查找所有的用户供选择使用
     * @return
     */
    List<User> selectAllUserForOption();

    /**
     * 分页查询用户
     * @param map
     * @return
     */
    List<User> selectUsersByCondition(Map<String, Object> map);

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
     * 根据用户id查找用户具体信息
     * @param id
     * @return
     */
    User selectUserForDetailById(String id);

    /**
     * 根据用户名返回该用户数量
     * @param username
     * @return
     */
    int selectUserCountByUsername(String username);

    /**
     * 条件查询用户数据总条数
     * @param map
     * @return
     */
    int selectAllUserCountByCondition(Map<String, Object> map);

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
     * 根据用户id更新用户信息
     * @param user
     * @return
     */
    int updateUserById(User user);

    /**
     * 根据用户id修改用户账号状态
     * @param map
     * @return
     */
    int updateUserLockStatusById(Map<String, Object> map);

    /**
     * 根据用户id集合删除用户信息
     * @param ids
     * @return
     */
    int deleteUsersById(String[] ids);

}
