package com.wyn.crm.service.api;

import java.util.List;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/26
 */
public interface CustomerService {
    List<String> queryNameByLikeForAuto(String customerName);
}
