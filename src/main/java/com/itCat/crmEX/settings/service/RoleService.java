package com.itCat.crmEX.settings.service;

import com.itCat.crmEX.settings.domain.Role;

import java.util.List;
import java.util.Map;

public interface RoleService {

    List<Role> queryAllRoleByPage(Map<String, Object> map);

    int queryAllRoleCount();

    Role queryRoleById(String id);

    Role queryRoleByCode(String code);

    int saveRole(Role role);

    int editRole(Role role);

    void removeRoleByIds(String[] ids);
}
