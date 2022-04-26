package com.wyn.crm.service.api;

import com.wyn.crm.entity.User;

import java.util.List;


/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/16
 */

public interface UserService {

    User getAdminByLoginAcct(String username,String password);

    List<User> getAllUsers();
}
