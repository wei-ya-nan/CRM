package com.wyn.crm.service.impl;

import com.wyn.crm.entity.User;
import com.wyn.crm.entity.UserExample;
import com.wyn.crm.mapper.UserMapper;
import com.wyn.crm.service.api.UserService;
import com.wyn.crm.web.exception.LoginException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/16
 */
@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    public User getAdminByLoginAcct(String username, String password) {

        UserExample example = new UserExample();
        UserExample.Criteria criteria = example.createCriteria();
        criteria.andNameEqualTo(username);
        List<User> users = userMapper.selectByExample(example);

        if(users.size() == 0 || users == null || users.get(0) == null){
//            throw new LoginException("用户名或密码错误");
            return null;
        }
        User user = users.get(0);
        String loginPwd = user.getLoginPwd();
        if(!loginPwd.equals(password)){
//            throw new LoginException("用户名或密码错误");
            return null;
        }

        return user;
    }

    public List<User> getAllUsers() {
        List<User> users = userMapper.selectByExample(null);
        return users;
    }
}
