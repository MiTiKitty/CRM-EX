package com.itCat.crmEX.settings.mapper;

import com.itCat.crmEX.settings.domain.Permission;
import com.itCat.crmEX.settings.domain.RolePermissionRelation;

import java.util.List;

public interface RolePermissionRelationMapper {

    /**
     * 根据角色id查找许可信息
     * @param roleId
     * @return
     */
    List<Permission> selectPermissionByRoleId(String roleId);

    /**
     * 批量插入角色许可关联信息
     * @param rolePermissionRelationList
     * @return
     */
    int insertRolePermissionRelation(List<RolePermissionRelation> rolePermissionRelationList);

    /**
     * 批量删除指定id的角色关联关系信息
     * @param ids
     * @return
     */
    int deleteRolePermissionRelationByIds(String[] ids);

    /**
     * 删除该角色id的所有角色许可关联信息
     * @param roleId
     * @return
     */
    int deleteRolePermissionRelationByRoleId(String roleId);

    /**
     * 删除该许可id的所有角色许可关联信息
     * @param permissionId
     * @return
     */
    int deleteRolePermissionRelationByPermissionId(String permissionId);

    /**
     * 删除指定角色id集合的所有角色许可关联信息
     * @param roleIds
     * @return
     */
    int deleteRolePermissionRelationByRoleIds(String[] roleIds);

    /**
     * 删除指定许可id集合的所有角色许可关联信息
     * @param permissionIdList
     * @return
     */
    int deleteRolePermissionRelationByPermissionIds(List<String> permissionIdList);
}
