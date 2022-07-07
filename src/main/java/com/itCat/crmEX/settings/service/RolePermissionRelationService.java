package com.itCat.crmEX.settings.service;

import com.itCat.crmEX.settings.domain.Permission;
import com.itCat.crmEX.settings.domain.RolePermissionRelation;

import java.util.List;
import java.util.Map;

public interface RolePermissionRelationService {

    List<Permission> queryPermissionByRoleId(String roleId);

    void saveRolePermissionRelation(Map<String, Object> map);

    int removeRolePermissionRelationByIds(String[] ids);

    int removeRolePermissionByRoleId(String roleId);

    int removeRolePermissionByPermissionId(String permissionId);

    int removeRolePermissionByRoleIds(String[] roleIds);

    int removeRolePermissionByPermissionIds(List<String> permissionIdList);
}
