package com.itCat.crmEX.settings.mapper;

import com.itCat.crmEX.settings.domain.Department;

import java.util.List;

public interface DepartmentMapper {

    /**
     * 查找所有部门
     * @return
     */
    List<Department> selectAllDepartment();

    /**
     * 根据部门编号查找部门
     * @param number
     * @return
     */
    Department selectDepartmentByNumber(String number);

    /**
     * 根据部门id查找部门
     * @param id
     * @return
     */
    Department selectDepartmentById(String id);

    /**
     * 根据部门名称模糊查询部门信息
     * @param name
     * @return
     */
    List<Department> selectDepartmentsByName(String name);

    /**
     * 插入一个新的部门
     * @param department
     * @return
     */
    int insertDepartment(Department department);

    /**
     * 根据部门id修改部门信息
     * @param department
     * @return
     */
    int updateDepartmentById(Department department);

    /**
     * 根据指定id集合删除部门
     * @param ids
     * @return
     */
    int deleteDepartmentByIds(String[] ids);

}
