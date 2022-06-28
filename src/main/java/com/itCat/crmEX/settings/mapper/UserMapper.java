package com.itCat.crmEX.settings.mapper;

import com.itCat.crmEX.settings.domain.User;

import java.util.Map;

public interface UserMapper {

    /**
     * 根据用户名和密码查询用户
     * @param map
     * @return
     */
    User selectUserByUsernameAndPassword(Map<String, Object> map);

}
