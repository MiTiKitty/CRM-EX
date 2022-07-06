package com.itCat.crmEX.settings.service.impl;

import com.itCat.crmEX.settings.domain.Permission;
import com.itCat.crmEX.settings.mapper.PermissionMapper;
import com.itCat.crmEX.settings.service.PermissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

@Service("permissionService")
public class PermissionServiceImpl implements PermissionService {

    @Autowired
    private PermissionMapper permissionMapper;

    @Override
    public List<Permission> queryAllPermission() {
        return permissionMapper.selectAllPermission();
    }

    @Override
    public Permission queryPermissionForDetailById(String id) {
        return permissionMapper.selectPermissionForDetailById(id);
    }

    @Override
    public int savePermission(Permission permission) {
        return permissionMapper.insertPermission(permission);
    }

    @Override
    public int editPermissionById(Permission permission) {
        return permissionMapper.updatePermissionById(permission);
    }

    @Override
    public void removePermissionById(String id) {
        List<String> permissionList = new LinkedList<>();
        Queue<String> permissionQueue = new ArrayDeque<>();
        List<String> permissionIdList = null;
        String pid = null;
        permissionQueue.add(id);
        while (!permissionQueue.isEmpty()){
            pid = permissionQueue.poll();
            permissionIdList = permissionMapper.selectPermissionIdsByPid(pid);
            for (String permissionId : permissionIdList) {
                permissionQueue.add(permissionId);
            }
            permissionList.add(pid);
        }
        permissionMapper.deletePermissionByIds(permissionList);
    }
}
