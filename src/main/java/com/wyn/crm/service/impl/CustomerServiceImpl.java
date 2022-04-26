package com.wyn.crm.service.impl;

import com.wyn.crm.mapper.CustomerMapper;
import com.wyn.crm.mapper.CustomerRemarkMapper;
import com.wyn.crm.service.api.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/26
 */
@Service
public class CustomerServiceImpl implements CustomerService {
    @Autowired
    private CustomerMapper customerMapper;


    public List<String> queryNameByLikeForAuto(String customerName) {
        List<String>  list = customerMapper.queryNameByLikeForAuto(customerName);
        return list;
    }
}
