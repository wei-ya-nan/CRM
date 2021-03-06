package com.wyn.crm.mapper;

import com.wyn.crm.entity.Customer;
import com.wyn.crm.entity.CustomerExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface CustomerMapper {
    int countByExample(CustomerExample example);

    int deleteByExample(CustomerExample example);

    int deleteByPrimaryKey(String id);

    int insert(Customer record);

    int insertSelective(Customer record);

    List<Customer> selectByExample(CustomerExample example);

    Customer selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("record") Customer record, @Param("example") CustomerExample example);

    int updateByExample(@Param("record") Customer record, @Param("example") CustomerExample example);

    int updateByPrimaryKeySelective(Customer record);

    int updateByPrimaryKey(Customer record);

    List<String> queryNameByLikeForAuto(String customerName);

    List<Customer> queryPage(@Param("name") String name, @Param("owner") String owner, @Param("phone") String phone, @Param("website") String website);

    Customer getConditionOne(String id);
}