package com.itCat.crmEX.settings.mapper;

import com.itCat.crmEX.settings.domain.Permission;

import java.util.List;

public interface PermissionMapper {

    /**
     * 查找所有的权限
     * @return
     */
    List<Permission> selectAllPermission();

    /**
     * 根据许可id查找该许可的详细信息
     * @param id
     * @return
     */
    Permission selectPermissionForDetailById(String id);

    /**
     * 根据父许可id查找出所有子许可id集合
     * @param pid
     * @return
     */
    List<String> selectPermissionIdsByPid(String pid);

    /**
     * 根据用户id查找用户许可信息
     * @param userId
     * @return
     */
    List<Permission> selectPermissionForUserByUserId(String userId);

    /**
     * 插入一条许可信息
     * @param permission
     * @return
     */
    int insertPermission(Permission permission);

    /**
     * 根据许可id修改许可信息
     * @param permission
     * @return
     */
    int updatePermissionById(Permission permission);

    /**
     * 根据许可编号删除许可
     * @param id
     * @return
     */
    int deletePermissionById(String id);

    /**
     * 根据指定的许可id集合删除许可
     * @param ids
     * @return
     */
    int deletePermissionByIds(List<String> ids);

}
