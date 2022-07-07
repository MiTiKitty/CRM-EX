package com.itCat.crmEX.settings.service.impl;

import com.itCat.crmEX.settings.domain.Permission;
import com.itCat.crmEX.settings.domain.RolePermissionRelation;
import com.itCat.crmEX.settings.mapper.RolePermissionRelationMapper;
import com.itCat.crmEX.settings.service.RolePermissionRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("rolePermissionRelationService")
public class RolePermissionRelationServiceImpl implements RolePermissionRelationService {

    @Autowired
    private RolePermissionRelationMapper rolePermissionRelationMapper;

    @Override
    public List<Permission> queryPermissionByRoleId(String roleId) {
        return rolePermissionRelationMapper.selectPermissionByRoleId(roleId);
    }

    @Override
    public void saveRolePermissionRelation(Map<String, Object> map) {
        String roleId = (String) map.get("roleId");
        List<RolePermissionRelation> rolePermissionRelationList = (List<RolePermissionRelation>) map.get("rolePermissionRelationList");
        rolePermissionRelationMapper.deleteRolePermissionRelationByRoleId(roleId);
        rolePermissionRelationMapper.insertRolePermissionRelation(rolePermissionRelationList);
    }

    @Override
    public int removeRolePermissionRelationByIds(String[] ids) {
        return rolePermissionRelationMapper.deleteRolePermissionRelationByIds(ids);
    }

    @Override
    public int removeRolePermissionByRoleId(String roleId) {
        return rolePermissionRelationMapper.deleteRolePermissionRelationByRoleId(roleId);
    }

    @Override
    public int removeRolePermissionByPermissionId(String permissionId) {
        return rolePermissionRelationMapper.deleteRolePermissionRelationByPermissionId(permissionId);
    }

    @Override
    public int removeRolePermissionByRoleIds(String[] roleIds) {
        return rolePermissionRelationMapper.deleteRolePermissionRelationByRoleIds(roleIds);
    }

    @Override
    public int removeRolePermissionByPermissionIds(List<String> permissionIdList) {
        return rolePermissionRelationMapper.deleteRolePermissionRelationByPermissionIds(permissionIdList);
    }
}
