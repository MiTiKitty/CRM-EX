package com.itCat.crmEX.settings.mapper;

import com.itCat.crmEX.settings.domain.Role;

import java.util.List;
import java.util.Map;

public interface RoleMapper {

    /**
     * 分页查询所有角色信息
     * @param map
     * @return
     */
    List<Role> selectAllRoleByPage(Map<String, Object> map);

    /**
     * 查找所有角色的数量
     * @return
     */
    int selectAllRoleCount();

    /**
     * 根据角色id查找角色信息
     * @param id
     * @return
     */
    Role selectRoleById(String id);

    /**
     * 根据角色code查找角色信息
     * @param code
     * @return
     */
    Role selectRoleByCode(String code);

    /**
     * 查找所有角色供用户选择分配
     * @return
     */
    List<Role> selectAllRoleForUserCondition();

    /**
     * 根据用户id查找未被分配的角色数据列表
     * @param userId
     * @return
     */
    List<Role> selectAllAllotRoleForUserByUserId(String userId);

    /**
     * 根据用户id查找已分配的角色数据列表
     * @param userId
     * @return
     */
    List<Role> selectAllAnnulRoleForUserByUserId(String userId);

    /**
     * 插入一个新的角色信息
     * @param role
     * @return
     */
    int insertRole(Role role);

    /**
     * 根据角色id修改角色信息
     * @param role
     * @return
     */
    int updateRole(Role role);

    /**
     * 根据指定角色id集合删除角色信息
     * @param ids
     * @return
     */
    int deleteRoleByIds(String[] ids);
}
