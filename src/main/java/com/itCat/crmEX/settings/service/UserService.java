package com.itCat.crmEX.settings.service;

import com.itCat.crmEX.settings.domain.User;

import java.util.Map;

public interface UserService {

    User queryUserByUsernameAndPassword(Map<String, Object> map);

}
