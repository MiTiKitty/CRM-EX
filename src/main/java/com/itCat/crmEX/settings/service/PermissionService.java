package com.itCat.crmEX.settings.service;

import com.itCat.crmEX.settings.domain.Permission;

import java.util.List;

public interface PermissionService {

    List<Permission> queryAllPermission();

    Permission queryPermissionForDetailById(String id);

    List<Permission> queryPermissionForUserByUserId(String userId);

    int savePermission(Permission permission);

    int editPermissionById(Permission permission);

    void removePermissionById(String id);
}
