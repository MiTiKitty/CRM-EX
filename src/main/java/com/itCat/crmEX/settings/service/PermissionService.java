package com.itCat.crmEX.settings.service;

import com.itCat.crmEX.settings.domain.Permission;

import java.util.List;

public interface PermissionService {

    List<Permission> queryAllPermission();

    Permission queryPermissionForDetailById(String id);

    int savePermission(Permission permission);

    int editPermissionById(Permission permission);

    void removePermissionById(String id);
}
