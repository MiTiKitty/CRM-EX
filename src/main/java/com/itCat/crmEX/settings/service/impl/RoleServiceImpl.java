package com.itCat.crmEX.settings.service.impl;

import com.itCat.crmEX.settings.domain.Role;
import com.itCat.crmEX.settings.mapper.RoleMapper;
import com.itCat.crmEX.settings.mapper.RolePermissionRelationMapper;
import com.itCat.crmEX.settings.mapper.UserRoleRelationMapper;
import com.itCat.crmEX.settings.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("roleService")
public class RoleServiceImpl implements RoleService {

    @Autowired
    private RoleMapper roleMapper;

    @Autowired
    private RolePermissionRelationMapper rolePermissionRelationMapper;

    @Autowired
    private UserRoleRelationMapper userRoleRelationMapper;

    @Override
    public List<Role> queryAllRoleByPage(Map<String, Object> map) {
        return roleMapper.selectAllRoleByPage(map);
    }

    @Override
    public int queryAllRoleCount() {
        return roleMapper.selectAllRoleCount();
    }

    @Override
    public Role queryRoleById(String id) {
        return roleMapper.selectRoleById(id);
    }

    @Override
    public Role queryRoleByCode(String code) {
        return roleMapper.selectRoleByCode(code);
    }

    @Override
    public List<Role> queryAllRoleForUserCondition() {
        return roleMapper.selectAllRoleForUserCondition();
    }

    @Override
    public List<Role> queryAllAllotRoleForUserByUserId(String userId) {
        return roleMapper.selectAllAllotRoleForUserByUserId(userId);
    }

    @Override
    public List<Role> queryAllAnnulRoleForUserByUserId(String userId) {
        return roleMapper.selectAllAnnulRoleForUserByUserId(userId);
    }

    @Override
    public int saveRole(Role role) {
        return roleMapper.insertRole(role);
    }

    @Override
    public int editRole(Role role) {
        return roleMapper.updateRole(role);
    }

    @Override
    public void removeRoleByIds(String[] ids) {
        userRoleRelationMapper.deleteUserRoleRelationByRoleIds(ids);
        rolePermissionRelationMapper.deleteRolePermissionRelationByRoleIds(ids);
        roleMapper.deleteRoleByIds(ids);
    }
}
