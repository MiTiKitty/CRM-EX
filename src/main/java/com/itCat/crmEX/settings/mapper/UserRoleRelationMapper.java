package com.itCat.crmEX.settings.mapper;

import com.itCat.crmEX.settings.domain.UserRoleRelation;

import java.util.List;
import java.util.Map;

public interface UserRoleRelationMapper {

    /**
     * 插入单条用户与角色的关联关系
     * @param userRoleRelation
     * @return
     */
    int insertUserRoleRelation(UserRoleRelation userRoleRelation);

    /**
     * 插入多条用户与角色的关联关系
     * @param userRoleRelationList
     * @return
     */
    int insertUserRoleRelations(List<UserRoleRelation> userRoleRelationList);

    /**
     * 根据角色id删除所有与该角色有关的用户角色关联关系
     * @param roleId
     * @return
     */
    int deleteUserRoleRelationByRoleId(String roleId);

    /**
     * 根据角色id集合删除所有与该角色有关的用户角色关联关系
     * @param roleIds
     * @return
     */
    int deleteUserRoleRelationByRoleIds(String[] roleIds);

    /**
     * 根据用户id删除所有与该用户有关的用户角色关联关系
     * @param userId
     * @return
     */
    int deleteUserRoleRelationByUserId(String userId);

    /**
     * 根据用户id集合删除所有与该用户有关的用户角色关联关系
     * @param userIds
     * @return
     */
    int deleteUserRoleRelationByUserIds(String[] userIds);

    /**
     * 根据用户id和角色id列表删除所有相对应的用户角色关联关系
     * @param map
     * @return
     */
    int deleteUserRoleRelationByUserIdAndRoleIds(Map<String, Object> map);

}
