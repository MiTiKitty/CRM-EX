package com.itCat.crmEX.settings.service;

import com.itCat.crmEX.settings.domain.UserRoleRelation;

import java.util.List;
import java.util.Map;

public interface UserRoleRelationService {

    int saveUserRoleRelation(UserRoleRelation userRoleRelation);

    int saveUserRoleRelation(List<UserRoleRelation> userRoleRelationList);

    int removeUserRoleRelationByRoleId(String roleId);

    /**
     * 根据用户id删除所有与该用户有关的用户角色关联关系
     * @param userId
     * @return
     */
    int removeUserRoleRelationByUserId(String userId);

    /**
     * 根据用户id和角色id列表删除所有相对应的用户角色关联关系
     * @param map
     * @return
     */
    int removeUserRoleRelationByUserIdAndRoleIds(Map<String, Object> map);

}
