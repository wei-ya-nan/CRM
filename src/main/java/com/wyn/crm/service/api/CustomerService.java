package com.wyn.crm.service.api;

import com.github.pagehelper.PageInfo;
import com.wyn.crm.entity.Customer;
import com.wyn.crm.entity.CustomerRemark;

import java.util.List;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/26
 */
public interface CustomerService {
    List<String> queryNameByLikeForAuto(String customerName);

    List<Customer> getAll();

    PageInfo<Customer> queryPage(String name, String owner, String phone, String website, Integer pageNum, Integer pageSize);

    int saveCust(Customer customer);

    Customer getOne(String id);

    int updateCust(Customer customer);

    Customer getConditionOne(String id);

    List<CustomerRemark> getCustomerRemark(String id);

    int saveRemark(CustomerRemark customerRemark);

    int updateRemark(CustomerRemark customerRemark);

    int deleteRemark(String id);
}
